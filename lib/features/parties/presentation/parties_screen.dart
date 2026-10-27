import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tijori/core/database/app_database.dart';

import 'parties_providers.dart';
import 'quick_add_party_dialog.dart';

class PartiesScreen extends ConsumerStatefulWidget {
  const PartiesScreen({super.key});

  @override
  ConsumerState<PartiesScreen> createState() => _PartiesScreenState();
}

class _PartiesScreenState extends ConsumerState<PartiesScreen> {
  String _searchQuery = '';
  PartyGroupType? _groupFilter;
  final _dateFmt = DateFormat('dd MMM yyyy');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final partiesAsync = ref.watch(allPartiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parties & Customer Directory'),
        actions: [
          FilledButton.icon(
            icon: const Icon(Icons.person_add_rounded),
            label: const Text('Add Party'),
            onPressed: () => QuickAddPartyDialog.show(context),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search by name, mobile, KYC number, or address...',
                      prefixIcon: Icon(Icons.search_rounded),
                      isDense: true,
                    ),
                    onChanged: (v) => setState(() => _searchQuery = v.trim()),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<PartyGroupType?>(
                  value: _groupFilter,
                  hint: const Text('All Groups'),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('All Groups')),
                    DropdownMenuItem(
                      value: PartyGroupType.customer,
                      child: Text('Customers'),
                    ),
                    DropdownMenuItem(
                      value: PartyGroupType.karigar,
                      child: Text('Karigars'),
                    ),
                    DropdownMenuItem(
                      value: PartyGroupType.supplier,
                      child: Text('Suppliers'),
                    ),
                  ],
                  onChanged: (g) => setState(() => _groupFilter = g),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: partiesAsync.when(
              data: (parties) {
                final filtered = parties.where((p) {
                  if (_groupFilter != null && p.groupType != _groupFilter) {
                    return false;
                  }
                  if (_searchQuery.isNotEmpty) {
                    final q = _searchQuery.toLowerCase();
                    final matchName = p.name.toLowerCase().contains(q);
                    final matchPhone = p.mobile?.contains(q) ?? false;
                    final matchKyc = p.kycDocNumber?.toLowerCase().contains(q) ?? false;
                    final matchAddr = p.address?.toLowerCase().contains(q) ?? false;
                    if (!matchName && !matchPhone && !matchKyc && !matchAddr) {
                      return false;
                    }
                  }
                  return true;
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.group_off_rounded,
                          size: 48,
                          color: colorScheme.outline,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No parties found.',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, idx) {
                    final party = filtered[idx];

                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: colorScheme.primaryContainer,
                              child: Text(
                                party.name.isNotEmpty
                                    ? party.name[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        party.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 1,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colorScheme.secondaryContainer,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          party.groupType.name.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: colorScheme
                                                .onSecondaryContainer,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  if (party.mobile != null)
                                    Text(
                                      'Mobile: ${party.mobile}',
                                      style: TextStyle(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  if (party.address != null)
                                    Text(
                                      party.address!,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (party.kycDocNumber != null)
                                    Text(
                                      '${party.kycDocType ?? "ID"}: ${party.kycDocNumber}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  Text(
                                    'Joined: ${_dateFmt.format(party.createdAt)}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
