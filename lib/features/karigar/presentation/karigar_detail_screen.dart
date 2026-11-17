import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tijori/app/theme/app_colors.dart';
import 'package:tijori/core/database/app_database.dart';
import 'package:tijori/core/licensing/freemium_service.dart';
import 'package:tijori/core/printing/slip_printer.dart';
import 'package:tijori/features/karigar/presentation/karigar_providers.dart';
import 'package:tijori/features/karigar/presentation/karigar_voucher_dialog.dart';
import 'package:tijori/features/parties/presentation/parties_providers.dart';
import 'package:tijori/features/settings/presentation/shop_profile_provider.dart';

class KarigarDetailScreen extends ConsumerStatefulWidget {
  final int karigarId;

  const KarigarDetailScreen({super.key, required this.karigarId});

  @override
  ConsumerState<KarigarDetailScreen> createState() =>
      _KarigarDetailScreenState();
}

class _KarigarDetailScreenState extends ConsumerState<KarigarDetailScreen> {
  final _currencyFmt = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
  final _dateFmt = DateFormat('dd MMM yyyy');

  KarigarTxnType? _filterType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final partiesAsync = ref.watch(allPartiesProvider);
    final txnsAsync = ref.watch(karigarTransactionsProvider(widget.karigarId));
    final summary = ref.watch(karigarSummaryProvider(widget.karigarId));

