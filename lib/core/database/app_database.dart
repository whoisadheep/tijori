import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/daily_rates_dao.dart';
import 'daos/girvi_loans_dao.dart';
import 'daos/gst_vouchers_dao.dart';
import 'daos/karigar_transactions_dao.dart';
import 'daos/loan_receipts_dao.dart';
import 'daos/parties_dao.dart';
import 'tables/daily_rates.dart';
import 'tables/enums.dart';
import 'tables/girvi_loans.dart';
import 'tables/gst_vouchers.dart';
import 'tables/karigar_transactions.dart';
import 'tables/loan_receipts.dart';
import 'tables/parties.dart';

export 'tables/enums.dart';

part 'app_database.g.dart';

/// Primary offline SQLite database for Tijori Jewellery ERP.
@DriftDatabase(
  tables: [
    DailyRates,
    Parties,
    GirviLoans,
    LoanReceipts,
    KarigarTransactions,
    GstVouchers,
  ],
  daos: [
    DailyRatesDao,
    PartiesDao,
    GirviLoansDao,
    LoanReceiptsDao,
    KarigarTransactionsDao,
    GstVouchersDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  /// In-memory constructor for unit / integration tests.
  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        beforeOpen: (details) async {
          // Enable foreign keys in SQLite
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

/// Lazy database connection targeting `tijori_erp.sqlite` in the documents dir.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'tijori_erp.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

/// Singleton Riverpod provider for [AppDatabase].
/// Must be overridden in ProviderScope during app startup.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError(
    'appDatabaseProvider must be overridden in ProviderScope with an initialized AppDatabase instance.',
  );
});

/// Convenience Riverpod providers for all DAOs.
final dailyRatesDaoProvider = Provider<DailyRatesDao>((ref) {
  return ref.watch(appDatabaseProvider).dailyRatesDao;
});

final partiesDaoProvider = Provider<PartiesDao>((ref) {
  return ref.watch(appDatabaseProvider).partiesDao;
});

final girviLoansDaoProvider = Provider<GirviLoansDao>((ref) {
  return ref.watch(appDatabaseProvider).girviLoansDao;
});

final loanReceiptsDaoProvider = Provider<LoanReceiptsDao>((ref) {
  return ref.watch(appDatabaseProvider).loanReceiptsDao;
});

final karigarTransactionsDaoProvider = Provider<KarigarTransactionsDao>((ref) {
  return ref.watch(appDatabaseProvider).karigarTransactionsDao;
});

final gstVouchersDaoProvider = Provider<GstVouchersDao>((ref) {
  return ref.watch(appDatabaseProvider).gstVouchersDao;
});
