import 'package:drift/drift.dart';

/// Stores daily precious-metal rates.
class DailyRates extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime().unique()();
  RealColumn get gold16k => real().nullable()();
  RealColumn get gold18k => real().nullable()();
  RealColumn get gold22k => real().nullable()();
  RealColumn get gold24k => real().nullable()();
  RealColumn get silverRate => real().nullable()();
}
