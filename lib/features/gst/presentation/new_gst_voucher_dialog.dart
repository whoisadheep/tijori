import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tijori/app/theme/app_colors.dart';
import 'package:tijori/core/database/app_database.dart';
import 'package:tijori/core/licensing/freemium_service.dart';
import 'package:tijori/core/printing/slip_printer.dart';
import 'package:tijori/core/utils/gst_calculator.dart';
import 'package:tijori/features/parties/presentation/parties_providers.dart';
import 'package:tijori/features/parties/presentation/quick_add_party_dialog.dart';

class NewGstVoucherDialog extends ConsumerStatefulWidget {
  final GstVoucherType initialType;

  const NewGstVoucherDialog({
    super.key,
    this.initialType = GstVoucherType.sale,
  });

  static Future<void> show(
    BuildContext context, {
    GstVoucherType initialType = GstVoucherType.sale,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => NewGstVoucherDialog(initialType: initialType),
    );
  }

  @override
  ConsumerState<NewGstVoucherDialog> createState() =>
      _NewGstVoucherDialogState();
}

class _NewGstVoucherDialogState extends ConsumerState<NewGstVoucherDialog> {
  final _formKey = GlobalKey<FormState>();

  late GstVoucherType _voucherType;
  PaymentTerm _paymentTerm = PaymentTerm.cash;
  Party? _selectedParty;
  String? _billNumber;

  DateTime _date = DateTime.now();

  final _descCtrl = TextEditingController();
  final _hsnCtrl = TextEditingController(text: '7113');
  final _taxableAmountCtrl = TextEditingController();
  final _taxSlabCtrl = TextEditingController(text: '3.0');
  final _cgstCtrl = TextEditingController(text: '0.00');
  final _sgstCtrl = TextEditingController(text: '0.00');
  final _totalAmountCtrl = TextEditingController(text: '0.00');

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _voucherType = widget.initialType;

    if (_voucherType == GstVoucherType.expense) {
      _hsnCtrl.text = '';
      _taxSlabCtrl.text = '0.0';
    } else if (_voucherType == GstVoucherType.purchase) {
      _hsnCtrl.text = '7108';
      _taxSlabCtrl.text = '3.0';
    }

