import 'package:drift/drift.dart';

import 'enums.dart';
import 'parties.dart';

/// Issue / Receive transactions with Karigars (artisans).
class KarigarTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get voucherNumber => text().unique()();
  IntColumn get karigarId => integer().references(Parties, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get type => textEnum<KarigarTxnType>()();
  TextColumn get itemDescription => text()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  RealColumn get grossWeight => real()();
  RealColumn get purityPercent => real()();
  RealColumn get netWeight => real()();
  RealColumn get estimatedValue => real().nullable()();
  TextColumn get remarks => text().nullable()();
}
