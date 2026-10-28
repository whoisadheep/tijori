import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tijori/app/theme/app_colors.dart';
import 'package:tijori/core/database/app_database.dart';
import 'package:tijori/core/licensing/freemium_guard.dart';
import 'package:tijori/core/licensing/freemium_service.dart';
import 'package:tijori/core/printing/slip_printer.dart';
import 'package:tijori/features/gst/presentation/gst_providers.dart';
import 'package:tijori/features/gst/presentation/new_gst_voucher_dialog.dart';
import 'package:tijori/features/parties/presentation/parties_providers.dart';

class GstScreen extends ConsumerStatefulWidget {
  const GstScreen({super.key});

  @override
  ConsumerState<GstScreen> createState() => _GstScreenState();
}

class _GstScreenState extends ConsumerState<GstScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _currencyFmt = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
  final _dateFmt = DateFormat('dd MMM yyyy');

  GstVoucherType? _filterType;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('GST Billing & Daily Cash Register'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.burntAmber,
          labelColor: AppColors.burntAmber,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          tabs: const [
            Tab(
              icon: Icon(Icons.receipt_long_rounded, size: 20),
              text: 'GST Tax Invoices & Registers',
            ),
            Tab(
              icon: Icon(Icons.point_of_sale_rounded, size: 20),
              text: 'Daily Cash Drawer (Rojnamcha)',
            ),
          ],
        ),
      ),
      body: FreemiumGuard(
        feature: GatedFeature.gstVouchers,
        child: TabBarView(
          controller: _tabController,
          children: [
            // TAB 1: GST Invoices & Registers
            _buildGstInvoicesTab(context, colorScheme, theme),

            // TAB 2: Daily Cash Drawer & Daybook
            _buildCashDrawerTab(context, colorScheme, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildGstInvoicesTab(
    BuildContext context,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    final summary = ref.watch(gstTaxSummaryProvider);
    final vouchersAsync = ref.watch(allGstVouchersProvider);
    final partiesAsync = ref.watch(allPartiesProvider);

    return SingleChildScrollView(
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
                icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
                label: const Text('New Jewellery Tax Invoice'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.burntAmber,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
                onPressed: () => NewGstVoucherDialog.show(
                  context,
                  initialType: GstVoucherType.sale,
                ),
              ),
              FilledButton.tonalIcon(
                icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                label: const Text('Record Metal Purchase'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.champagneLight,
                  foregroundColor: AppColors.champagneDark,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
                onPressed: () => NewGstVoucherDialog.show(
                  context,
                  initialType: GstVoucherType.purchase,
                ),
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.money_off_rounded, size: 18),
                label: const Text('Record Operating Expense'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
                onPressed: () => NewGstVoucherDialog.show(
                  context,
                  initialType: GstVoucherType.expense,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 2. GST Metrics Overview Grid
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'Taxable Sales Turnover',
                  value: _currencyFmt.format(summary.totalTaxableSales),
                  subtitle: '${summary.totalSalesCount} tax invoices issued',
                  color: AppColors.mochaPrimary,
                  icon: Icons.storefront_rounded,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildMetricCard(
                  title: 'Total GST Collected',
                  value: _currencyFmt.format(summary.totalTaxCollected),
                  subtitle: 'CGST: ${_currencyFmt.format(summary.totalCgstCollected)} • SGST: ${_currencyFmt.format(summary.totalSgstCollected)}',
                  color: AppColors.burntAmber,
                  icon: Icons.account_balance_rounded,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildMetricCard(
                  title: 'Operating Expenses',
                  value: _currencyFmt.format(summary.totalExpenses),
                  subtitle: '${summary.totalExpensesCount} expense vouchers',
                  color: colorScheme.onSurfaceVariant,
                  icon: Icons.receipt_long_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 3. Filterable Vouchers Directory
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
                          const Icon(Icons.menu_book_rounded, color: AppColors.mochaPrimary),
                          const SizedBox(width: 8),
                          Text(
                            'GST Accounting Vouchers Register',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SegmentedButton<GstVoucherType?>(
                        segments: const [
                          ButtonSegment(value: null, label: Text('All')),
                          ButtonSegment(value: GstVoucherType.sale, label: Text('Sales')),
                          ButtonSegment(value: GstVoucherType.purchase, label: Text('Purchases')),
                          ButtonSegment(value: GstVoucherType.expense, label: Text('Expenses')),
                        ],
                        selected: {_filterType},
                        onSelectionChanged: (set) {
                          setState(() => _filterType = set.first);
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  vouchersAsync.when(
                    data: (vouchers) {
                      final filtered = _filterType == null
                          ? vouchers
                          : vouchers.where((v) => v.voucherType == _filterType).toList();

                      if (filtered.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Text('No accounting vouchers recorded yet for this category.'),
                          ),
                        );
                      }

                      final partyMap = {
                        for (final p in partiesAsync.valueOrNull ?? <Party>[])
                          p.id: p,
                      };

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final v = filtered[index];
                          final party = partyMap[v.partyId];
                          final isSale = v.voucherType == GstVoucherType.sale;

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundColor: isSale
                                  ? AppColors.champagneLight
                                  : AppColors.burntAmberLight,
                              child: Icon(
                                isSale ? Icons.receipt_long_rounded : Icons.payments_outlined,
                                color: isSale ? AppColors.champagneDark : AppColors.burntAmber,
                                size: 18,
                              ),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  v.billNumber,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: isSale ? AppColors.champagneLight : AppColors.burntAmberLight,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    v.voucherType.name.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isSale ? AppColors.champagneDark : AppColors.burntAmberDark,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${party?.name ?? "Party #${v.partyId}"} • ${v.description}',
                                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              'Taxable: ${_currencyFmt.format(v.taxableAmount)} • GST (${v.taxSlabPercent}%): ${_currencyFmt.format(v.cgstAmount + v.sgstAmount)} • ${v.paymentTerm.name.toUpperCase()} • ${_dateFmt.format(v.date)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _currencyFmt.format(v.totalAmount),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15,
                                    color: isSale ? AppColors.champagneDark : colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  tooltip: 'Print GST Invoice Slip',
                                  icon: const Icon(Icons.print_rounded, size: 20),
                                  onPressed: () async {
                                    if (party != null) {
                                      final license = ref.read(freemiumProvider);
                                      final watermark = ref.read(freemiumProvider.notifier).getPdfWatermark();

                                      await SlipPrinter.printSlip(
                                        context,
                                        documentName: 'invoice_${v.billNumber}',
                                        onGeneratePdf: () => SlipPrinter.generateGstInvoicePdf(
                                          voucher: v,
                                          party: party,
                                          shopName: license.shopName,
                                          watermarkText: watermark,
                                        ),
                                      );
                                    }
                                  },
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
    );
  }

  Widget _buildCashDrawerTab(
    BuildContext context,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    final cashState = ref.watch(dailyCashRegisterProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Cash Drawer Big Status Card
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.champagneGold, width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.point_of_sale_rounded, color: AppColors.burntAmber),
                          const SizedBox(width: 8),
                          Text(
                            'NET SAFE CASH IN DRAWER',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _currencyFmt.format(cashState.netCashDrawerBalance),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: AppColors.champagneDark,
                        ),
                      ),
                      Text(
                        'Real-time physical currency balance (Girvi cash + Sales cash - Outflows)',
                        style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),

                  // Cash In vs Cash Out pills
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.champagneLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.champagneBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('TOTAL CASH IN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.champagneDark)),
                            const SizedBox(height: 2),
                            Text(
                              _currencyFmt.format(cashState.totalCashInflows),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.champagneDark),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.burntAmberLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.burntAmber.withValues(alpha: 0.5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('TOTAL CASH OUT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.burntAmberDark)),
                            const SizedBox(height: 2),
                            Text(
                              _currencyFmt.format(cashState.totalCashOutflows),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.burntAmberDark),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 2. Chronological Cash Audit Log
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
                    children: [
                      const Icon(Icons.history_rounded, color: AppColors.mochaPrimary),
                      const SizedBox(width: 8),
                      Text(
                        'Daybook Chronological Cash Movements (Rojnamcha)',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),

                  if (cashState.entries.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text('No cash transactions recorded in the drawer yet.'),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cashState.entries.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final entry = cashState.entries[index];

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          leading: CircleAvatar(
                            radius: 18,
                            backgroundColor: entry.isInflow
                                ? AppColors.champagneLight
                                : AppColors.burntAmberLight,
                            child: Icon(
                              entry.isInflow ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                              color: entry.isInflow ? AppColors.champagneDark : AppColors.burntAmberDark,
                              size: 18,
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                entry.referenceNumber,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: entry.isInflow ? AppColors.champagneLight : AppColors.burntAmberLight,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  entry.category,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: entry.isInflow ? AppColors.champagneDark : AppColors.burntAmberDark,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  entry.description,
                                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(_dateFmt.format(entry.date), style: const TextStyle(fontSize: 12)),
                          trailing: Text(
                            '${entry.isInflow ? "+" : "-"}${_currencyFmt.format(entry.amount)}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: entry.isInflow ? AppColors.champagneDark : AppColors.burntAmberDark,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
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
}
