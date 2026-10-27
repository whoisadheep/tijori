import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tijori/core/database/app_database.dart';

/// Watches the latest daily metal rates from SQLite.
final latestDailyRateProvider = StreamProvider<DailyRate?>((ref) {
  final dao = ref.watch(dailyRatesDaoProvider);
  return dao.watchLatestRate();
});

/// Indicates whether rates for today's calendar date have been recorded.
final isTodayRateRecordedProvider = Provider<bool>((ref) {
  final rateAsync = ref.watch(latestDailyRateProvider);
  return rateAsync.when(
    data: (rate) {
      if (rate == null) return false;
      final now = DateTime.now();
      return rate.date.year == now.year &&
          rate.date.month == now.month &&
          rate.date.day == now.day;
    },
    loading: () => true, // Avoid premature prompt during initial load
    error: (_, __) => false,
  );
});
