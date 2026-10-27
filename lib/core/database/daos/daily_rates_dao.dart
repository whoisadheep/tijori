import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/daily_rates.dart';

part 'daily_rates_dao.g.dart';

@DriftAccessor(tables: [DailyRates])
class DailyRatesDao extends DatabaseAccessor<AppDatabase>
    with _$DailyRatesDaoMixin {
  DailyRatesDao(super.db);

  /// Watches the most recent daily rate entry, ordered by date descending.
  Stream<DailyRate?> watchLatestRate() {
    return (select(dailyRates)
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(1))
        .watchSingleOrNull();
  }

  /// Returns the most recent daily rate entry.
  Future<DailyRate?> getLatestRate() {
    return (select(dailyRates)
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Returns the rate entry for the given [date], matching on calendar day.
  Future<DailyRate?> getRateForDate(DateTime date) {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    return (select(dailyRates)
          ..where(
            (t) =>
                t.date.isBiggerOrEqualValue(dayStart) &
                t.date.isSmallerThanValue(dayEnd),
          ))
        .getSingleOrNull();
  }

  /// Inserts a new rate entry and returns the generated row id.
  Future<int> insertRate(DailyRatesCompanion rate) {
    return into(dailyRates).insert(rate);
  }

  /// Updates an existing rate entry. Returns `true` if a row was affected.
  Future<bool> updateRate(DailyRate rate) {
    return update(dailyRates).replace(rate);
  }

  /// Watches all rate entries between [start] and [end] (inclusive),
  /// ordered by date ascending.
  Stream<List<DailyRate>> watchRatesInRange(DateTime start, DateTime end) {
    return (select(dailyRates)
          ..where(
            (t) =>
                t.date.isBiggerOrEqualValue(start) &
                t.date.isSmallerOrEqualValue(end),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .watch();
  }
}
