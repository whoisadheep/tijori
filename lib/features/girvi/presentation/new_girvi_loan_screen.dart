import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tijori/app/theme/app_colors.dart';
import 'package:tijori/core/database/app_database.dart';
import 'package:tijori/core/licensing/freemium_service.dart';
import 'package:tijori/core/printing/slip_printer.dart';
import 'package:tijori/core/utils/girvi_calculator.dart';
import 'package:tijori/core/utils/photo_storage_helper.dart';
import 'package:tijori/features/daily_rates/presentation/daily_rates_providers.dart';
import 'package:tijori/features/parties/presentation/party_selector_field.dart';

class NewGirviLoanScreen extends ConsumerStatefulWidget {
  const NewGirviLoanScreen({super.key});

  @override
  ConsumerState<NewGirviLoanScreen> createState() => _NewGirviLoanScreenState();
}

class _NewGirviLoanScreenState extends ConsumerState<NewGirviLoanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

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

  String? _localPhotoPath;
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
    _scrollController.dispose();
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
    } else {
      _netWeightCtrl.text = '0.00';
      _estimatedValueCtrl.text = '0';
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
    final isCustomerMissing = _selectedParty == null;
    final isFormValid = _formKey.currentState?.validate() ?? false;

    if (isCustomerMissing || !isFormValid) {
      // Auto-scroll to top so user clearly sees what needs attention
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
        );
      }

      final errorMessages = <String>[];
      if (isCustomerMissing) errorMessages.add('Customer / Borrower');
      if (_grossWeightCtrl.text.trim().isEmpty) errorMessages.add('Gross Weight');
      if (_itemDescCtrl.text.trim().isEmpty) errorMessages.add('Item Description');
      if (_principalCtrl.text.trim().isEmpty) errorMessages.add('Principal Amount');

      final message = errorMessages.isNotEmpty
          ? 'Please complete required fields: ${errorMessages.join(', ')}'
          : 'Please complete all required fields (*)';

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(24, 0, 24, 80),
          action: SnackBarAction(
            label: 'DISMISS',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final gross = double.tryParse(_grossWeightCtrl.text.trim()) ?? 0.0;
      final purity = double.tryParse(_purityCtrl.text.trim()) ?? 91.6;
      final net = double.tryParse(_netWeightCtrl.text.trim()) ??
          GirviCalculator.calculateNetWeight(grossWeight: gross, purityPercent: purity);
      final rate = double.tryParse(_ratePerGramCtrl.text.trim()) ?? 7000.0;
      final estVal = double.tryParse(_estimatedValueCtrl.text.trim()) ??
          GirviCalculator.calculateEstimatedValue(netWeight: net, ratePerGram: rate);
      final principal = double.tryParse(_principalCtrl.text.trim()) ?? 0.0;
      final roi = double.tryParse(_roiCtrl.text.trim()) ?? 1.5;

      if (gross <= 0) {
        throw 'Gross weight must be greater than 0.';
      }
      if (purity <= 0 || purity > 100) {
        throw 'Touch (Purity) percentage must be between 0.1% and 100%.';
      }
      if (principal <= 0) {
        throw 'Principal loan amount must be greater than ₹0.';
      }
      if (roi < 0 || roi > 50) {
        throw 'Rate of interest must be between 0% and 50% per month.';
      }

      final db = ref.read(appDatabaseProvider);
      final createdLoan = await db.transaction(() async {
        final dao = db.girviLoansDao;
        final finalSlipNo = await dao.generateNextSlipNumber();

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
          localPhotoPath: _localPhotoPath != null
              ? drift.Value(_localPhotoPath)
              : const drift.Value.absent(),
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
        return await dao.getLoanById(newLoanId);
      });

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
          controller: _scrollController,
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
                            selectedParty: _selectedParty,
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
                          const SizedBox(height: 16),

                          // Collateral Ornament Photo Capture
                          _buildCollateralPhotoSection(context, colorScheme),
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
                                  isExpanded: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Interest Engine',
                                    isDense: true,
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: InterestType.monthWise,
                                      child: Text(
                                          'MonthWise (Calendar)'),
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
                                  isExpanded: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Disbursement Mode',
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
                        onPressed: _isSaving
                            ? null
                            : () {
                                if (context.canPop()) {
                                  context.pop();
                                } else {
                                  context.go('/girvi');
                                }
                              },
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

  Widget _buildCollateralPhotoSection(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    final hasPhoto = PhotoStorageHelper.photoExists(_localPhotoPath);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasPhoto
              ? AppColors.burntAmber
              : colorScheme.outlineVariant,
          width: hasPhoto ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.camera_alt_rounded,
                    size: 18,
                    color: hasPhoto ? AppColors.burntAmber : colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Pledged Ornament Photo',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              if (hasPhoto)
                TextButton.icon(
                  icon: const Icon(Icons.delete_outline_rounded, size: 16),
                  label: const Text('Remove Photo'),
                  style: TextButton.styleFrom(foregroundColor: colorScheme.error),
                  onPressed: () => setState(() => _localPhotoPath = null),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (hasPhoto)
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(_localPhotoPath!),
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Photo attached successfully',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.champagneDark,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Stored offline in secure local vault storage. This photo will be printed directly onto customer and shop pledge slips.',
                        style: TextStyle(
                          fontSize: 11,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: const Text('Change Photo'),
                        style: OutlinedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: _pickCollateralPhoto,
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: _pickCollateralPhoto,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                    style: BorderStyle.solid,
                  ),
                  color: colorScheme.surface,
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.add_a_photo_outlined,
                      size: 28,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Attach Collateral Ornament Photo',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Click to browse or capture image (JPG, PNG)',
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _pickCollateralPhoto() async {
    final path = await PhotoStorageHelper.pickAndSaveCollateralPhoto();
    if (path != null && mounted) {
      setState(() => _localPhotoPath = path);
    }
  }
}
