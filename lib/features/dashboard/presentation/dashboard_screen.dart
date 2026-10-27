import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tijori/core/database/app_database.dart';
import 'package:tijori/features/daily_rates/presentation/daily_rates_providers.dart';
import 'package:tijori/features/daily_rates/presentation/update_rates_dialog.dart';
import 'package:tijori/features/girvi/presentation/girvi_providers.dart';
import 'package:tijori/features/parties/presentation/parties_providers.dart';
import 'package:tijori/features/parties/presentation/quick_add_party_dialog.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currencyFmt = NumberFormat.currency(locale: 'en_IN', symbol: '₹ ');
    final dateFmt = DateFormat('dd MMM yyyy');

    final stats = ref.watch(girviStatsProvider);
    final latestRateAsync = ref.watch(latestDailyRateProvider);
    final activeLoansAsync = ref.watch(activeLoansProvider);
    final partiesAsync = ref.watch(allPartiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard & Overview'),
        actions: [
          IconButton(
            tooltip: 'Update Daily Rates',
            icon: const Icon(Icons.price_change_outlined),
            onPressed: () => UpdateRatesDialog.show(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final card1 = _buildMetricCard(
            context,
            title: 'Active Pawn Principal',
            value: currencyFmt.format(stats.totalPrincipal),
            subtitle: '${stats.activeLoansCount} active customer loans',
            icon: Icons.account_balance_wallet_rounded,
            color: colorScheme.primary,
          );

          final card2 = _buildMetricCard(
            context,
            title: 'Collateral Vault Valuation',
            value: currencyFmt.format(stats.totalEstimatedValuation),
            subtitle: 'Estimated metal market value',
            icon: Icons.shield_rounded,
            color: Colors.teal.shade700,
          );

          final card3 = _buildMetricCard(
            context,
            title: 'Gold Pledged in Safe',
            value: '${stats.totalGoldGrossWeight.toStringAsFixed(2)} g',
            subtitle: 'Vault inventory weight',
            icon: Icons.circle,
            color: Colors.amber.shade800,
          );

          final card4 = _buildMetricCard(
            context,
            title: 'Silver Pledged in Safe',
            value: '${stats.totalSilverGrossWeight.toStringAsFixed(2)} g',
            subtitle: 'Vault inventory weight',
            icon: Icons.circle,
            color: Colors.blueGrey.shade700,
          );

          final ratesCard = Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: colorScheme.outlineVariant),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Today\'s Market Rates',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: const Text('Edit'),
                        onPressed: () => UpdateRatesDialog.show(context),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  latestRateAsync.when(
                    data: (rate) {
                      if (rate == null) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text('No rates set today yet.'),
                          ),
                        );
                      }

                      return Column(
                        children: [
                          _buildRateRow('Gold 24K (999)', rate.gold24k),
                          const Divider(height: 12),
                          _buildRateRow('Gold 22K (916)', rate.gold22k),
                          const Divider(height: 12),
                          _buildRateRow('Gold 18K (750)', rate.gold18k),
                          const Divider(height: 12),
                          _buildRateRow('Silver (Fine)', rate.silverRate),
                        ],
                      );
                    },
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text('Error loading rates: $e'),
                  ),
                ],
              ),
            ),
          );

          final recentLoansCard = Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: colorScheme.outlineVariant),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Recent Girvi Pledges',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/girvi'),
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  activeLoansAsync.when(
                    data: (loans) {
                      if (loans.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 30),
                          child: Center(
                            child: Text('No active loans yet.'),
                          ),
                        );
                      }

                      final partiesMap = {
                        for (final p in partiesAsync.valueOrNull ?? <Party>[])
                          p.id: p,
                      };

                      final recent = loans.take(5).toList();

                      return Column(
                        children: recent.map((loan) {
                          final party = partiesMap[loan.partyId];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              radius: 18,
                              backgroundColor: loan.metalType == MetalType.gold
                                  ? Colors.amber.shade100
                                  : Colors.blueGrey.shade100,
                              child: Icon(
                                Icons.diamond_rounded,
                                size: 16,
                                color: loan.metalType == MetalType.gold
                                    ? Colors.amber.shade900
                                    : Colors.blueGrey.shade900,
                              ),
                            ),
                            title: Text(
                              '${loan.slipNumber} • ${party?.name ?? "Party #${loan.partyId}"}',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              '${loan.itemDescription} (${loan.netWeight}g net) • ${dateFmt.format(loan.transactionDate)}',
                            ),
                            trailing: Text(
                              currencyFmt.format(loan.principalAmount),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () => context.go('/girvi/${loan.id}'),
                          );
                        }).toList(),
                      );
                    },
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text('Error: $e'),
                  ),
                ],
              ),
            ),
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Quick Actions Banner
                Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: [
                    FilledButton.icon(
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      label: const Text('New Girvi Pledge'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      onPressed: () => context.go('/girvi/new'),
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.price_change_outlined),
                      label: const Text('Set Today\'s Metal Rates'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      onPressed: () => UpdateRatesDialog.show(context),
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.person_add_outlined),
                      label: const Text('Register Party / Customer'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      onPressed: () => QuickAddPartyDialog.show(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 2. Responsive Metrics Grid
                if (constraints.maxWidth < 650)
                  Column(
                    children: [
                      card1,
                      const SizedBox(height: 12),
                      card2,
                      const SizedBox(height: 12),
                      card3,
                      const SizedBox(height: 12),
                      card4,
                    ],
                  )
                else if (constraints.maxWidth < 1100)
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: card1),
                          const SizedBox(width: 14),
                          Expanded(child: card2),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(child: card3),
                          const SizedBox(width: 14),
                          Expanded(child: card4),
                        ],
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(child: card1),
                      const SizedBox(width: 16),
                      Expanded(child: card2),
                      const SizedBox(width: 16),
                      Expanded(child: card3),
                      const SizedBox(width: 16),
                      Expanded(child: card4),
                    ],
                  ),
                const SizedBox(height: 24),

                // 3. Middle Section
                if (constraints.maxWidth < 850)
                  Column(
                    children: [
                      ratesCard,
                      const SizedBox(height: 20),
                      recentLoansCard,
                    ],
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: ratesCard),
                      const SizedBox(width: 20),
                      Expanded(flex: 3, child: recentLoansCard),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(icon, size: 20, color: color),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRateRow(String metal, double? rate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(metal, style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(
          rate != null ? '₹ ${rate.toStringAsFixed(1)} / g' : '—',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
