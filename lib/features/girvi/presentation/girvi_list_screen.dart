import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tijori/core/database/app_database.dart';
import 'package:tijori/features/parties/presentation/parties_providers.dart';

import 'girvi_providers.dart';

class GirviListScreen extends ConsumerStatefulWidget {
  const GirviListScreen({super.key});

  @override
  ConsumerState<GirviListScreen> createState() => _GirviListScreenState();
}

class _GirviListScreenState extends ConsumerState<GirviListScreen> {
  final _currencyFmt = NumberFormat.currency(locale: 'en_IN', symbol: '₹ ');
  final _dateFmt = DateFormat('dd MMM yyyy');

  String _searchQuery = '';
  MetalType? _metalFilter;
  LoanStatus _statusFilter = LoanStatus.active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final loansAsync = ref.watch(allLoansProvider);
    final stats = ref.watch(girviStatsProvider);
    final partiesAsync = ref.watch(allPartiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Girvi (Pawn) Loans & Pledges'),
        actions: [
          FilledButton.icon(
            icon: const Icon(Icons.add_rounded),
            label: const Text('New Pledge'),
            onPressed: () => context.go('/girvi/new'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // 1. Stats Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
              border: Border(
                bottom: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
            child: Row(
              children: [
                _buildStatItem(
                  context,
                  'Active Pledges',
                  stats.activeLoansCount.toString(),
                  icon: Icons.assignment_outlined,
                ),
                const SizedBox(width: 24),
                _buildStatItem(
                  context,
                  'Active Principal',
                  _currencyFmt.format(stats.totalPrincipal),
                  icon: Icons.account_balance_wallet_outlined,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 24),
                _buildStatItem(
                  context,
                  'Vault Valuation',
                  _currencyFmt.format(stats.totalEstimatedValuation),
                  icon: Icons.shield_outlined,
                ),
                const SizedBox(width: 24),
                _buildStatItem(
                  context,
                  'Vault Gold Wt',
                  '${stats.totalGoldGrossWeight.toStringAsFixed(2)} g',
                  icon: Icons.circle,
                  iconColor: Colors.amber.shade700,
                ),
                const SizedBox(width: 24),
                _buildStatItem(
                  context,
                  'Vault Silver Wt',
                  '${stats.totalSilverGrossWeight.toStringAsFixed(2)} g',
                  icon: Icons.circle,
                  iconColor: Colors.blueGrey,
                ),
              ],
            ),
          ),

          // 2. Search & Filter Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search by Slip #, Customer name, or Mobile...',
                      prefixIcon: Icon(Icons.search_rounded),
                      isDense: true,
                    ),
                    onChanged: (v) => setState(() => _searchQuery = v.trim()),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<MetalType?>(
                  value: _metalFilter,
                  hint: const Text('All Metals'),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('All Metals')),
                    DropdownMenuItem(
                        value: MetalType.gold, child: Text('Gold Only')),
                    DropdownMenuItem(
                        value: MetalType.silver, child: Text('Silver Only')),
                  ],
                  onChanged: (m) => setState(() => _metalFilter = m),
                ),
                const SizedBox(width: 12),
                SegmentedButton<LoanStatus>(
                  segments: const [
                    ButtonSegment(
                        value: LoanStatus.active, label: Text('Active')),
                    ButtonSegment(
                        value: LoanStatus.closed, label: Text('Closed')),
                  ],
                  selected: {_statusFilter},
                  onSelectionChanged: (v) =>
                      setState(() => _statusFilter = v.first),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // 3. Loans List
          Expanded(
            child: loansAsync.when(
              data: (loans) {
                final partiesMap = {
                  for (final p in partiesAsync.valueOrNull ?? <Party>[]) p.id: p,
                };

                // Filter loans
                final filtered = loans.where((loan) {
                  if (loan.status != _statusFilter) return false;
                  if (_metalFilter != null && loan.metalType != _metalFilter) {
                    return false;
                  }

                  if (_searchQuery.isNotEmpty) {
                    final party = partiesMap[loan.partyId];
                    final q = _searchQuery.toLowerCase();
                    final matchSlip = loan.slipNumber.toLowerCase().contains(q);
                    final matchName =
                        party?.name.toLowerCase().contains(q) ?? false;
                    final matchPhone = party?.mobile?.contains(q) ?? false;
                    if (!matchSlip && !matchName && !matchPhone) return false;
                  }
                  return true;
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.inbox_rounded,
                          size: 48,
                          color: colorScheme.outline,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No Girvi loans match your criteria.',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Create New Pledge'),
                          onPressed: () => context.go('/girvi/new'),
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
                    final loan = filtered[idx];
                    final party = partiesMap[loan.partyId];

                    final isGold = loan.metalType == MetalType.gold;

                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => context.go('/girvi/${loan.id}'),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: isGold
                                    ? Colors.amber.shade100
                                    : Colors.blueGrey.shade100,
                                child: Icon(
                                  Icons.diamond_rounded,
                                  color: isGold
                                      ? Colors.amber.shade900
                                      : Colors.blueGrey.shade900,
                                  size: 20,
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
                                          loan.slipNumber,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '• ${_dateFmt.format(loan.transactionDate)}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      party?.name ?? 'Customer #${loan.partyId}',
                                      style: TextStyle(
                                        color: colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      loan.itemDescription,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${loan.metalType.name.toUpperCase()} (${loan.purityPercent}%)',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      'Gross: ${loan.grossWeight.toStringAsFixed(2)}g | Net: ${loan.netWeight.toStringAsFixed(2)}g',
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
                                    Text(
                                      _currencyFmt.format(loan.principalAmount),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '${loan.roi}% / mo (${loan.interestType.name})',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(Icons.chevron_right_rounded),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error loading loans: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Pledge'),
        onPressed: () => context.go('/girvi/new'),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value, {
    required IconData icon,
    Color? iconColor,
    Color? color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: iconColor ?? colorScheme.outline),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
            Text(
              value,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color ?? colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
