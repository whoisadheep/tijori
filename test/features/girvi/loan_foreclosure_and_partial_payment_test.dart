import 'package:flutter_test/flutter_test.dart';
import 'package:tijori/core/utils/girvi_calculator.dart';
import 'package:tijori/core/utils/loan_models.dart';

void main() {
  group('Girvi Foreclosure & Multi-Segment Partial Payments', () {
    test('accurately computes multi-step principal repayments and interest amortization', () {
      final start = DateTime(2025, 1, 1);
      final receipts = [
        // 30 days later: Pays interest only
        LoanReceiptEntry(
          date: DateTime(2025, 1, 31),
          type: ReceiptType.interestOnly,
          amount: 2000.0,
        ),
        // 60 days later: Pays 50,000 principal
        LoanReceiptEntry(
          date: DateTime(2025, 3, 2),
          type: ReceiptType.principalRepayment,
          amount: 50000.0,
        ),
      ];

      // Evaluation at 90 days (2025-04-01) on remaining 50,000
      final ledger = GirviCalculator.computeLoanLedger(
        initialPrincipal: 100000.0,
        roi: 2.0,
        interestType: InterestType.dayWise,
        interestStartDate: start,
        calculationDate: DateTime(2025, 4, 1),
        receipts: receipts,
      );

      expect(ledger.remainingPrincipal, equals(50000.0));
      expect(ledger.totalPrincipalRepaid, equals(50000.0));
      expect(ledger.totalInterestPaid, equals(2000.0));
      expect(ledger.totalAccruedInterest, equals(5000.0));
      expect(ledger.pendingInterest, equals(3000.0));
      expect(ledger.totalOutstanding, equals(53000.0));
    });

    test('foreclosure calculation clears total balance to zero on exact settlement', () {
      final start = DateTime(2025, 1, 1);
      final calcDate = DateTime(2025, 2, 1); // 31 days
      // Initial: 50,000 at 1.5% day-wise
      // Accrued interest = (50000 * 1.5 * 31) / 3000 = 775.00
      final foreclosureReceipts = [
        LoanReceiptEntry(
          date: calcDate,
          type: ReceiptType.interestOnly,
          amount: 775.0,
        ),
        LoanReceiptEntry(
          date: calcDate,
          type: ReceiptType.principalRepayment,
          amount: 50000.0,
        ),
      ];

      final ledger = GirviCalculator.computeLoanLedger(
        initialPrincipal: 50000.0,
        roi: 1.5,
        interestType: InterestType.dayWise,
        interestStartDate: start,
        calculationDate: calcDate,
        receipts: foreclosureReceipts,
      );

      expect(ledger.remainingPrincipal, equals(0.0));
      expect(ledger.pendingInterest, equals(0.0));
      expect(ledger.totalOutstanding, equals(0.0));
    });

    test('handles overpayment without producing negative balances or infinite debt', () {
      final start = DateTime(2025, 1, 1);
      final calcDate = DateTime(2025, 1, 16); // 15 days
      final receipts = [
        LoanReceiptEntry(
          date: calcDate,
          type: ReceiptType.principalRepayment,
          amount: 60000.0, // Initial was 50,000
        ),
      ];

      final ledger = GirviCalculator.computeLoanLedger(
        initialPrincipal: 50000.0,
        roi: 2.0,
        interestType: InterestType.dayWise,
        interestStartDate: start,
        calculationDate: calcDate,
        receipts: receipts,
      );

      expect(ledger.remainingPrincipal, equals(0.0));
      expect(ledger.totalPrincipalRepaid, equals(50000.0)); // Capped at principal
      expect(ledger.totalOutstanding >= 0, isTrue);
    });

    test('safely handles month-end start dates without date rollover distortions', () {
      // Loan begins on Jan 31
      final start = DateTime(2025, 1, 31);
      final calcDate = DateTime(2025, 3, 2);

      final ledger = GirviCalculator.computeLoanLedger(
        initialPrincipal: 10000.0,
        roi: 2.0,
        interestType: InterestType.monthWise,
        interestStartDate: start,
        calculationDate: calcDate,
        graceDays: 15,
        receipts: const [],
      );

      expect(ledger.totalAccruedInterest > 0, isTrue);
    });
  });
}
