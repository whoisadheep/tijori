import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tijori/core/database/app_database.dart';

/// Watches all parties recorded in the database, ordered by name.
final allPartiesProvider = StreamProvider<List<Party>>((ref) {
  final dao = ref.watch(partiesDaoProvider);
  return dao.watchAllParties();
});

/// Watches parties categorized specifically as Customers.
final customerPartiesProvider = StreamProvider<List<Party>>((ref) {
  final dao = ref.watch(partiesDaoProvider);
  return dao.watchPartiesByGroup(PartyGroupType.customer);
});

/// Watches parties categorized specifically as Karigars.
final karigarPartiesProvider = StreamProvider<List<Party>>((ref) {
  final dao = ref.watch(partiesDaoProvider);
  return dao.watchPartiesByGroup(PartyGroupType.karigar);
});
