import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/parties.dart';

part 'parties_dao.g.dart';

@DriftAccessor(tables: [Parties])
class PartiesDao extends DatabaseAccessor<AppDatabase>
    with _$PartiesDaoMixin {
  PartiesDao(super.db);

  /// Watches all parties, ordered by name ascending.
  Stream<List<Party>> watchAllParties() {
    return (select(parties)..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  /// Watches parties filtered by [groupType], ordered by name ascending.
  Stream<List<Party>> watchPartiesByGroup(PartyGroupType groupType) {
    return (select(parties)
          ..where((t) => t.groupType.equalsValue(groupType))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  /// Returns a single party by its [id], or `null` if not found.
  Future<Party?> getPartyById(int id) {
    return (select(parties)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Inserts a new party and returns the generated row id.
  Future<int> insertParty(PartiesCompanion party) {
    return into(parties).insert(party);
  }

  /// Updates an existing party. Returns `true` if a row was affected.
  Future<bool> updateParty(Party party) {
    return update(parties).replace(party);
  }

  /// Deletes the party with the given [id].
  /// Returns the number of rows affected (0 or 1).
  Future<int> deleteParty(int id) {
    return (delete(parties)..where((t) => t.id.equals(id))).go();
  }

  /// Searches parties whose name contains [query] (case-insensitive).
  Future<List<Party>> searchParties(String query) {
    return (select(parties)
          ..where((t) => t.name.lower().like('%${query.toLowerCase()}%'))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }
}
