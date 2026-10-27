import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/girvi_loans.dart';
import '../tables/loan_receipts.dart';
import '../tables/parties.dart';

part 'girvi_loans_dao.g.dart';

@DriftAccessor(tables: [GirviLoans, Parties, LoanReceipts])
class GirviLoansDao extends DatabaseAccessor<AppDatabase>
    with _$GirviLoansDaoMixin {
  GirviLoansDao(super.db);

  /// Watches all loans, ordered by transaction date descending.
  Stream<List<GirviLoan>> watchAllLoans() {
    return (select(girviLoans)
          ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .watch();
  }

  /// Watches loans filtered by [status], ordered by transaction date descending.
  Stream<List<GirviLoan>> watchLoansByStatus(LoanStatus status) {
    return (select(girviLoans)
          ..where((t) => t.status.equalsValue(status))
          ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .watch();
  }

  /// Returns a single loan by its [id], or `null` if not found.
  Future<GirviLoan?> getLoanById(int id) {
    return (select(girviLoans)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Inserts a new loan and returns the generated row id.
  Future<int> insertLoan(GirviLoansCompanion loan) {
    return into(girviLoans).insert(loan);
  }

  /// Updates an existing loan. Returns `true` if a row was affected.
  Future<bool> updateLoan(GirviLoan loan) {
    return update(girviLoans).replace(loan);
  }

  /// Returns the count of loans with [LoanStatus.active].
  Future<int> countActiveLoans() async {
    final countExp = girviLoans.id.count();
    final query = selectOnly(girviLoans)
      ..addColumns([countExp])
      ..where(girviLoans.status.equalsValue(LoanStatus.active));
    final row = await query.getSingle();
    return row.read(countExp)!;
  }

  /// Watches all loans belonging to a specific [partyId],
  /// ordered by transaction date descending.
  Stream<List<GirviLoan>> watchLoansForParty(int partyId) {
    return (select(girviLoans)
          ..where((t) => t.partyId.equals(partyId))
          ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .watch();
  }

  /// Generates the next slip number in the format "GIRVI-000001".
  Future<String> generateNextSlipNumber() async {
    final countExp = girviLoans.id.count();
    final query = selectOnly(girviLoans)..addColumns([countExp]);
    final row = await query.getSingle();
    final currentCount = row.read(countExp) ?? 0;
    final nextNumber = currentCount + 1;
    return 'GIRVI-${nextNumber.toString().padLeft(6, '0')}';
  }
}
