import 'package:flutter_test/flutter_test.dart';
import 'package:tijori/core/utils/girvi_calculator.dart';
import 'package:tijori/core/utils/loan_models.dart';

void main() {
  group('GirviCalculator - Weight & Valuation', () {
    test('calculateNetWeight correctly computes net weight from gross and purity', () {
      // 10.0g at 91.6% (22K) = 9.16g
      expect(
        GirviCalculator.calculateNetWeight(grossWeight: 10.0, purityPercent: 91.6),
        equals(9.16),
      );

      // 50.0g at 75.0% (18K) = 37.5g
      expect(
        GirviCalculator.calculateNetWeight(grossWeight: 50.0, purityPercent: 75.0),
        equals(37.5),
      );

      // 100g at 99.9% (24K) = 99.9g
      expect(
        GirviCalculator.calculateNetWeight(grossWeight: 100.0, purityPercent: 99.9),
        equals(99.9),
      );

      // Edge case 0 weight
      expect(
        GirviCalculator.calculateNetWeight(grossWeight: 0.0, purityPercent: 91.6),
        equals(0.0),
      );
    });

    test('calculateEstimatedValue correctly computes valuation from net weight and rate', () {
      // 9.16g at Rs. 7,200 per gram = 65,952.00
      expect(
        GirviCalculator.calculateEstimatedValue(netWeight: 9.16, ratePerGram: 7200),
        equals(65952.0),
      );

      // 15.5g at Rs. 85.50 per gram (silver) = 1325.25
      expect(
        GirviCalculator.calculateEstimatedValue(netWeight: 15.5, ratePerGram: 85.50),
        equals(1325.25),
      );
    });
  });

  group('GirviCalculator - Interest Engines', () {
    test('calculateDayWiseInterest accurately calculates day-wise interest with 30-day base', () {
      // Principal: 10,000, ROI: 2% (per month / 30-day base), 15 days
      // Formula: (10000 * 2 * 15) / (100 * 30) = 100.00
      final start = DateTime(2025, 1, 1);
      final end = DateTime(2025, 1, 16); // 15 days difference
      final interest = GirviCalculator.calculateDayWiseInterest(
        principal: 10000,
        roi: 2.0,
        startDate: start,
        endDate: end,
      );
      expect(interest, equals(100.0));
    });

    test('calculateDayWiseInterest handles 0 days', () {
      final date = DateTime(2025, 1, 1);
      final interest = GirviCalculator.calculateDayWiseInterest(
        principal: 10000,
        roi: 2.0,
        startDate: date,
        endDate: date,
      );
      expect(interest, equals(0.0));
    });

    test('calculateMonthWiseInterest calculates whole and partial months with grace days', () {
      // Principal: 50,000, ROI: 1.5% per month
      // Start: 2025-01-01, End: 2025-03-01 => exactly 2 full months
      // Interest = (50000 * 1.5 * 2) / 100 = 1500.00
      expect(
        GirviCalculator.calculateMonthWiseInterest(
          principal: 50000,
          roi: 1.5,
          startDate: DateTime(2025, 1, 1),
          endDate: DateTime(2025, 3, 1),
          graceDays: 15,
        ),
        equals(1500.0),
      );

      // Start: 2025-01-01, End: 2025-03-10 => 2 months + 9 days (< graceDays 15) => still 2 months
      expect(
        GirviCalculator.calculateMonthWiseInterest(
          principal: 50000,
          roi: 1.5,
          startDate: DateTime(2025, 1, 1),
          endDate: DateTime(2025, 3, 10),
          graceDays: 15,
        ),
        equals(1500.0),
      );

      // Start: 2025-01-01, End: 2025-03-16 => 2 months + 15 days (>= graceDays 15) => counted as 3 months
      // Interest = (50000 * 1.5 * 3) / 100 = 2250.00
      expect(
        GirviCalculator.calculateMonthWiseInterest(
          principal: 50000,
          roi: 1.5,
          startDate: DateTime(2025, 1, 1),
          endDate: DateTime(2025, 3, 16),
          graceDays: 15,
        ),
        equals(2250.0),
      );
    });
  });

  group('GirviCalculator - Split Ledger Resolver', () {
    test('computes pristine loan ledger with no receipts', () {
      // 100,000 at 2% day-wise for 30 days
      final summary = GirviCalculator.computeLoanLedger(
        initialPrincipal: 100000,
        roi: 2.0,
        interestType: InterestType.dayWise,
        interestStartDate: DateTime(2025, 1, 1),
        calculationDate: DateTime(2025, 1, 31), // 30 days
        receipts: const [],
      );

      expect(summary.initialPrincipal, equals(100000));
      expect(summary.totalPrincipalRepaid, equals(0));
      expect(summary.remainingPrincipal, equals(100000));
      expect(summary.totalAccruedInterest, equals(2000)); // (100000*2*30)/(3000)
      expect(summary.totalInterestPaid, equals(0));
      expect(summary.pendingInterest, equals(2000));
      expect(summary.totalOutstanding, equals(102000));
    });

    test('computes ledger with interest payment and principal reduction over time', () {
      // Loan Start: 2025-01-01, Principal: 100,000, ROI: 2% DayWise
      // Event 1 (2025-01-31, 30 days elapsed): Interest payment of Rs. 2,000
      // Event 2 (2025-03-02, 30 days elapsed): Principal repayment of Rs. 40,000 -> Principal becomes 60,000
      // Event 3 (2025-04-01, 30 days elapsed on 60,000): Calculation date
      // Segment 1 (Jan 1 -> Jan 31, 30 days on 100k): Interest = 2000
      // Segment 2 (Jan 31 -> Mar 2, 30 days on 100k): Interest = 2000
      // Segment 3 (Mar 2 -> Apr 1, 30 days on 60k): Interest = (60000 * 2 * 30)/3000 = 1200
      // Total Accrued Interest = 2000 + 2000 + 1200 = 5200
      // Total Interest Paid = 2000
      // Total Principal Repaid = 40000
      // Remaining Principal = 60000
      // Pending Interest = 5200 - 2000 = 3200
      // Total Outstanding = 60000 + 3200 = 63200

      final receipts = [
        LoanReceiptEntry(
          date: DateTime(2025, 1, 31),
          type: ReceiptType.interestOnly,
          amount: 2000,
        ),
        LoanReceiptEntry(
          date: DateTime(2025, 3, 2),
          type: ReceiptType.principalRepayment,
          amount: 40000,
        ),
      ];

      final summary = GirviCalculator.computeLoanLedger(
        initialPrincipal: 100000,
        roi: 2.0,
        interestType: InterestType.dayWise,
        interestStartDate: DateTime(2025, 1, 1),
        calculationDate: DateTime(2025, 4, 1),
        receipts: receipts,
      );

      expect(summary.initialPrincipal, equals(100000));
      expect(summary.totalPrincipalRepaid, equals(40000));
      expect(summary.remainingPrincipal, equals(60000));
      expect(summary.totalAccruedInterest, equals(5200));
      expect(summary.totalInterestPaid, equals(2000));
      expect(summary.pendingInterest, equals(3200));
      expect(summary.totalOutstanding, equals(63200));
    });
  });
}
