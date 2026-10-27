import 'package:drift/drift.dart';

import 'enums.dart';

/// Master table of all parties — customers, karigars, and suppliers.
class Parties extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1)();
  TextColumn get groupType => textEnum<PartyGroupType>()();
  TextColumn get mobile => text().nullable()();
  TextColumn get state => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get kycDocType => text().nullable()();
  TextColumn get kycDocNumber => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