    return partiesAsync.when(
      data: (parties) {
        final karigar = parties.cast<Party?>().firstWhere(
              (p) => p?.id == widget.karigarId,
              orElse: () => null,
            );

        if (karigar == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Artisan (Karigar) not found')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('${karigar.name} — Metal Hisaab'),
            actions: [
              IconButton(
                tooltip: 'Print Metal Hisaab Statement',
                icon: const Icon(Icons.print_rounded),
                onPressed: () => _printHisaab(karigar, summary, txnsAsync.valueOrNull ?? []),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Karigar Profile & Net Pure Balance Card
                    Card(
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
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 24,
                                      backgroundColor: AppColors.champagneLight,
                                      child: Icon(
                                        Icons.handyman_rounded,
                                        color: AppColors.champagneDark,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          karigar.name,
                                          style: theme.textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Artisan ID #${karigar.id} • ${karigar.mobile ?? "No phone"}',
                                          style: TextStyle(
                                            color: colorScheme.onSurfaceVariant,
                                            fontSize: 13,
                                          ),
                                        ),
                                        if (karigar.address != null && karigar.address!.isNotEmpty)
                                          Text(
                                            'Workshop: ${karigar.address}',
                                            style: TextStyle(
                                              color: colorScheme.onSurfaceVariant,
                                              fontSize: 12,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),

                                // Net Pure Balance Pill
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: summary.pendingPureBalance > 0.001
                                        ? AppColors.burntAmberLight
                                        : AppColors.champagneLight,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: summary.pendingPureBalance > 0.001
                                          ? AppColors.burntAmber
                                          : AppColors.champagneBorder,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'NET PURE GOLD BALANCE',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                          color: summary.pendingPureBalance > 0.001
                                              ? AppColors.burntAmberDark
                                              : AppColors.champagneDark,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${summary.pendingPureBalance.toStringAsFixed(3)} g',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                          color: summary.pendingPureBalance > 0.001
                                              ? AppColors.burntAmberDark
                                              : AppColors.champagneDark,
                                        ),
                                      ),
                                      Text(
                                        summary.pendingPureBalance > 0.001
                                            ? 'Artisan holds shop pure metal'
                                            : (summary.pendingPureBalance < -0.001
                                                ? 'Shop owes pure metal'
                                                : 'Account Settled (0.000g)'),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 28),

                            // Quick Action Buttons
                            Wrap(
                              spacing: 12,
                              runSpacing: 10,
                              children: [
                                FilledButton.icon(
                                  icon: const Icon(Icons.outbox_rounded, size: 18),
                                  label: const Text('Issue Metal Voucher'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.burntAmber,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () => KarigarVoucherDialog.show(
                                    context,
                                    preselectedKarigar: karigar,
                                    initialType: KarigarTxnType.issue,
                                  ),
                                ),
                                FilledButton.tonalIcon(
                                  icon: const Icon(Icons.move_to_inbox_rounded, size: 18),
                                  label: const Text('Receive Finished Ornament'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.champagneLight,
                                    foregroundColor: AppColors.champagneDark,
                                  ),
                                  onPressed: () => KarigarVoucherDialog.show(
                                    context,
                                    preselectedKarigar: karigar,
                                    initialType: KarigarTxnType.receive,
                                  ),
                                ),
                                OutlinedButton.icon(
                                  icon: const Icon(Icons.print_outlined, size: 18),
                                  label: const Text('Print Hisaab Slip'),
                                  onPressed: () => _printHisaab(karigar, summary, txnsAsync.valueOrNull ?? []),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 2. Metrics Breakdown
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricTile(
                            'Total Pure Metal Issued',
                            '${summary.totalIssuedPure.toStringAsFixed(3)} g',
                            'Gross: ${summary.totalIssuedGross.toStringAsFixed(2)} g',
                            color: AppColors.burntAmber,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricTile(
                            'Total Pure Metal Received',
                            '${summary.totalReceivedPure.toStringAsFixed(3)} g',
                            'Gross: ${summary.totalReceivedGross.toStringAsFixed(2)} g',
                            color: AppColors.champagneDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricTile(
                            'Total Job Vouchers',
                            '${summary.transactionCount}',
                            'All time issue/receive logs',
                            color: AppColors.mochaPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // 3. Transactions Filter & History Table
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
                                Text(
                                  'Job Vouchers & Metal Movements',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SegmentedButton<KarigarTxnType?>(
                                  segments: const [
                                    ButtonSegment(value: null, label: Text('All')),
                                    ButtonSegment(
                                      value: KarigarTxnType.issue,
                                      label: Text('Issues'),
                                    ),
                                    ButtonSegment(
                                      value: KarigarTxnType.receive,
                                      label: Text('Receives'),
                                    ),
                                  ],
                                  selected: {_filterType},
                                  onSelectionChanged: (set) {
                                    setState(() => _filterType = set.first);
                                  },
                                ),
                              ],
                            ),
                            const Divider(height: 20),

                            txnsAsync.when(
                              data: (txns) {
                                final filtered = _filterType == null
                                    ? txns
                                    : txns.where((t) => t.type == _filterType).toList();

                                if (filtered.isEmpty) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 36),
                                    child: Center(
                                      child: Text('No job vouchers recorded for this filter.'),
                                    ),
                                  );
                                }

                                return ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: filtered.length,
                                  separatorBuilder: (_, __) => const Divider(height: 1),
                                  itemBuilder: (context, index) {
                                    final t = filtered[index];
                                    final isIssue = t.type == KarigarTxnType.issue;

                                    return ListTile(
                                      contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                                      leading: CircleAvatar(
                                        radius: 18,
                                        backgroundColor: isIssue
                                            ? AppColors.burntAmberLight
                                            : AppColors.champagneLight,
                                        child: Icon(
                                          isIssue ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                                          color: isIssue ? AppColors.burntAmber : AppColors.champagneDark,
                                          size: 18,
                                        ),
                                      ),
                                      title: Row(
                                        children: [
                                          Text(
                                            t.voucherNumber,
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                            decoration: BoxDecoration(
                                              color: isIssue ? AppColors.burntAmberLight : AppColors.champagneLight,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              isIssue ? 'ISSUE' : 'RECEIVE',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: isIssue ? AppColors.burntAmberDark : AppColors.champagneDark,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            t.itemDescription,
                                            style: TextStyle(color: colorScheme.onSurfaceVariant),
                                          ),
                                        ],
                                      ),
                                      subtitle: Text(
                                        'Gross: ${t.grossWeight.toStringAsFixed(2)}g • Touch: ${t.purityPercent.toStringAsFixed(1)}% • ${t.quantity} pc(s) • ${_dateFmt.format(t.date)}'
                                        '${t.remarks != null && t.remarks!.isNotEmpty ? " • ${t.remarks}" : ""}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${t.netWeight.toStringAsFixed(3)} g Pure',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 14,
                                              color: isIssue ? AppColors.burntAmberDark : AppColors.champagneDark,
                                            ),
                                          ),
                                          if (t.estimatedValue != null)
                                            Text(
                                              _currencyFmt.format(t.estimatedValue),
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: colorScheme.onSurfaceVariant,
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              loading: () => const LinearProgressIndicator(),
                              error: (e, _) => Text('Error loading vouchers: $e'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }

  Widget _buildMetricTile(String title, String mainValue, String subValue, {required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            mainValue,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subValue,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _printHisaab(
    Party karigar,
    KarigarMetalSummary summary,
    List<KarigarTransaction> transactions,
  ) async {
    final shopProfile = ref.read(shopProfileProvider);
    final watermark = ref.read(freemiumProvider.notifier).getPdfWatermark();

    await SlipPrinter.printSlip(
      context,
      documentName: 'karigar_hisaab_${karigar.id}',
      onGeneratePdf: () => SlipPrinter.generateKarigarHisaabPdf(
        karigar: karigar,
        transactions: transactions,
        totalIssuedPure: summary.totalIssuedPure,
        totalReceivedPure: summary.totalReceivedPure,
        pendingPureBalance: summary.pendingPureBalance,
        shopName: shopProfile.shopName,
        shopAddress: shopProfile.address,
        shopPhone: shopProfile.phone,
        watermarkText: watermark,
      ),
    );
  }
}
