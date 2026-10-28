import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tijori/app/theme/app_colors.dart';
import 'package:tijori/core/database/app_database.dart';
import 'package:tijori/features/daily_rates/presentation/daily_rates_providers.dart';
import 'package:tijori/features/karigar/presentation/karigar_providers.dart';
import 'package:tijori/features/parties/presentation/quick_add_party_dialog.dart';

class KarigarVoucherDialog extends ConsumerStatefulWidget {
  final Party? preselectedKarigar;
  final KarigarTxnType initialType;

  const KarigarVoucherDialog({
    super.key,
    this.preselectedKarigar,
    this.initialType = KarigarTxnType.issue,
  });

  static Future<void> show(
    BuildContext context, {
    Party? preselectedKarigar,
    KarigarTxnType initialType = KarigarTxnType.issue,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => KarigarVoucherDialog(
        preselectedKarigar: preselectedKarigar,
        initialType: initialType,
      ),
    );
  }

  @override
  ConsumerState<KarigarVoucherDialog> createState() =>
      _KarigarVoucherDialogState();
}

class _KarigarVoucherDialogState extends ConsumerState<KarigarVoucherDialog> {
  final _formKey = GlobalKey<FormState>();

  late KarigarTxnType _txnType;
  Party? _selectedKarigar;
  String? _voucherNumber;

  DateTime _date = DateTime.now();

  final _itemDescCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController(text: '1');
  final _grossWeightCtrl = TextEditingController();
  final _purityCtrl = TextEditingController(text: '99.5');
  final _netPureWeightCtrl = TextEditingController();
  final _estimatedValueCtrl = TextEditingController();
  final _remarksCtrl = TextEditingController();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _txnType = widget.initialType;
    _selectedKarigar = widget.preselectedKarigar;

    if (_txnType == KarigarTxnType.receive) {
      _purityCtrl.text = '91.6';
    }

