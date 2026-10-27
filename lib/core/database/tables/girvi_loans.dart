import 'package:drift/drift.dart';

import 'enums.dart';
import 'parties.dart';

/// Girvi (pledge / mortgage) loan records.
class GirviLoans extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get slipNumber => text().unique()();
  IntColumn get partyId => integer().references(Parties, #id)();
  DateTimeColumn get transactionDate => dateTime()();
  DateTimeColumn get interestStartDate => dateTime()();
  RealColumn get roi => real()();
  TextColumn get interestType => textEnum<InterestType>()();
  TextColumn get metalType => textEnum<MetalType>()();
  RealColumn get grossWeight => real()();
  RealColumn get purityPercent => real()();
  RealColumn get netWeight => real()();
  RealColumn get estimatedValue => real()();
  RealColumn get principalAmount => real()();
  TextColumn get paymentMode => textEnum<PaymentMode>()();
  TextColumn get itemDescription => text()();
  TextColumn get localPhotoPath => text().nullable()();
  TextColumn get guarantorName => text().nullable()();
  TextColumn get guarantorPhone => text().nullable()();
  TextColumn get guarantorAddress => text().nullable()();
  TextColumn get rackLocation => text().nullable()();
  TextColumn get remarks => text().nullable()();
  TextColumn get status =>
      textEnum<LoanStatus>().withDefault(Constant(LoanStatus.active.name))();
}
