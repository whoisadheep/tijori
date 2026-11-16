import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/girvi_loans.dart';
import '../tables/loan_receipts.dart';

part 'loan_receipts_dao.g.dart';

@DriftAccessor(tables: [LoanReceipts, GirviLoans])
class LoanReceiptsDao extends DatabaseAccessor<AppDatabase>
    with _$LoanReceiptsDaoMixin {
  LoanReceiptsDao(super.db);

  /// Watches all receipts across all loans, ordered by date descending.
  Stream<List<LoanReceipt>> watchAllReceipts() {
    return (select(loanReceipts)
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  /// Watches all receipts for a given [loanId], ordered by date descending.
  Stream<List<LoanReceipt>> watchReceiptsForLoan(int loanId) {
    return (select(loanReceipts)
          ..where((t) => t.loanId.equals(loanId))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  /// Returns all receipts for a given [loanId], ordered by date descending.
  Future<List<LoanReceipt>> getReceiptsForLoan(int loanId) {
    return (select(loanReceipts)
          ..where((t) => t.loanId.equals(loanId))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  /// Inserts a new receipt and returns the generated row id.
  Future<int> insertReceipt(LoanReceiptsCompanion receipt) {
    return into(loanReceipts).insert(receipt);
  }

  /// Generates the next receipt number in the format "REC-000001".
  /// Uses max ID to safely avoid unique key collisions even after row deletions.
  Future<String> generateNextReceiptNumber() async {
    final maxIdExp = loanReceipts.id.max();
    final query = selectOnly(loanReceipts)..addColumns([maxIdExp]);
    final row = await query.getSingle();
    final maxId = row.read(maxIdExp) ?? 0;
    final nextNumber = maxId + 1;
    return 'REC-${nextNumber.toString().padLeft(6, '0')}';
  }
}
