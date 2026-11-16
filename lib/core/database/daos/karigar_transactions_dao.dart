import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/karigar_transactions.dart';
import '../tables/parties.dart';

part 'karigar_transactions_dao.g.dart';

@DriftAccessor(tables: [KarigarTransactions, Parties])
class KarigarTransactionsDao extends DatabaseAccessor<AppDatabase>
    with _$KarigarTransactionsDaoMixin {
  KarigarTransactionsDao(super.db);

  /// Watches all karigar transactions, ordered by date descending.
  Stream<List<KarigarTransaction>> watchAllTransactions() {
    return (select(karigarTransactions)
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  /// Watches transactions for a specific karigar by [karigarId],
  /// ordered by date descending.
  Stream<List<KarigarTransaction>> watchTransactionsForKarigar(int karigarId) {
    return (select(karigarTransactions)
          ..where((t) => t.karigarId.equals(karigarId))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  /// Inserts a new transaction and returns the generated row id.
  Future<int> insertTransaction(KarigarTransactionsCompanion txn) {
    return into(karigarTransactions).insert(txn);
  }

  /// Generates the next voucher number in the format "KRG-000001".
  /// Uses max ID to safely avoid unique key collisions even after row deletions.
  Future<String> generateNextVoucherNumber() async {
    final maxIdExp = karigarTransactions.id.max();
    final query = selectOnly(karigarTransactions)..addColumns([maxIdExp]);
    final row = await query.getSingle();
    final maxId = row.read(maxIdExp) ?? 0;
    final nextNumber = maxId + 1;
    return 'KRG-${nextNumber.toString().padLeft(6, '0')}';
  }
}