    _loadNextBillNumber();
  }

  Future<void> _loadNextBillNumber() async {
    final dao = ref.read(gstVouchersDaoProvider);
    final nextBill = await dao.generateNextBillNumber(_voucherType);
    if (mounted) {
      setState(() => _billNumber = nextBill);
    }
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _hsnCtrl.dispose();
    _taxableAmountCtrl.dispose();
    _taxSlabCtrl.dispose();
    _cgstCtrl.dispose();
    _sgstCtrl.dispose();
    _totalAmountCtrl.dispose();
    super.dispose();
  }

  void _recalculateTaxes() {
    final taxable = double.tryParse(_taxableAmountCtrl.text.trim()) ?? 0.0;
    final slab = double.tryParse(_taxSlabCtrl.text.trim()) ?? 0.0;

    final breakdown = GstCalculator.computeTax(
      taxableAmount: taxable,
      taxSlabPercent: slab,
    );

    _cgstCtrl.text = breakdown.cgstAmount.toStringAsFixed(2);
    _sgstCtrl.text = breakdown.sgstAmount.toStringAsFixed(2);
    _totalAmountCtrl.text = breakdown.totalAmount.toStringAsFixed(2);
  }

  Future<void> _submitVoucher({bool andPrint = false}) async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedParty == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or add a Customer/Party.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final dao = ref.read(gstVouchersDaoProvider);
      final billNum = _billNumber ?? await dao.generateNextBillNumber(_voucherType);

      final taxable = double.parse(_taxableAmountCtrl.text.trim());
      final slab = double.parse(_taxSlabCtrl.text.trim());
      final cgst = double.parse(_cgstCtrl.text.trim());
      final sgst = double.parse(_sgstCtrl.text.trim());
      final total = double.parse(_totalAmountCtrl.text.trim());

      final companion = GstVouchersCompanion.insert(
        voucherType: _voucherType,
        paymentTerm: _paymentTerm,
        partyId: _selectedParty!.id,
        billNumber: billNum,
        date: _date,
        hsnCode: _hsnCtrl.text.trim().isNotEmpty
            ? drift.Value(_hsnCtrl.text.trim())
            : const drift.Value.absent(),
        description: _descCtrl.text.trim(),
        taxSlabPercent: slab,
        taxableAmount: taxable,
        cgstAmount: cgst,
        sgstAmount: sgst,
        totalAmount: total,
      );

      final rowId = await dao.insertVoucher(companion);
      final createdVoucher = GstVoucher(
        id: rowId,
        voucherType: _voucherType,
        paymentTerm: _paymentTerm,
        partyId: _selectedParty!.id,
        bookSeries: null,
        billNumber: billNum,
        date: _date,
        hsnCode: _hsnCtrl.text.trim().isNotEmpty ? _hsnCtrl.text.trim() : null,
        description: _descCtrl.text.trim(),
        taxSlabPercent: slab,
        taxableAmount: taxable,
        cgstAmount: cgst,
        sgstAmount: sgst,
        totalAmount: total,
      );

      if (mounted) {
        Navigator.of(context).pop();

        if (andPrint && mounted) {
          final license = ref.read(freemiumProvider);
          final watermark = ref.read(freemiumProvider.notifier).getPdfWatermark();

          await SlipPrinter.printSlip(
            context,
            documentName: 'gst_invoice_$billNum',
            onGeneratePdf: () => SlipPrinter.generateGstInvoicePdf(
              voucher: createdVoucher,
              party: _selectedParty!,
              shopName: license.shopName,
              watermarkText: watermark,
            ),
          );
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${_voucherType.name.toUpperCase()} #$billNum recorded successfully.',
              ),
              backgroundColor: AppColors.mochaPrimary,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save voucher: $e'),
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
    final partiesAsync = ref.watch(allPartiesProvider);
    final dateFmt = DateFormat('dd MMM yyyy');

    final isSale = _voucherType == GstVoucherType.sale;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSale
                                ? AppColors.champagneLight
                                : AppColors.burntAmberLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            isSale ? Icons.receipt_long_rounded : Icons.account_balance_wallet_rounded,
                            color: isSale ? AppColors.champagneDark : AppColors.burntAmber,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isSale ? 'New Jewellery Tax Invoice' : 'New Accounting Voucher',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _billNumber ?? 'Loading...',
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
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

                // 2. Voucher Type Selector
                DropdownButtonFormField<GstVoucherType>(
                  initialValue: _voucherType,
                  decoration: const InputDecoration(
                    labelText: 'Voucher Category *',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: GstVoucherType.sale,
                      child: Text('Sale (Jewellery / Bullion Outward Invoice)'),
                    ),
                    DropdownMenuItem(
                      value: GstVoucherType.expense,
                      child: Text('Operating Expense (Rent, Staff, Bills, Tea)'),
                    ),
                    DropdownMenuItem(
                      value: GstVoucherType.purchase,
                      child: Text('Purchase (Gold/Silver Inward Supply)'),
                    ),
                    DropdownMenuItem(
                      value: GstVoucherType.income,
                      child: Text('Income (Other Business Receipts)'),
                    ),
                    DropdownMenuItem(
                      value: GstVoucherType.saleReturn,
                      child: Text('Sale Return (Customer Credit Note)'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _voucherType = val;
                        if (_voucherType == GstVoucherType.expense) {
                          _taxSlabCtrl.text = '0.0';
                          _hsnCtrl.text = '';
                        } else if (_voucherType == GstVoucherType.sale) {
                          _taxSlabCtrl.text = '3.0';
                          _hsnCtrl.text = '7113';
                        }
                        _recalculateTaxes();
                        _loadNextBillNumber();
                      });
                    }
                  },
                ),
                const SizedBox(height: 14),

                // 3. Party Selector Row
                partiesAsync.when(
                  data: (parties) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<Party>(
                            initialValue: _selectedParty ??
                                (parties.isNotEmpty ? parties.first : null),
                            decoration: InputDecoration(
                              labelText: isSale ? 'Customer *' : 'Party / Payee *',
                              prefixIcon: const Icon(Icons.person_outline_rounded),
                            ),
                            items: parties.map((p) {
                              return DropdownMenuItem<Party>(
                                value: p,
                                child: Text('${p.name} (${p.groupType.name.toUpperCase()})'),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() => _selectedParty = val),
                            validator: (val) =>
                                val == null ? 'Please select a Party' : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filledTonal(
                          tooltip: 'Add New Party',
                          icon: const Icon(Icons.person_add_rounded),
                          onPressed: () => QuickAddPartyDialog.show(context),
                        ),
                      ],
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('Error loading parties: $e'),
                ),
                const SizedBox(height: 14),

                // 4. Date & Payment Term Row
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
                            labelText: 'Invoice Date',
                            prefixIcon: Icon(Icons.calendar_today_rounded, size: 18),
                          ),
                          child: Text(dateFmt.format(_date)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<PaymentTerm>(
                        initialValue: _paymentTerm,
                        decoration: const InputDecoration(
                          labelText: 'Payment Term',
                          prefixIcon: Icon(Icons.payment_rounded, size: 18),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: PaymentTerm.cash,
                            child: Text('Cash (Immediate)'),
                          ),
                          DropdownMenuItem(
                            value: PaymentTerm.credit,
                            child: Text('Credit (Udhar Ledger)'),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _paymentTerm = val);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // 5. Item Description & HSN Code Row
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _descCtrl,
                        decoration: InputDecoration(
                          labelText: isSale ? 'Jewellery Item Description *' : 'Description *',
                          hintText: isSale ? 'e.g. 22K Hallmark Gold Mangalsutra (12.4g)' : 'e.g. Shop monthly electricity bill',
                          prefixIcon: const Icon(Icons.description_outlined, size: 18),
                        ),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Required description' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _hsnCtrl,
                        decoration: const InputDecoration(
                          labelText: 'HSN / SAC Code',
                          hintText: '7113 / 9988',
                          prefixIcon: Icon(Icons.tag_rounded, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // 6. Taxable Amount & Tax Slab Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _taxableAmountCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Taxable Amount *',
                          prefixText: '₹ ',
                        ),
                        validator: (v) {
                          final val = double.tryParse(v ?? '');
                          if (val == null || val <= 0) return 'Invalid amount';
                          return null;
                        },
                        onChanged: (_) => _recalculateTaxes(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _taxSlabCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'GST Slab %',
                          suffixText: '%',
                        ),
                        validator: (v) {
                          final val = double.tryParse(v ?? '');
                          if (val == null || val < 0) return 'Invalid %';
                          return null;
                        },
                        onChanged: (_) => _recalculateTaxes(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Quick Tax Slab Chips
                Wrap(
                  spacing: 8,
                  children: [
                    ActionChip(
                      label: const Text('3.0% (Gold/Silver)'),
                      onPressed: () {
                        _taxSlabCtrl.text = '3.0';
                        _recalculateTaxes();
                      },
                    ),
                    ActionChip(
                      label: const Text('5.0% (Making)'),
                      onPressed: () {
                        _taxSlabCtrl.text = '5.0';
                        _recalculateTaxes();
                      },
                    ),
                    ActionChip(
                      label: const Text('18.0% (Services)'),
                      onPressed: () {
                        _taxSlabCtrl.text = '18.0';
                        _recalculateTaxes();
                      },
                    ),
                    ActionChip(
                      label: const Text('0.0% (Exempt)'),
                      onPressed: () {
                        _taxSlabCtrl.text = '0.0';
                        _recalculateTaxes();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 7. Live Tax Breakdown Summary Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('CGST (Central Tax):', style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13)),
                          Text('₹ ${_cgstCtrl.text}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('SGST (State Tax):', style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13)),
                          Text('₹ ${_sgstCtrl.text}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'GRAND INVOICE TOTAL:',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            '₹ ${_totalAmountCtrl.text}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              color: AppColors.burntAmber,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 8. Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 10),
                    if (isSale) ...[
                      OutlinedButton.icon(
                        icon: const Icon(Icons.print_rounded, size: 18),
                        label: const Text('Save & Print Invoice'),
                        onPressed: _isSaving ? null : () => _submitVoucher(andPrint: true),
                      ),
                      const SizedBox(width: 10),
                    ],
                    FilledButton.icon(
                      icon: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.check_circle_rounded),
                      label: Text(_isSaving ? 'Recording...' : 'Save Voucher'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.mochaPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      onPressed: _isSaving ? null : () => _submitVoucher(andPrint: false),
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
