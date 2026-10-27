/// Data models for loan ledger computation.
///
/// These are standalone Dart classes with no dependency on Drift or Flutter.
/// The enums mirror the database enums but are independently defined to keep
/// the calculation engine pure and unit-testable.
library;

/// Interest calculation strategy.
///
/// - [dayWise]: interest accrues per day using a 30-day normalisation.
/// - [monthWise]: interest accrues per calendar month with a grace-day
///   threshold for partial months.
enum InterestType { dayWise, monthWise }

/// Classification of a receipt against a loan.
enum ReceiptType { interestOnly, principalRepayment }

/// A single receipt entry used by [GirviCalculator.computeLoanLedger].
final class LoanReceiptEntry implements Comparable<LoanReceiptEntry> {
  /// Date the receipt was recorded.
  final DateTime date;

  /// Whether this receipt pays interest only or repays principal.
  final ReceiptType type;

  /// Receipt amount in currency units.
  final double amount;

  const LoanReceiptEntry({
    required this.date,
    required this.type,
    required this.amount,
  });

  /// Natural ordering by [date] (ascending).
  @override
  int compareTo(LoanReceiptEntry other) => date.compareTo(other.date);

  @override
  String toString() =>
      'LoanReceiptEntry(date: $date, type: $type, amount: $amount)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoanReceiptEntry &&
          date == other.date &&
          type == other.type &&
          amount == other.amount;

  @override
  int get hashCode => Object.hash(date, type, amount);
}

/// Immutable result of a full ledger computation via
/// [GirviCalculator.computeLoanLedger].
final class LoanLedgerSummary {
  /// The principal the loan was originally issued at.
  final double initialPrincipal;

  /// Total principal that has been repaid to date.
  final double totalPrincipalRepaid;

  /// Outstanding principal (initialPrincipal − totalPrincipalRepaid).
  final double remainingPrincipal;

  /// Total interest accrued across all time-periods.
  final double totalAccruedInterest;

  /// Total interest already collected via receipts.
  final double totalInterestPaid;

  /// Interest accrued but not yet collected.
  final double pendingInterest;

  /// Total amount the borrower currently owes
  /// (remainingPrincipal + pendingInterest).
  final double totalOutstanding;

  const LoanLedgerSummary({
    required this.initialPrincipal,
    required this.totalPrincipalRepaid,
    required this.remainingPrincipal,
    required this.totalAccruedInterest,
    required this.totalInterestPaid,
    required this.pendingInterest,
    required this.totalOutstanding,
  });

  @override
  String toString() => 'LoanLedgerSummary('
      'initialPrincipal: $initialPrincipal, '
      'totalPrincipalRepaid: $totalPrincipalRepaid, '
      'remainingPrincipal: $remainingPrincipal, '
      'totalAccruedInterest: $totalAccruedInterest, '
      'totalInterestPaid: $totalInterestPaid, '
      'pendingInterest: $pendingInterest, '
      'totalOutstanding: $totalOutstanding)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoanLedgerSummary &&
          initialPrincipal == other.initialPrincipal &&
          totalPrincipalRepaid == other.totalPrincipalRepaid &&
          remainingPrincipal == other.remainingPrincipal &&
          totalAccruedInterest == other.totalAccruedInterest &&
          totalInterestPaid == other.totalInterestPaid &&
          pendingInterest == other.pendingInterest &&
          totalOutstanding == other.totalOutstanding;

  @override
  int get hashCode => Object.hash(
        initialPrincipal,
        totalPrincipalRepaid,
        remainingPrincipal,
        totalAccruedInterest,
        totalInterestPaid,
        pendingInterest,
        totalOutstanding,
      );
}
