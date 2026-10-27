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
  Future<String> generateNextVoucherNumber() async {
    final countExp = karigarTransactions.id.count();
    final query = selectOnly(karigarTransactions)..addColumns([countExp]);
    final row = await query.getSingle();
    final currentCount = row.read(countExp) ?? 0;
    final nextNumber = currentCount + 1;
    return 'KRG-${nextNumber.toString().padLeft(6, '0')}';
  }
}