    _loadNextVoucherNumber();
  }

  Future<void> _loadNextVoucherNumber() async {
    final dao = ref.read(karigarTransactionsDaoProvider);
    final nextVoucher = await dao.generateNextVoucherNumber();
    if (mounted) {
      setState(() => _voucherNumber = nextVoucher);
    }
  }

  @override
  void dispose() {
    _itemDescCtrl.dispose();
    _qtyCtrl.dispose();
    _grossWeightCtrl.dispose();
    _purityCtrl.dispose();
    _netPureWeightCtrl.dispose();
    _estimatedValueCtrl.dispose();
    _remarksCtrl.dispose();
    super.dispose();
  }

  void _recalculatePureWeight() {
    final gross = double.tryParse(_grossWeightCtrl.text.trim()) ?? 0.0;
    final purity = double.tryParse(_purityCtrl.text.trim()) ?? 0.0;
    final pure = gross * (purity / 100.0);
    _netPureWeightCtrl.text = pure > 0 ? pure.toStringAsFixed(3) : '';

    // Estimate value from today's 24K rate if available
    final latestRate = ref.read(latestDailyRateProvider).valueOrNull;
    if (latestRate?.gold24k != null && pure > 0) {
      final estValue = pure * latestRate!.gold24k!;
      _estimatedValueCtrl.text = estValue.toStringAsFixed(0);
    }
  }

  Future<void> _submitVoucher() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedKarigar == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a Karigar (Goldsmith).')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final dao = ref.read(karigarTransactionsDaoProvider);
      final voucherNum = _voucherNumber ?? await dao.generateNextVoucherNumber();

      final gross = double.parse(_grossWeightCtrl.text.trim());
      final purity = double.parse(_purityCtrl.text.trim());
      final netPure = gross * (purity / 100.0);
      final qty = int.tryParse(_qtyCtrl.text.trim()) ?? 1;
      final estValue = double.tryParse(_estimatedValueCtrl.text.trim());

      final companion = KarigarTransactionsCompanion.insert(
        voucherNumber: voucherNum,
        karigarId: _selectedKarigar!.id,
        date: _date,
        type: _txnType,
        itemDescription: _itemDescCtrl.text.trim(),
        quantity: drift.Value(qty),
        grossWeight: gross,
        purityPercent: purity,
        netWeight: netPure,
        estimatedValue: estValue != null ? drift.Value(estValue) : const drift.Value.absent(),
        remarks: _remarksCtrl.text.trim().isNotEmpty
            ? drift.Value(_remarksCtrl.text.trim())
            : const drift.Value.absent(),
      );

      await dao.insertTransaction(companion);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_txnType == KarigarTxnType.issue ? "Metal Issue" : "Ornament Receive"} voucher $voucherNum recorded for ${_selectedKarigar!.name}.',
            ),
            backgroundColor: AppColors.mochaPrimary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving voucher: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final karigarsAsync = ref.watch(allKarigarsProvider);
    final dateFmt = DateFormat('dd MMM yyyy');

    final isIssue = _txnType == KarigarTxnType.issue;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isIssue
                                ? AppColors.burntAmberLight
                                : AppColors.champagneLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            isIssue
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                            color: isIssue
                                ? AppColors.burntAmber
                                : AppColors.champagneDark,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isIssue ? 'Issue Metal to Artisan' : 'Receive Finished Work',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _voucherNumber ?? 'Loading...',
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Voucher Type Selector
                SegmentedButton<KarigarTxnType>(
                  segments: const [
                    ButtonSegment(
                      value: KarigarTxnType.issue,
                      label: Text('Issue Raw Metal'),
                      icon: Icon(Icons.outbox_rounded),
                    ),
                    ButtonSegment(
                      value: KarigarTxnType.receive,
                      label: Text('Receive Ornament'),
                      icon: Icon(Icons.move_to_inbox_rounded),
                    ),
                  ],
                  selected: {_txnType},
                  onSelectionChanged: (set) {
                    setState(() {
                      _txnType = set.first;
                      if (_txnType == KarigarTxnType.issue && _purityCtrl.text == '91.6') {
                        _purityCtrl.text = '99.5';
                      } else if (_txnType == KarigarTxnType.receive && _purityCtrl.text == '99.5') {
                        _purityCtrl.text = '91.6';
                      }
                      _recalculatePureWeight();
                    });
                  },
                ),
                const SizedBox(height: 18),

                // Karigar Selection Row
                karigarsAsync.when(
                  data: (karigars) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<Party>(
                            initialValue: _selectedKarigar ??
                                (karigars.isNotEmpty ? karigars.first : null),
                            decoration: const InputDecoration(
                              labelText: 'Goldsmith (Karigar) *',
                              prefixIcon: Icon(Icons.person_outline_rounded),
                            ),
                            items: karigars.map((k) {
                              return DropdownMenuItem<Party>(
                                value: k,
                                child: Text('${k.name} (${k.mobile ?? "No phone"})'),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() => _selectedKarigar = val);
                            },
                            validator: (val) =>
                                val == null ? 'Please select a Karigar' : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filledTonal(
                          tooltip: 'Add New Karigar',
                          icon: const Icon(Icons.person_add_rounded),
                          onPressed: () async {
                            await QuickAddPartyDialog.show(
                              context,
                              initialGroup: PartyGroupType.karigar,
                            );
                          },
                        ),
                      ],
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('Error loading artisans: $e'),
                ),
                const SizedBox(height: 14),

                // Date Picker Row
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _date,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2035),
                          );
                          if (picked != null) {
                            setState(() => _date = picked);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Voucher Date',
                            prefixIcon: Icon(Icons.calendar_today_rounded, size: 18),
                          ),
                          child: Text(dateFmt.format(_date)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _qtyCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Quantity (Pcs)',
                          prefixIcon: Icon(Icons.format_list_numbered_rounded, size: 18),
                        ),
                        validator: (v) {
                          if (v == null || int.tryParse(v) == null || int.parse(v) <= 0) {
                            return 'Min 1';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Item Description
                TextFormField(
                  controller: _itemDescCtrl,
                  decoration: InputDecoration(
                    labelText: isIssue ? 'Issued Metal Item *' : 'Received Ornament Item *',
                    hintText: isIssue
                        ? 'e.g. 24K Pure Gold Bar / Scrap 22K bangles'
                        : 'e.g. 1 Pair 22K Hallmark Earrings',
                    prefixIcon: const Icon(Icons.diamond_outlined, size: 18),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required description' : null,
                ),
                const SizedBox(height: 14),

                // Gross Weight & Purity Row
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _grossWeightCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Gross Wt *',
                          suffixText: 'grams',
                        ),
                        validator: (v) {
                          final val = double.tryParse(v ?? '');
                          if (val == null || val <= 0) return 'Invalid';
                          return null;
                        },
                        onChanged: (_) => _recalculatePureWeight(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _purityCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Touch % *',
                          suffixText: '%',
                        ),
                        validator: (v) {
                          final val = double.tryParse(v ?? '');
                          if (val == null || val <= 0 || val > 100) return '0-100%';
                          return null;
                        },
                        onChanged: (_) => _recalculatePureWeight(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _netPureWeightCtrl,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Pure Gold (Fine)',
                          suffixText: 'grams',
                          filled: true,
                          fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Estimated Value & Remarks Row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _estimatedValueCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Est. Valuation',
                          prefixText: '₹ ',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _remarksCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Remarks / Job Card #',
                          prefixIcon: Icon(Icons.notes_rounded, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      icon: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Icon(isIssue ? Icons.outbox_rounded : Icons.check_circle_rounded),
                      label: Text(
                        _isSaving
                            ? 'Saving...'
                            : (isIssue ? 'Issue Metal' : 'Receive Ornament'),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: isIssue ? AppColors.burntAmber : AppColors.mochaPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      onPressed: _isSaving ? null : _submitVoucher,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
