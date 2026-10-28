import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tijori/app/theme/app_colors.dart';
import 'package:tijori/core/database/app_database.dart';
import 'package:tijori/core/licensing/freemium_guard.dart';
import 'package:tijori/core/licensing/license_models.dart';
import 'package:tijori/features/karigar/presentation/karigar_providers.dart';
import 'package:tijori/features/karigar/presentation/karigar_voucher_dialog.dart';
import 'package:tijori/features/parties/presentation/parties_providers.dart';
import 'package:tijori/features/parties/presentation/quick_add_party_dialog.dart';

class KarigarScreen extends ConsumerStatefulWidget {
  const KarigarScreen({super.key});

  @override
  ConsumerState<KarigarScreen> createState() => _KarigarScreenState();
}

class _KarigarScreenState extends ConsumerState<KarigarScreen> {
  final _searchCtrl = TextEditingController();
  final _dateFmt = DateFormat('dd MMM yyyy');

  String _searchQuery = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Karigar (Artisan) Metal Management'),
        actions: [
          IconButton(
            tooltip: 'Add New Goldsmith',
            icon: const Icon(Icons.person_add_alt_1_rounded),
            onPressed: () => QuickAddPartyDialog.show(
              context,
              initialGroup: PartyGroupType.karigar,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FreemiumGuard(
        feature: GatedFeature.karigarManagement,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Quick Actions Bar
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  FilledButton.icon(
                    icon: const Icon(Icons.outbox_rounded, size: 18),
                    label: const Text('Issue Metal Voucher'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.burntAmber,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                    onPressed: () => KarigarVoucherDialog.show(
                      context,
                      initialType: KarigarTxnType.issue,
                    ),
                  ),
                  FilledButton.tonalIcon(
                    icon: const Icon(Icons.move_to_inbox_rounded, size: 18),
                    label: const Text('Receive Finished Work'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.champagneLight,
                      foregroundColor: AppColors.champagneDark,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                    onPressed: () => KarigarVoucherDialog.show(
                      context,
                      initialType: KarigarTxnType.receive,
                    ),
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.person_add_rounded, size: 18),
                    label: const Text('Register Goldsmith (Karigar)'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                    onPressed: () => QuickAddPartyDialog.show(
                      context,
                      initialGroup: PartyGroupType.karigar,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 2. Workshop Statistics Header
              Consumer(
                builder: (context, ref, _) {
                  final stats = ref.watch(karigarWorkshopStatsProvider);

                  return Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          title: 'Net Gold with Artisans',
                          value: '${stats.totalOutstandingPureGold.toStringAsFixed(3)} g',
                          subtitle: '${stats.artisansHoldingGold} artisans holding pure metal',
                          color: AppColors.burntAmber,
                          icon: Icons.shield_rounded,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _buildSummaryCard(
                          title: 'Total Pure Issued',
                          value: '${stats.totalIssuedPureGold.toStringAsFixed(3)} g',
                          subtitle: 'Raw metal & scrap sent out',
                          color: AppColors.mochaPrimary,
                          icon: Icons.outbox_rounded,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _buildSummaryCard(
                          title: 'Total Pure Received',
                          value: '${stats.totalReceivedPureGold.toStringAsFixed(3)} g',
                          subtitle: 'Crafted jewellery returned',
                          color: AppColors.champagneDark,
                          icon: Icons.move_to_inbox_rounded,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

              // 3. Search Bar
              TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Search goldsmiths by name, mobile, or address...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                ),
                onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
              ),
              const SizedBox(height: 20),

              // 4. Karigars List & Ledger Directory
              Consumer(
                builder: (context, ref, _) {
                  final karigarsAsync = ref.watch(allKarigarsProvider);

                  return karigarsAsync.when(
                    data: (karigars) {
                      final filtered = karigars.where((k) {
                        if (_searchQuery.isEmpty) return true;
                        final name = k.name.toLowerCase();
                        final mobile = (k.mobile ?? '').toLowerCase();
                        final addr = (k.address ?? '').toLowerCase();
                        return name.contains(_searchQuery) ||
                            mobile.contains(_searchQuery) ||
                            addr.contains(_searchQuery);
                      }).toList();

                      if (filtered.isEmpty) {
                        return Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: colorScheme.outlineVariant),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.handyman_outlined,
                                  size: 48,
                                  color: colorScheme.outline,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  karigars.isEmpty
                                      ? 'No Goldsmiths (Karigars) registered yet.'
                                      : 'No matching artisans found for "$_searchQuery".',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Register your goldsmiths to track raw gold issues, finished ornament receipts, and pure metal balances.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 16),
                                FilledButton.icon(
                                  icon: const Icon(Icons.person_add_rounded),
                                  label: const Text('Add Goldsmith Now'),
                                  onPressed: () => QuickAddPartyDialog.show(
                                    context,
                                    initialGroup: PartyGroupType.karigar,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 800;
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isWide ? 2 : 1,
                              mainAxisExtent: 180,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final k = filtered[index];
                              return _buildArtisanCard(context, ref, k);
                            },
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('Error loading artisans: $e')),
                  );
                },
              ),
              const SizedBox(height: 28),

              // 5. Recent Job Vouchers Log
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: colorScheme.outlineVariant),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.history_rounded, color: AppColors.mochaPrimary),
                              const SizedBox(width: 8),
                              Text(
                                'Recent Metal Movements (All Artisans)',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(height: 20),

                      Consumer(
                        builder: (context, ref, _) {
                          final allTxnsAsync = ref.watch(allKarigarTransactionsProvider);
                          final partiesAsync = ref.watch(allPartiesProvider);

                          return allTxnsAsync.when(
                            data: (txns) {
                              if (txns.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 30),
                                  child: Center(
                                    child: Text('No metal vouchers issued or received yet.'),
                                  ),
                                );
                              }

                              final partyMap = {
                                for (final p in partiesAsync.valueOrNull ?? <Party>[])
                                  p.id: p,
                              };

                              final recent = txns.take(10).toList();

                              return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: recent.length,
                                separatorBuilder: (_, __) => const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final t = recent[index];
                                  final isIssue = t.type == KarigarTxnType.issue;
                                  final karigar = partyMap[t.karigarId];

                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                    leading: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: isIssue
                                          ? AppColors.burntAmberLight
                                          : AppColors.champagneLight,
                                      child: Icon(
                                        isIssue ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                                        color: isIssue ? AppColors.burntAmber : AppColors.champagneDark,
                                        size: 16,
                                      ),
                                    ),
                                    title: Text(
                                      '${t.voucherNumber} • ${karigar?.name ?? "Artisan #${t.karigarId}"}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      '${t.itemDescription} (${t.grossWeight}g gross, ${t.purityPercent}% touch) • ${_dateFmt.format(t.date)}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    trailing: Text(
                                      '${t.netWeight.toStringAsFixed(3)} g Pure',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: isIssue ? AppColors.burntAmberDark : AppColors.champagneDark,
                                      ),
                                    ),
                                    onTap: () {
                                      if (karigar != null) {
                                        context.go('/karigar/${karigar.id}');
                                      }
                                    },
                                  );
                                },
                              );
                            },
                            loading: () => const LinearProgressIndicator(),
                            error: (e, _) => Text('Error loading transactions: $e'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Icon(icon, size: 20, color: color),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtisanCard(BuildContext context, WidgetRef ref, Party karigar) {
    final summary = ref.watch(karigarSummaryProvider(karigar.id));
    final hasPending = summary.pendingPureBalance > 0.001;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: hasPending ? AppColors.burntAmber.withValues(alpha: 0.5) : Theme.of(context).colorScheme.outlineVariant,
          width: hasPending ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.champagneLight,
                        child: Icon(
                          Icons.handyman_rounded,
                          size: 18,
                          color: AppColors.champagneDark,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              karigar.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              karigar.mobile ?? 'No contact phone',
                              style: TextStyle(
                                fontSize: 11,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: hasPending ? AppColors.burntAmberLight : AppColors.champagneLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: hasPending ? AppColors.burntAmber : AppColors.champagneBorder,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${summary.pendingPureBalance.toStringAsFixed(3)} g',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          color: hasPending ? AppColors.burntAmberDark : AppColors.champagneDark,
                        ),
                      ),
                      Text(
                        hasPending ? 'Pure Gold Due' : 'Settled',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: hasPending ? AppColors.burntAmberDark : AppColors.champagneDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Issued: ${summary.totalIssuedPure.toStringAsFixed(2)}g • Rcvd: ${summary.totalReceivedPure.toStringAsFixed(2)}g',
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.arrow_forward_rounded, size: 14),
                  label: const Text('Open Hisaab'),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  onPressed: () => context.go('/karigar/${karigar.id}'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
