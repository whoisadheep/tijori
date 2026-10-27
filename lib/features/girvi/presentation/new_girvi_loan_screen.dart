import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tijori/core/database/app_database.dart';
import 'package:tijori/core/licensing/freemium_service.dart';
import 'package:tijori/core/licensing/upgrade_paywall_dialog.dart';
import 'package:tijori/core/printing/slip_printer.dart';
import 'package:tijori/core/utils/girvi_calculator.dart';
import 'package:tijori/features/daily_rates/presentation/daily_rates_providers.dart';
import 'package:tijori/features/parties/presentation/party_selector_field.dart';

class NewGirviLoanScreen extends ConsumerStatefulWidget {
  const NewGirviLoanScreen({super.key});

  @override
  ConsumerState<NewGirviLoanScreen> createState() => _NewGirviLoanScreenState();
}

class _NewGirviLoanScreenState extends ConsumerState<NewGirviLoanScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _previewSlipNumber;
  Party? _selectedParty;

  DateTime _transactionDate = DateTime.now();
  DateTime _interestStartDate = DateTime.now();

  MetalType _metalType = MetalType.gold;
  InterestType _interestType = InterestType.monthWise;
  PaymentMode _paymentMode = PaymentMode.cash;

  final _grossWeightCtrl = TextEditingController();
  final _purityCtrl = TextEditingController(text: '91.6');
  final _netWeightCtrl = TextEditingController();
  final _ratePerGramCtrl = TextEditingController();
  final _estimatedValueCtrl = TextEditingController();
  final _principalCtrl = TextEditingController();
  final _roiCtrl = TextEditingController(text: '1.5');
  final _itemDescCtrl = TextEditingController();
  final _rackLocationCtrl = TextEditingController(text: 'Vault 1 / Box A');
  final _remarksCtrl = TextEditingController();
  final _guarantorNameCtrl = TextEditingController();
  final _guarantorPhoneCtrl = TextEditingController();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadInitialSlipNumberAndRates();
  }

  Future<void> _loadInitialSlipNumberAndRates() async {
    final dao = ref.read(girviLoansDaoProvider);
    final slipNo = await dao.generateNextSlipNumber();

    final latestRate = ref.read(latestDailyRateProvider).valueOrNull;
    double defaultRate = 7000.0;
    if (latestRate != null) {
      if (_metalType == MetalType.gold) {
        defaultRate = latestRate.gold22k ?? latestRate.gold24k ?? 7000.0;
      } else {
        defaultRate = latestRate.silverRate ?? 85.0;
      }
    }

    if (mounted) {
      setState(() {
        _previewSlipNumber = slipNo;
        _ratePerGramCtrl.text = defaultRate.toStringAsFixed(0);
      });
    }
  }

  @override
  void dispose() {
    _grossWeightCtrl.dispose();
    _purityCtrl.dispose();
    _netWeightCtrl.dispose();
    _ratePerGramCtrl.dispose();
    _estimatedValueCtrl.dispose();
    _principalCtrl.dispose();
    _roiCtrl.dispose();
    _itemDescCtrl.dispose();
    _rackLocationCtrl.dispose();
    _remarksCtrl.dispose();
    _guarantorNameCtrl.dispose();
    _guarantorPhoneCtrl.dispose();
    super.dispose();
  }

  void _recalculateWeightsAndValuation() {
    final gross = double.tryParse(_grossWeightCtrl.text) ?? 0.0;
    final purity = double.tryParse(_purityCtrl.text) ?? 0.0;
    final rate = double.tryParse(_ratePerGramCtrl.text) ?? 0.0;

    if (gross > 0 && purity >= 0 && purity <= 100) {
      final net = GirviCalculator.calculateNetWeight(
        grossWeight: gross,
        purityPercent: purity,
      );
      final val = GirviCalculator.calculateEstimatedValue(
        netWeight: net,
        ratePerGram: rate,
      );

      _netWeightCtrl.text = net.toStringAsFixed(2);
      _estimatedValueCtrl.text = val.toStringAsFixed(0);

      // Auto-suggest principal (75% loan-to-value default) if principal is empty
      if (_principalCtrl.text.isEmpty && val > 0) {
        final suggestedPrincipal = (val * 0.75).round();
        _principalCtrl.text = suggestedPrincipal.toString();
      }
    }
    setState(() {});
  }

  void _onMetalChanged(MetalType metal) {
    setState(() {
      _metalType = metal;
      final latestRate = ref.read(latestDailyRateProvider).valueOrNull;
      if (metal == MetalType.gold) {
        _purityCtrl.text = '91.6';
        _ratePerGramCtrl.text =
            (latestRate?.gold22k ?? latestRate?.gold24k ?? 7000.0)
                .toStringAsFixed(0);
      } else {
        _purityCtrl.text = '80.0';
        _ratePerGramCtrl.text =
            (latestRate?.silverRate ?? 85.0).toStringAsFixed(1);
      }
    });
    _recalculateWeightsAndValuation();
  }

  Future<void> _submitLoan() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedParty == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or add a customer first.')),
      );
      return;
    }

    // 1. Freemium Verification: Max 25 Active Loans in Free Tier
    final hasReachedLimit =
        await ref.read(freemiumProvider.notifier).hasReachedFreeLoanLimit();
    if (hasReachedLimit) {
      if (mounted) {
        await UpgradePaywallDialog.show(
          context,
          feature: GatedFeature.girviLoans,
        );
      }
      return;
    }

    setState(() => _isSaving = true);

    try {
      final dao = ref.read(girviLoansDaoProvider);
      final finalSlipNo = await dao.generateNextSlipNumber();

      final gross = double.parse(_grossWeightCtrl.text);
      final purity = double.parse(_purityCtrl.text);
      final net = double.parse(_netWeightCtrl.text);
      final estVal = double.parse(_estimatedValueCtrl.text);
      final principal = double.parse(_principalCtrl.text);
      final roi = double.parse(_roiCtrl.text);

      final companion = GirviLoansCompanion.insert(
        slipNumber: finalSlipNo,
        partyId: _selectedParty!.id,
        transactionDate: _transactionDate,
        interestStartDate: _interestStartDate,
        roi: roi,
        interestType: _interestType,
        metalType: _metalType,
        grossWeight: gross,
        purityPercent: purity,
        netWeight: net,
        estimatedValue: estVal,
        principalAmount: principal,
        paymentMode: _paymentMode,
        itemDescription: _itemDescCtrl.text.trim(),
        rackLocation: _rackLocationCtrl.text.trim().isNotEmpty
            ? drift.Value(_rackLocationCtrl.text.trim())
            : const drift.Value.absent(),
        remarks: _remarksCtrl.text.trim().isNotEmpty
            ? drift.Value(_remarksCtrl.text.trim())
            : const drift.Value.absent(),
        guarantorName: _guarantorNameCtrl.text.trim().isNotEmpty
            ? drift.Value(_guarantorNameCtrl.text.trim())
            : const drift.Value.absent(),
        guarantorPhone: _guarantorPhoneCtrl.text.trim().isNotEmpty
            ? drift.Value(_guarantorPhoneCtrl.text.trim())
            : const drift.Value.absent(),
      );

      final newLoanId = await dao.insertLoan(companion);
      final createdLoan = await dao.getLoanById(newLoanId);

      if (mounted && createdLoan != null) {
        _showSuccessAndPrintDialog(createdLoan);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save Girvi loan: $e'),
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

  void _showSuccessAndPrintDialog(GirviLoan loan) {
    final license = ref.read(freemiumProvider);
    final watermark = ref.read(freemiumProvider.notifier).getPdfWatermark();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: const Icon(
          Icons.check_circle_rounded,
          color: Colors.green,
          size: 48,
        ),
        title: const Text('Pledge Slip Generated!'),
        content: Text(
          'Slip #${loan.slipNumber} for ${_selectedParty!.name} has been recorded in the offline vault database.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go('/girvi');
            },
            child: const Text('View All Loans'),
          ),
          FilledButton.icon(
            icon: const Icon(Icons.print_rounded),
            label: const Text('Print Receipt Slip'),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await SlipPrinter.printSlip(
                context,
                onGeneratePdf: () => SlipPrinter.generateGirviSlipPdf(
                  loan: loan,
                  party: _selectedParty!,
                  shopName: license.shopName,
                  watermarkText: watermark,
                  isThermal: true,
                ),
                documentName: 'Slip_${loan.slipNumber}',
              );
              if (mounted) {
                context.go('/girvi');
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateFmt = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Girvi (Pawn) Pledge'),
        actions: [
          if (_previewSlipNumber != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Slip: $_previewSlipNumber',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 840),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Borrower Section
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
                          Text(
                            '1. Customer / Borrower Information',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          PartySelectorField(
                            selectedPartyId: _selectedParty?.id,
                            onPartySelected: (p) {
                              setState(() => _selectedParty = p);
                            },
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: _transactionDate,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 365)),
                                    );
                                    if (picked != null) {
                                      setState(() {
                                        _transactionDate = picked;
                                        _interestStartDate = picked;
                                      });
                                    }
                                  },
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      labelText: 'Transaction Date',
                                      prefixIcon:
                                          Icon(Icons.calendar_today_outlined),
                                      isDense: true,
                                    ),
                                    child:
                                        Text(dateFmt.format(_transactionDate)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: _interestStartDate,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 365)),
                                    );
                                    if (picked != null) {
                                      setState(() => _interestStartDate = picked);
                                    }
                                  },
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      labelText: 'Interest Start Date',
                                      prefixIcon:
                                          Icon(Icons.event_available_outlined),
                                      isDense: true,
                                    ),
                                    child: Text(
                                        dateFmt.format(_interestStartDate)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. Metal & Purity Engine Section
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
                              Text(
                                '2. Pledged Metal & Valuation',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SegmentedButton<MetalType>(
                                segments: const [
                                  ButtonSegment(
                                    value: MetalType.gold,
                                    label: Text('Gold'),
                                    icon: Icon(Icons.circle,
                                        color: Colors.amber, size: 14),
                                  ),
                                  ButtonSegment(
                                    value: MetalType.silver,
                                    label: Text('Silver'),
                                    icon: Icon(Icons.circle,
                                        color: Colors.blueGrey, size: 14),
                                  ),
                                ],
                                selected: {_metalType},
                                onSelectionChanged: (v) =>
                                    _onMetalChanged(v.first),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: _grossWeightCtrl,
                                  keyboardType: const TextInputType
                                      .numberWithOptions(decimal: true),
                                  decoration: const InputDecoration(
                                    labelText: 'Gross Weight *',
                                    suffixText: 'grams',
                                    hintText: 'e.g. 15.50',
                                  ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Required';
                                    }
                                    final val = double.tryParse(v);
                                    if (val == null || val <= 0) {
                                      return 'Invalid';
                                    }
                                    return null;
                                  },
                                  onChanged: (_) =>
                                      _recalculateWeightsAndValuation(),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _purityCtrl,
                                  keyboardType: const TextInputType
                                      .numberWithOptions(decimal: true),
                                  decoration: const InputDecoration(
                                    labelText: 'Purity %',
                                    suffixText: '%',
                                    hintText: '91.6',
                                  ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Required';
                                    }
                                    final val = double.tryParse(v);
                                    if (val == null ||
                                        val < 0 ||
                                        val > 100) {
                                      return '0-100%';
                                    }
                                    return null;
                                  },
                                  onChanged: (_) =>
                                      _recalculateWeightsAndValuation(),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: _netWeightCtrl,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: 'Net Weight (Computed)',
                                    suffixText: 'grams',
                                    filled: true,
                                    fillColor: colorScheme
                                        .surfaceContainerHighest
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _ratePerGramCtrl,
                                  keyboardType: const TextInputType
                                      .numberWithOptions(decimal: true),
                                  decoration: const InputDecoration(
                                    labelText: 'Today\'s Rate / g',
                                    prefixText: '₹ ',
                                  ),
                                  onChanged: (_) =>
                                      _recalculateWeightsAndValuation(),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _estimatedValueCtrl,
                                  keyboardType: const TextInputType
                                      .numberWithOptions(decimal: true),
                                  decoration: InputDecoration(
                                    labelText: 'Estimated Valuation',
                                    prefixText: '₹ ',
                                    filled: true,
                                    fillColor: colorScheme
                                        .surfaceContainerHighest
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          TextFormField(
                            controller: _itemDescCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Item Description *',
                              hintText:
                                  'e.g. 1 Gold Chain (22K Hallmark), with pendant',
                            ),
                            validator: (v) =>
                                v == null || v.trim().isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _rackLocationCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'Vault / Rack Location',
                                    prefixIcon: Icon(Icons.inventory_2_outlined),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _remarksCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'Remarks / Identification marks',
                                    prefixIcon: Icon(Icons.notes_outlined),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. Financial Loan Terms
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
                          Text(
                            '3. Loan Amount & Interest Terms',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: _principalCtrl,
                                  keyboardType: const TextInputType
                                      .numberWithOptions(decimal: true),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: const InputDecoration(
                                    labelText: 'Principal Loan Amount *',
                                    prefixText: '₹ ',
                                    hintText: 'Amount sanctioned',
                                  ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Required';
                                    }
                                    final val = double.tryParse(v);
                                    if (val == null || val <= 0) {
                                      return 'Invalid';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _roiCtrl,
                                  keyboardType: const TextInputType
                                      .numberWithOptions(decimal: true),
                                  decoration: const InputDecoration(
                                    labelText: 'ROI % / Month *',
                                    suffixText: '%',
                                    hintText: '1.5',
                                  ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Required';
                                    }
                                    final val = double.tryParse(v);
                                    if (val == null || val <= 0) {
                                      return 'Invalid';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<InterestType>(
                                  initialValue: _interestType,
                                  decoration: const InputDecoration(
                                    labelText: 'Interest Engine',
                                    isDense: true,
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: InterestType.monthWise,
                                      child: Text(
                                          'MonthWise (Standard Calendar)'),
                                    ),
                                    DropdownMenuItem(
                                      value: InterestType.dayWise,
                                      child: Text('DayWise (30-day base)'),
                                    ),
                                  ],
                                  onChanged: (v) {
                                    if (v != null) {
                                      setState(() => _interestType = v);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonFormField<PaymentMode>(
                                  initialValue: _paymentMode,
                                  decoration: const InputDecoration(
                                    labelText: 'Disbursement Payment Mode',
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
                                      setState(() => _paymentMode = v);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Guarantor Info
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _guarantorNameCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'Guarantor Name (Optional)',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _guarantorPhoneCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'Guarantor Phone',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Submit Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed:
                            _isSaving ? null : () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 16),
                      FilledButton.icon(
                        icon: _isSaving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.assignment_turned_in_rounded),
                        label: Text(_isSaving
                            ? 'Sanctioning...'
                            : 'Sanction Loan & Issue Slip'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 16,
                          ),
                        ),
                        onPressed: _isSaving ? null : _submitLoan,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
