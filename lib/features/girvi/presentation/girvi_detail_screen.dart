import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tijori/core/database/app_database.dart';
import 'package:tijori/core/licensing/freemium_service.dart';
import 'package:tijori/core/printing/slip_printer.dart';
import 'package:tijori/features/parties/presentation/parties_providers.dart';

import 'girvi_providers.dart';

class GirviDetailScreen extends ConsumerStatefulWidget {
  final int loanId;

  const GirviDetailScreen({super.key, required this.loanId});

  @override
  ConsumerState<GirviDetailScreen> createState() => _GirviDetailScreenState();
}

class _GirviDetailScreenState extends ConsumerState<GirviDetailScreen> {
  final _currencyFmt = NumberFormat.currency(locale: 'en_IN', symbol: '₹ ');
  final _dateFmt = DateFormat('dd MMM yyyy');
  final _dateTimeFmt = DateFormat('dd MMM yyyy, hh:mm a');

  Future<void> _openCollectPaymentDialog(GirviLoan loan, Party? party) async {
    final receiptsDao = ref.read(loanReceiptsDaoProvider);
    final nextRecNo = await receiptsDao.generateNextReceiptNumber();

    ReceiptType selectedType = ReceiptType.interestOnly;
    final amountCtrl = TextEditingController();
    final remarksCtrl = TextEditingController();
    PaymentMode paymentMode = PaymentMode.cash;

    if (!mounted) return;

    final success = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Collect Loan Payment ($nextRecNo)'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SegmentedButton<ReceiptType>(
                      segments: const [
                        ButtonSegment(
                          value: ReceiptType.interestOnly,
                          label: Text('Interest Only'),
                        ),
                        ButtonSegment(
                          value: ReceiptType.principalRepayment,
                          label: Text('Principal Repayment'),
                        ),
                      ],
                      selected: {selectedType},
                      onSelectionChanged: (v) {
                        setDialogState(() => selectedType = v.first);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: amountCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Amount Received *',
                        prefixText: '₹ ',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<PaymentMode>(
                      initialValue: paymentMode,
                      decoration: const InputDecoration(
                        labelText: 'Payment Mode',
                        isDense: true,
                      ),
                      items: PaymentMode.values
                          .map((m) => DropdownMenuItem(
                                value: m,
                                child: Text(m.name.toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setDialogState(() => paymentMode = v);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: remarksCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Remarks / Transaction Ref',
                        isDense: true,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Record Receipt'),
                  onPressed: () async {
                    final amount = double.tryParse(amountCtrl.text);
                    if (amount == null || amount <= 0) return;

                    final companion = LoanReceiptsCompanion.insert(
                      receiptNumber: nextRecNo,
                      loanId: loan.id,
                      date: DateTime.now(),
                      paymentMode: paymentMode,
                      receiptType: selectedType,
                      amount: amount,
                      remarks: remarksCtrl.text.trim().isNotEmpty
                          ? drift.Value(remarksCtrl.text.trim())
                          : const drift.Value.absent(),
                    );

                    await receiptsDao.insertReceipt(companion);

                    if (context.mounted) {
                      Navigator.of(ctx).pop(true);
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (success == true && mounted && party != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment recorded successfully!')),
      );
    }
  }

  Future<void> _closeLoan(GirviLoan loan) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Close & Release Pledge?'),
        content: Text(
          'Mark loan #${loan.slipNumber} as CLOSED? Ensure all outstanding amounts have been settled and the pledged ornament has been handed over to the customer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Confirm Loan Closure'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final dao = ref.read(girviLoansDaoProvider);
      await dao.updateLoan(loan.copyWith(status: LoanStatus.closed));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Loan marked as CLOSED successfully.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final loanAsync = ref.watch(loanDetailProvider(widget.loanId));
    final ledgerAsync = ref.watch(loanLedgerProvider(widget.loanId));
    final receiptsAsync = ref.watch(loanReceiptsProvider(widget.loanId));
    final partiesAsync = ref.watch(allPartiesProvider);

    return loanAsync.when(
      data: (loan) {
        if (loan == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Loan not found')),
          );
        }

        final party = partiesAsync.valueOrNull?.cast<Party?>().firstWhere(
              (p) => p?.id == loan.partyId,
              orElse: () => null,
            );

        final isClosed = loan.status == LoanStatus.closed;

        return Scaffold(
          appBar: AppBar(
            title: Text('Slip #${loan.slipNumber}'),
            actions: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: isClosed
                      ? Colors.teal.shade100
                      : colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    loan.status.name.toUpperCase(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isClosed
                          ? Colors.teal.shade900
                          : colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Print Pledge Slip',
                icon: const Icon(Icons.print_rounded),
                onPressed: () {
                  if (party == null) return;
                  final license = ref.read(freemiumProvider);
                  final watermark =
                      ref.read(freemiumProvider.notifier).getPdfWatermark();
                  SlipPrinter.printSlip(
                    context,
                    onGeneratePdf: () => SlipPrinter.generateGirviSlipPdf(
                      loan: loan,
                      party: party,
                      shopName: license.shopName,
                      watermarkText: watermark,
                      isThermal: true,
                    ),
                    documentName: 'Slip_${loan.slipNumber}',
                  );
                },
              ),
              const SizedBox(width: 12),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Info Card
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      party?.name ?? 'Customer #${loan.partyId}',
                                      style:
                                          theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (party?.mobile != null)
                                      Text(
                                        'Mobile: ${party!.mobile}',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Issued: ${_dateFmt.format(loan.transactionDate)}',
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                    Text(
                                      'ROI: ${loan.roi}% / mo (${loan.interestType.name})',
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            // Pledged Article Specs
                            Row(
                              children: [
                                _buildSpecPill(
                                  context,
                                  'Metal',
                                  loan.metalType.name.toUpperCase(),
                                  icon: Icons.diamond_outlined,
                                ),
                                const SizedBox(width: 12),
                                _buildSpecPill(
                                  context,
                                  'Gross Weight',
                                  '${loan.grossWeight.toStringAsFixed(2)}g',
                                ),
                                const SizedBox(width: 12),
                                _buildSpecPill(
                                  context,
                                  'Purity',
                                  '${loan.purityPercent.toStringAsFixed(1)}%',
                                ),
                                const SizedBox(width: 12),
                                _buildSpecPill(
                                  context,
                                  'Net Weight',
                                  '${loan.netWeight.toStringAsFixed(2)}g',
                                ),
                                const SizedBox(width: 12),
                                _buildSpecPill(
                                  context,
                                  'Valuation',
                                  _currencyFmt.format(loan.estimatedValue),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Item: ${loan.itemDescription}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (loan.rackLocation != null &&
                                loan.rackLocation!.isNotEmpty)
                              Text(
                                'Location: ${loan.rackLocation}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Live Ledger Computation Card
                    ledgerAsync.when(
                      data: (ledger) {
                        if (ledger == null) return const SizedBox.shrink();

                        return Card(
                          elevation: 1,
                          color: colorScheme.primaryContainer.withValues(alpha: 0.25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calculate_rounded,
                                          color: colorScheme.primary,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Live Outstanding & Interest Ledger',
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'As of Today (${_dateFmt.format(DateTime.now())})',
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Ledger Metrics Grid
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildMetricTile(
                                        context,
                                        'Principal Sanctioned',
                                        _currencyFmt.format(ledger.initialPrincipal),
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildMetricTile(
                                        context,
                                        'Principal Repaid',
                                        _currencyFmt
                                            .format(ledger.totalPrincipalRepaid),
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildMetricTile(
                                        context,
                                        'Remaining Principal',
                                        _currencyFmt
                                            .format(ledger.remainingPrincipal),
                                        isBold: true,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildMetricTile(
                                        context,
                                        'Total Interest Accrued',
                                        _currencyFmt
                                            .format(ledger.totalAccruedInterest),
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildMetricTile(
                                        context,
                                        'Total Interest Paid',
                                        _currencyFmt
                                            .format(ledger.totalInterestPaid),
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildMetricTile(
                                        context,
                                        'Pending Interest Due',
                                        _currencyFmt.format(ledger.pendingInterest),
                                        color: Colors.deepOrange.shade700,
                                        isBold: true,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 24),

                                // Total Outstanding
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: colorScheme.primary,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'TOTAL OUTSTANDING BALANCE',
                                            style: theme.textTheme.labelMedium
                                                ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: colorScheme.primary,
                                            ),
                                          ),
                                          Text(
                                            'Remaining Principal + Pending Interest',
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        _currencyFmt
                                            .format(ledger.totalOutstanding),
                                        style: theme.textTheme.headlineSmall
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.primary,
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
                      loading: () => const LinearProgressIndicator(),
                      error: (e, _) => Text('Ledger error: $e'),
                    ),
                    const SizedBox(height: 16),

                    // Action Buttons Bar
                    if (!isClosed)
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              icon: const Icon(Icons.payment_rounded),
                              label: const Text('Collect Payment (Receipt)'),
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.all(16),
                              ),
                              onPressed: () =>
                                  _openCollectPaymentDialog(loan, party),
                            ),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.done_all_rounded),
                            label: const Text('Close & Release Pledge'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                            ),
                            onPressed: () => _closeLoan(loan),
                          ),
                        ],
                      ),
                    const SizedBox(height: 24),

                    // Receipts History
                    Text(
                      'Payment & Receipt History',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    receiptsAsync.when(
                      data: (receipts) {
                        if (receipts.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(24),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'No receipts recorded yet.',
                              style: TextStyle(
                                  color: colorScheme.onSurfaceVariant),
                            ),
                          );
                        }

                        return Column(
                          children: receipts.map((rec) {
                            final isInterest =
                                rec.receiptType == ReceiptType.interestOnly;

                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: colorScheme.outlineVariant,
                                ),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: isInterest
                                      ? Colors.amber.shade100
                                      : Colors.green.shade100,
                                  child: Icon(
                                    isInterest
                                        ? Icons.percent_rounded
                                        : Icons.account_balance_wallet_rounded,
                                    size: 18,
                                    color: isInterest
                                        ? Colors.amber.shade900
                                        : Colors.green.shade900,
                                  ),
                                ),
                                title: Text(
                                  '${rec.receiptNumber} — ${_currencyFmt.format(rec.amount)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  '${isInterest ? "Interest Only" : "Principal Repayment"} via ${rec.paymentMode.name.toUpperCase()} • ${_dateTimeFmt.format(rec.date)}',
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.print_outlined),
                                  tooltip: 'Print Receipt Slip',
                                  onPressed: () {
                                    if (party == null) return;
                                    final license = ref.read(freemiumProvider);
                                    final watermark = ref
                                        .read(freemiumProvider.notifier)
                                        .getPdfWatermark();
                                    SlipPrinter.printSlip(
                                      context,
                                      onGeneratePdf: () =>
                                          SlipPrinter.generatePaymentReceiptPdf(
                                        receipt: rec,
                                        loan: loan,
                                        party: party,
                                        shopName: license.shopName,
                                        watermarkText: watermark,
                                        isThermal: true,
                                      ),
                                      documentName:
                                          'Receipt_${rec.receiptNumber}',
                                    );
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                      loading: () => const LinearProgressIndicator(),
                      error: (e, _) => Text('Error loading receipts: $e'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error loading loan details: $e')),
      ),
    );
  }

  Widget _buildSpecPill(
    BuildContext context,
    String label,
    String value, {
    IconData? icon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(
    BuildContext context,
    String title,
    String value, {
    Color? color,
    bool isBold = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color ?? colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
