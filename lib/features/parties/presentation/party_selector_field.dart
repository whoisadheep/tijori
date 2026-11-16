import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tijori/core/database/app_database.dart';

import 'parties_providers.dart';
import 'quick_add_party_dialog.dart';

/// Autocomplete and quick-selection field for picking a [Party].
class PartySelectorField extends ConsumerWidget {
  final int? selectedPartyId;
  final Party? selectedParty;
  final ValueChanged<Party?> onPartySelected;
  final PartyGroupType filterGroup;
  final String label;
  final bool isRequired;

  const PartySelectorField({
    super.key,
    required this.selectedPartyId,
    this.selectedParty,
    required this.onPartySelected,
    this.filterGroup = PartyGroupType.customer,
    this.label = 'Customer / Party *',
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partiesAsync = ref.watch(allPartiesProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return partiesAsync.when(
      data: (parties) {
        final filtered = parties
            .where((p) =>
                p.groupType == filterGroup ||
                filterGroup == PartyGroupType.customer)
            .toList();

        // Ensure currently selected party is present in the list even if stream has not updated
        if (selectedParty != null &&
            !filtered.any((p) => p.id == selectedParty!.id)) {
          filtered.insert(0, selectedParty!);
        }

        final currentSelected = filtered.cast<Party?>().firstWhere(
              (p) => p?.id == selectedPartyId,
              orElse: () => selectedParty,
            );

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                key: ValueKey(currentSelected?.id),
                initialValue: currentSelected?.id,
                decoration: InputDecoration(
                  labelText: label,
                  prefixIcon: const Icon(Icons.person_search_rounded),
                  isDense: true,
                  helperText: filtered.isEmpty
                      ? 'No parties found. Click "+" to create one.'
                      : null,
                ),
                isExpanded: true,
                hint: const Text('Search or select a party...'),
                items: filtered.map((party) {
                  final phone = party.mobile != null && party.mobile!.isNotEmpty
                      ? ' (${party.mobile})'
                      : '';
                  return DropdownMenuItem<int>(
                    value: party.id,
                    child: Text(
                      '${party.name}$phone',
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (newId) {
                  if (newId == null) {
                    onPartySelected(null);
                  } else {
                    final party = filtered.firstWhere((p) => p.id == newId);
                    onPartySelected(party);
                  }
                },
                validator: (v) {
                  if (isRequired && (v == null || v == 0)) {
                    return 'Please select a customer';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filledTonal(
              tooltip: 'Add New Party',
              icon: const Icon(Icons.person_add_rounded),
              onPressed: () async {
                final created = await QuickAddPartyDialog.show(
                  context,
                  initialGroup: filterGroup,
                );
                if (created != null) {
                  onPartySelected(created);
                }
              },
            ),
          ],
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => Text(
        'Error loading parties: $e',
        style: TextStyle(color: colorScheme.error),
      ),
    );
  }
}
