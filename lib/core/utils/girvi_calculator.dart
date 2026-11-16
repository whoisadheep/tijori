/// Pure financial calculation engine for Girvi (pawn/loan) operations.
///
/// All methods are static, pure functions with no side effects.
/// This file intentionally has **zero** Flutter imports so it can be
/// unit-tested on the Dart VM alone.
library;

import 'loan_models.dart';

/// Core calculator used across the Tijori ERP for every monetary figure
/// displayed on-screen, in PDFs, or persisted back to the database.
abstract final class GirviCalculator {
  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Rounds [value] to 2 decimal places for financial precision.
  static double _roundTo2(double value) =>
      (value * 100).roundToDouble() / 100;

  /// Returns the number of whole calendar days between [start] and [end].
  ///
  /// Both dates are normalised to midnight (date-only) before comparison so
  /// that time-of-day is irrelevant.  A negative result is clamped to 0.
  static int _daysBetween(DateTime start, DateTime end) {
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);
    final diff = e.difference(s).inDays;
    return diff < 0 ? 0 : diff;
  }

  /// Returns the number of elapsed months between [start] and [end],
  /// accounting for partial months via [graceDays].
  ///
  /// A partial month is counted as a full month when the remaining
  /// days ≥ [graceDays].
  static int _monthsBetween(
    DateTime start,
    DateTime end, {
    required int graceDays,
  }) {
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);

    if (!e.isAfter(s)) return 0;

    // Full calendar-months difference.
    int months = (e.year - s.year) * 12 + (e.month - s.month);

    // If the end day hasn't reached the start day, we haven't completed
    // the current calendar month yet.
    if (e.day < s.day) {
      months -= 1;
    }

    if (months < 0) months = 0;

    // Safe calendar month addition with day clamping (e.g. Jan 31 -> Feb 28)
    final targetYear = s.year + (s.month + months - 1) ~/ 12;
    final targetMonth = ((s.month + months - 1) % 12) + 1;
    final daysInTargetMonth = DateTime(targetYear, targetMonth + 1, 0).day;
    final clampedDay = s.day > daysInTargetMonth ? daysInTargetMonth : s.day;

    // Remaining days after the full months.
    final afterFullMonths = DateTime(targetYear, targetMonth, clampedDay);
    final remainingDays = _daysBetween(afterFullMonths, e);

    // Count the partial month if remaining days meet the grace threshold.
    if (remainingDays >= graceDays) {
      months += 1;
    }

    return months;
  }

  // ---------------------------------------------------------------------------
  // Weight & Valuation
  // ---------------------------------------------------------------------------

  /// Calculates net weight from gross weight and purity percentage.
  ///
  /// ```
  /// netWeight = grossWeight × (purityPercent / 100)
  /// ```
  ///
  /// [grossWeight] in grams.
  /// [purityPercent] value between 0 and 100 (inclusive).
  static double calculateNetWeight({
    required double grossWeight,
    required double purityPercent,
  }) {
    assert(grossWeight >= 0, 'grossWeight must be non-negative');
    assert(
      purityPercent >= 0 && purityPercent <= 100,
      'purityPercent must be 0–100',
    );
    if (grossWeight < 0) {
      throw ArgumentError.value(grossWeight, 'grossWeight', 'must be non-negative');
    }
    if (purityPercent < 0 || purityPercent > 100) {
      throw ArgumentError.value(purityPercent, 'purityPercent', 'must be 0–100');
    }
    return _roundTo2(grossWeight * (purityPercent / 100));
  }

  /// Calculates estimated metal valuation.
  ///
  /// ```
  /// estimatedValue = netWeight × ratePerGram
  /// ```
  ///
  /// [netWeight] in grams.
  /// [ratePerGram] today's market rate for the metal type.
  static double calculateEstimatedValue({
    required double netWeight,
    required double ratePerGram,
  }) {
    assert(netWeight >= 0, 'netWeight must be non-negative');
    assert(ratePerGram >= 0, 'ratePerGram must be non-negative');
    return _roundTo2(netWeight * ratePerGram);
  }

  // ---------------------------------------------------------------------------
  // Interest Calculations
  // ---------------------------------------------------------------------------

  /// Calculates accrued interest using the **DayWise** method.
  ///
  /// ```
  /// interest = (principal × roi × elapsedDays) / (100 × 30)
  /// ```
  ///
  /// The formula normalises a monthly rate of interest over 30-day periods.
  ///
  /// [principal] the outstanding principal amount.
  /// [roi] rate of interest (monthly percentage, e.g. 2 for 2%).
  /// [startDate] when interest begins accruing.
  /// [endDate] calculation date (typically today).
  static double calculateDayWiseInterest({
    required double principal,
    required double roi,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    assert(principal >= 0, 'principal must be non-negative');
    assert(roi >= 0, 'roi must be non-negative');

    final days = _daysBetween(startDate, endDate);
    if (days == 0) return 0;

    return _roundTo2((principal * roi * days) / (100 * 30));
  }

  /// Calculates accrued interest using the **MonthWise** method.
  ///
  /// ```
  /// interest = (principal × roi × elapsedMonths) / 100
  /// ```
  ///
  /// Partial months are counted as full months when the remaining days
  /// equal or exceed [graceDays].
  ///
  /// [principal] the outstanding principal amount.
  /// [roi] monthly rate of interest percentage.
  /// [startDate] when interest begins accruing.
  /// [endDate] calculation date (typically today).
  /// [graceDays] threshold for counting a partial month (default 15).
  static double calculateMonthWiseInterest({
    required double principal,
    required double roi,
    required DateTime startDate,
    required DateTime endDate,
    int graceDays = 15,
  }) {
    assert(principal >= 0, 'principal must be non-negative');
    assert(roi >= 0, 'roi must be non-negative');
    assert(graceDays > 0, 'graceDays must be positive');

    final months = _monthsBetween(startDate, endDate, graceDays: graceDays);
    if (months == 0) return 0;

    return _roundTo2((principal * roi * months) / 100);
  }

  // ---------------------------------------------------------------------------
  // Full Ledger Computation
  // ---------------------------------------------------------------------------

  /// Given a loan's parameters and a list of receipts, computes the full
  /// ledger state as of [calculationDate].
  ///
  /// **Algorithm:**
  /// 1. Sort receipts chronologically.
  /// 2. Walk through time segments defined by principal-repayment receipts.
  /// 3. For each segment, calculate interest on the *current* outstanding
  ///    principal for that segment's duration.
  /// 4. Interest-only receipts are subtracted from accrued interest.
  /// 5. Principal-repayment receipts reduce the outstanding principal.
  /// 6. After processing all receipts, calculate interest from the last
  ///    event date to [calculationDate].
  ///
  /// Returns a [LoanLedgerSummary] with all totals rounded to 2 decimal
  /// places.
  static LoanLedgerSummary computeLoanLedger({
    required double initialPrincipal,
    required double roi,
    required InterestType interestType,
    required DateTime interestStartDate,
    required DateTime calculationDate,
    required List<LoanReceiptEntry> receipts,
    int graceDays = 15,
  }) {
    assert(initialPrincipal >= 0, 'initialPrincipal must be non-negative');
    assert(roi >= 0, 'roi must be non-negative');

    // Step 1 — Sort receipts chronologically (defensive copy).
    final sorted = List<LoanReceiptEntry>.of(receipts)..sort();

    double currentPrincipal = initialPrincipal;
    double totalAccruedInterest = 0;
    double totalInterestPaid = 0;
    double totalPrincipalRepaid = 0;

    // The running start-date for interest accrual in the current segment.
    DateTime segmentStart = interestStartDate;

    // Step 2–5 — Walk through every receipt.
    for (final receipt in sorted) {
      // Only accrue interest up to the receipt date if it falls before or
      // on the calculation date.
      final accrualEnd = receipt.date.isBefore(calculationDate)
          ? receipt.date
          : calculationDate;

      // Accrue interest for the segment leading up to this receipt.
      final segmentInterest = _interestForPeriod(
        principal: currentPrincipal,
        roi: roi,
        interestType: interestType,
        start: segmentStart,
        end: accrualEnd,
        graceDays: graceDays,
      );
      totalAccruedInterest += segmentInterest;

      switch (receipt.type) {
        case ReceiptType.interestOnly:
          totalInterestPaid += receipt.amount;
          // Interest-only payments do NOT change the segment start because
          // principal hasn't changed — interest continues to accrue at the
          // same rate.  However, to avoid double-counting the interest we've
          // already accrued for this segment, we advance the segment start
          // to the receipt date.
          segmentStart = accrualEnd;

        case ReceiptType.principalRepayment:
          final payable = receipt.amount > currentPrincipal ? currentPrincipal : receipt.amount;
          totalPrincipalRepaid += payable;
          currentPrincipal = _roundTo2(currentPrincipal - payable);
          if (currentPrincipal < 0) currentPrincipal = 0;
          // After a principal repayment the outstanding amount changed, so a
          // new segment begins.
          segmentStart = accrualEnd;
      }
    }

    // Step 6 — Accrue interest from the last event date to calculationDate.
    final trailingInterest = _interestForPeriod(
      principal: currentPrincipal,
      roi: roi,
      interestType: interestType,
      start: segmentStart,
      end: calculationDate,
      graceDays: graceDays,
    );
    totalAccruedInterest += trailingInterest;

    // Round everything.
    totalAccruedInterest = _roundTo2(totalAccruedInterest);
    totalInterestPaid = _roundTo2(totalInterestPaid);
    totalPrincipalRepaid = _roundTo2(totalPrincipalRepaid);
    currentPrincipal = _roundTo2(currentPrincipal);

    final rawPendingInterest = _roundTo2(totalAccruedInterest - totalInterestPaid);
    final pendingInterest = rawPendingInterest < 0 ? 0.0 : rawPendingInterest;
    final totalOutstanding = _roundTo2(currentPrincipal + pendingInterest);

    return LoanLedgerSummary(
      initialPrincipal: initialPrincipal,
      totalPrincipalRepaid: totalPrincipalRepaid,
      remainingPrincipal: currentPrincipal,
      totalAccruedInterest: totalAccruedInterest,
      totalInterestPaid: totalInterestPaid,
      pendingInterest: pendingInterest,
      totalOutstanding: totalOutstanding,
    );
  }

  /// Dispatcher that selects the correct interest function based on
  /// [interestType].
  static double _interestForPeriod({
    required double principal,
    required double roi,
    required InterestType interestType,
    required DateTime start,
    required DateTime end,
    required int graceDays,
  }) {
    return switch (interestType) {
      InterestType.dayWise => calculateDayWiseInterest(
          principal: principal,
          roi: roi,
          startDate: start,
          endDate: end,
        ),
      InterestType.monthWise => calculateMonthWiseInterest(
          principal: principal,
          roi: roi,
          startDate: start,
          endDate: end,
          graceDays: graceDays,
        ),
    };
  }
}
