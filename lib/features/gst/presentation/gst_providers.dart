import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tijori/core/database/app_database.dart';
import 'package:tijori/features/girvi/presentation/girvi_providers.dart';

/// Stream of all GST vouchers, ordered by date descending.
final allGstVouchersProvider =
    StreamProvider.autoDispose<List<GstVoucher>>((ref) {
  final dao = ref.watch(gstVouchersDaoProvider);
  return dao.watchAllVouchers();
});

/// Stream of GST vouchers filtered by a specific type.
final gstVouchersByTypeProvider = StreamProvider.family
    .autoDispose<List<GstVoucher>, GstVoucherType>((ref, type) {
  final dao = ref.watch(gstVouchersDaoProvider);
  return dao.watchVouchersByType(type);
});

/// Immutable summary of GST liabilities and operating metrics.
class GstTaxSummary {
  final double totalTaxableSales;
  final double totalCgstCollected;
  final double totalSgstCollected;
  final double totalTaxCollected;
  final double totalGrossSales;
  final double totalPurchases;
  final double totalExpenses;
  final int totalSalesCount;
  final int totalExpensesCount;

  const GstTaxSummary({
    required this.totalTaxableSales,
    required this.totalCgstCollected,
    required this.totalSgstCollected,
    required this.totalTaxCollected,
    required this.totalGrossSales,
    required this.totalPurchases,
    required this.totalExpenses,
    required this.totalSalesCount,
    required this.totalExpensesCount,
  });

  factory GstTaxSummary.fromVouchers(List<GstVoucher> vouchers) {
    double taxableSales = 0.0;
    double cgst = 0.0;
    double sgst = 0.0;
    double grossSales = 0.0;
    double purchases = 0.0;
    double expenses = 0.0;
    int salesCount = 0;
    int expensesCount = 0;

    for (final v in vouchers) {
      switch (v.voucherType) {
        case GstVoucherType.sale:
          taxableSales += v.taxableAmount;
          cgst += v.cgstAmount;
          sgst += v.sgstAmount;
          grossSales += v.totalAmount;
          salesCount++;
          break;
        case GstVoucherType.purchase:
          purchases += v.totalAmount;
          break;
        case GstVoucherType.expense:
          expenses += v.totalAmount;
          expensesCount++;
          break;
        case GstVoucherType.saleReturn:
          taxableSales -= v.taxableAmount;
          cgst -= v.cgstAmount;
          sgst -= v.sgstAmount;
          grossSales -= v.totalAmount;
          break;
        case GstVoucherType.purchaseReturn:
          purchases -= v.totalAmount;
          break;
        default:
          break;
      }
    }

    return GstTaxSummary(
      totalTaxableSales: taxableSales,
      totalCgstCollected: cgst,
      totalSgstCollected: sgst,
      totalTaxCollected: cgst + sgst,
      totalGrossSales: grossSales,
      totalPurchases: purchases,
      totalExpenses: expenses,
      totalSalesCount: salesCount,
      totalExpensesCount: expensesCount,
    );
  }
}

/// Reactive provider for GST summary metrics.
final gstTaxSummaryProvider = Provider.autoDispose<GstTaxSummary>((ref) {
  final vouchers = ref.watch(allGstVouchersProvider).valueOrNull ?? [];
  return GstTaxSummary.fromVouchers(vouchers);
});

/// A single line entry in the Daybook / Cash Register.
class CashMovementEntry {
  final DateTime date;
  final String referenceNumber;
  final String description;
  final double amount;
  final bool isInflow; // true = Cash In, false = Cash Out
  final String category;

  const CashMovementEntry({
    required this.date,
    required this.referenceNumber,
    required this.description,
    required this.amount,
    required this.isInflow,
    required this.category,
  });
}

/// Comprehensive daily cash register / daybook (Rojnamcha) state.
class DailyCashRegisterState {
  final double totalCashInflows;
  final double totalCashOutflows;
  final double netCashDrawerBalance;
  final List<CashMovementEntry> entries;

  const DailyCashRegisterState({
    required this.totalCashInflows,
    required this.totalCashOutflows,
    required this.netCashDrawerBalance,
    required this.entries,
  });
}

/// Reactive provider calculating the real-time cash drawer balance and audit log.
final dailyCashRegisterProvider =
    Provider.autoDispose<DailyCashRegisterState>((ref) {
  final vouchers = ref.watch(allGstVouchersProvider).valueOrNull ?? [];
  final allLoans = ref.watch(allLoansProvider).valueOrNull ?? [];
  final receiptsDao = ref.watch(loanReceiptsDaoProvider);

  // We can query all loan receipts reactively
  final receiptsStream = receiptsDao.watchAllReceipts();
  final receipts = ref.watch(StreamProvider((_) => receiptsStream)).valueOrNull ?? [];

  final entries = <CashMovementEntry>[];
  double cashIn = 0.0;
  double cashOut = 0.0;

  // 1. Cash Sales & Income (Inflows)
  for (final v in vouchers) {
    if (v.paymentTerm == PaymentTerm.cash) {
      if (v.voucherType == GstVoucherType.sale || v.voucherType == GstVoucherType.income) {
        cashIn += v.totalAmount;
        entries.add(CashMovementEntry(
          date: v.date,
          referenceNumber: v.billNumber,
          description: v.description,
          amount: v.totalAmount,
          isInflow: true,
          category: v.voucherType == GstVoucherType.sale ? 'Jewellery Sale' : 'Income',
        ));
      } else if (v.voucherType == GstVoucherType.expense || v.voucherType == GstVoucherType.purchase) {
        cashOut += v.totalAmount;
        entries.add(CashMovementEntry(
          date: v.date,
          referenceNumber: v.billNumber,
          description: v.description,
          amount: v.totalAmount,
          isInflow: false,
          category: v.voucherType == GstVoucherType.expense ? 'Operating Expense' : 'Metal Purchase',
        ));
      }
    }
  }

  // 2. Girvi Repayments Collected in Cash (Inflows)
  for (final r in receipts) {
    if (r.paymentMode == PaymentMode.cash) {
      cashIn += r.amount;
      entries.add(CashMovementEntry(
        date: r.date,
        referenceNumber: r.receiptNumber,
        description: r.receiptType == ReceiptType.interestOnly
            ? 'Pawn Interest Repayment'
            : 'Pawn Principal Repayment',
        amount: r.amount,
        isInflow: true,
        category: 'Girvi Collection',
      ));
    }
  }

  // 3. New Girvi Loans Sanctioned in Cash (Outflows)
  for (final l in allLoans) {
    if (l.paymentMode == PaymentMode.cash) {
      cashOut += l.principalAmount;
      entries.add(CashMovementEntry(
        date: l.transactionDate,
        referenceNumber: l.slipNumber,
        description: 'Pawn Principal Disbursed: ${l.itemDescription}',
        amount: l.principalAmount,
        isInflow: false,
        category: 'Girvi Loan Outflow',
      ));
    }
  }

  // Sort chronological descending
  entries.sort((a, b) => b.date.compareTo(a.date));

  return DailyCashRegisterState(
    totalCashInflows: cashIn,
    totalCashOutflows: cashOut,
    netCashDrawerBalance: cashIn - cashOut,
    entries: entries,
  );
});
