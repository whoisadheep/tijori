import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tijori/core/database/app_database.dart';
import 'package:tijori/core/utils/girvi_calculator.dart';
import 'package:tijori/core/utils/loan_models.dart' as calc;

/// Watches all active Girvi loans.
final activeLoansProvider = StreamProvider<List<GirviLoan>>((ref) {
  final dao = ref.watch(girviLoansDaoProvider);
  return dao.watchLoansByStatus(LoanStatus.active);
});

/// Watches all Girvi loans regardless of status.
final allLoansProvider = StreamProvider<List<GirviLoan>>((ref) {
  final dao = ref.watch(girviLoansDaoProvider);
  return dao.watchAllLoans();
});

/// Watches a single loan by its primary key [loanId].
final loanDetailProvider = StreamProvider.family<GirviLoan?, int>((ref, loanId) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.girviLoans)..where((t) => t.id.equals(loanId)))
      .watchSingleOrNull();
});

/// Watches all receipts recorded against [loanId].
final loanReceiptsProvider =
    StreamProvider.family<List<LoanReceipt>, int>((ref, loanId) {
  final dao = ref.watch(loanReceiptsDaoProvider);
  return dao.watchReceiptsForLoan(loanId);
});

/// Computes the real-time financial ledger (outstanding principal, accrued interest,
/// pending balance) for a specific [loanId] as of current timestamp.
final loanLedgerProvider =
    StreamProvider.family<calc.LoanLedgerSummary?, int>((ref, loanId) {
  final loanAsync = ref.watch(loanDetailProvider(loanId));
  final receiptsAsync = ref.watch(loanReceiptsProvider(loanId));

  return loanAsync.when(
    data: (loan) {
      if (loan == null) return Stream.value(null);

      return receiptsAsync.when(
        data: (receipts) {
          final entries = receipts.map((r) {
            return calc.LoanReceiptEntry(
              date: r.date,
              type: r.receiptType == ReceiptType.interestOnly
                  ? calc.ReceiptType.interestOnly
                  : calc.ReceiptType.principalRepayment,
              amount: r.amount,
            );
          }).toList();

          final calcInterestType = loan.interestType == InterestType.dayWise
              ? calc.InterestType.dayWise
              : calc.InterestType.monthWise;

          // For closed loans, cap calculation date at the latest receipt date to prevent indefinite accrual
          final calcDate = loan.status == LoanStatus.closed && entries.isNotEmpty
              ? entries.map((e) => e.date).reduce((a, b) => a.isAfter(b) ? a : b)
              : DateTime.now();

          final ledger = GirviCalculator.computeLoanLedger(
            initialPrincipal: loan.principalAmount,
            roi: loan.roi,
            interestType: calcInterestType,
            interestStartDate: loan.interestStartDate,
            calculationDate: calcDate,
            receipts: entries,
          );

          return Stream.value(ledger);
        },
        loading: () => Stream.value(null),
        error: (_, __) => Stream.value(null),
      );
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});

/// High-level portfolio statistics for the Dashboard & List header.
class GirviStats {
  final int activeLoansCount;
  final double totalPrincipal;
  final double totalEstimatedValuation;
  final double totalGoldGrossWeight;
  final double totalSilverGrossWeight;

  const GirviStats({
    required this.activeLoansCount,
    required this.totalPrincipal,
    required this.totalEstimatedValuation,
    required this.totalGoldGrossWeight,
    required this.totalSilverGrossWeight,
  });

  factory GirviStats.zero() => const GirviStats(
        activeLoansCount: 0,
        totalPrincipal: 0,
        totalEstimatedValuation: 0,
        totalGoldGrossWeight: 0,
        totalSilverGrossWeight: 0,
      );
}

final girviStatsProvider = Provider<GirviStats>((ref) {
  final loansAsync = ref.watch(activeLoansProvider);
  return loansAsync.when(
    data: (loans) {
      final count = loans.length;
      double principal = 0;
      double valuation = 0;
      double goldWeight = 0;
      double silverWeight = 0;

      for (final l in loans) {
        principal += l.principalAmount;
        valuation += l.estimatedValue;
        if (l.metalType == MetalType.gold) {
          goldWeight += l.grossWeight;
        } else {
          silverWeight += l.grossWeight;
        }
      }

      return GirviStats(
        activeLoansCount: count,
        totalPrincipal: principal,
        totalEstimatedValuation: valuation,
        totalGoldGrossWeight: goldWeight,
        totalSilverGrossWeight: silverWeight,
      );
    },
    loading: () => GirviStats.zero(),
    error: (_, __) => GirviStats.zero(),
  );
});
