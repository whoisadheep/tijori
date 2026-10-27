import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tijori/core/database/app_database.dart';

import 'daily_rates_providers.dart';

/// Modal dialog for recording or updating daily precious metal rates.
class UpdateRatesDialog extends ConsumerStatefulWidget {
  const UpdateRatesDialog({super.key});

  /// Helper to display this dialog over any [BuildContext].
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => const UpdateRatesDialog(),
    );
  }

  @override
  ConsumerState<UpdateRatesDialog> createState() => _UpdateRatesDialogState();
}

class _UpdateRatesDialogState extends ConsumerState<UpdateRatesDialog> {
  final _formKey = GlobalKey<FormState>();

  final _gold24kCtrl = TextEditingController();
  final _gold22kCtrl = TextEditingController();
  final _gold18kCtrl = TextEditingController();
  final _gold16kCtrl = TextEditingController();
  final _silverCtrl = TextEditingController();

  bool _autoCalculateFractions = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _populateExistingRate();
  }

  void _populateExistingRate() {
    final existing = ref.read(latestDailyRateProvider).valueOrNull;
    if (existing != null) {
      if (existing.gold24k != null) {
        _gold24kCtrl.text = existing.gold24k!.toStringAsFixed(0);
      }
      if (existing.gold22k != null) {
        _gold22kCtrl.text = existing.gold22k!.toStringAsFixed(0);
      }
      if (existing.gold18k != null) {
        _gold18kCtrl.text = existing.gold18k!.toStringAsFixed(0);
      }
      if (existing.gold16k != null) {
        _gold16kCtrl.text = existing.gold16k!.toStringAsFixed(0);
      }
      if (existing.silverRate != null) {
        _silverCtrl.text = existing.silverRate!.toStringAsFixed(1);
      }
    }
  }

  @override
  void dispose() {
    _gold24kCtrl.dispose();
    _gold22kCtrl.dispose();
    _gold18kCtrl.dispose();
    _gold16kCtrl.dispose();
    _silverCtrl.dispose();
    super.dispose();
  }

  void _on24kChanged(String value) {
    if (!_autoCalculateFractions) return;
    final r24k = double.tryParse(value);
    if (r24k == null || r24k <= 0) return;

    setState(() {
      _gold22kCtrl.text = (r24k * (22.0 / 24.0)).round().toString();
      _gold18kCtrl.text = (r24k * (18.0 / 24.0)).round().toString();
      _gold16kCtrl.text = (r24k * (16.0 / 24.0)).round().toString();
    });
  }

  Future<void> _saveRates() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final dao = ref.read(dailyRatesDaoProvider);
    final now = DateTime.now();

    final g24 = double.tryParse(_gold24kCtrl.text);
    final g22 = double.tryParse(_gold22kCtrl.text);
    final g18 = double.tryParse(_gold18kCtrl.text);
    final g16 = double.tryParse(_gold16kCtrl.text);
    final silver = double.tryParse(_silverCtrl.text);

    try {
      final todayRate = await dao.getRateForDate(now);
      if (todayRate != null) {
        // Update existing record for today
        await dao.updateRate(
          todayRate.copyWith(
            gold24k: drift.Value(g24),
            gold22k: drift.Value(g22),
            gold18k: drift.Value(g18),
            gold16k: drift.Value(g16),
            silverRate: drift.Value(silver),
          ),
        );
      } else {
        // Insert new entry
        await dao.insertRate(
          DailyRatesCompanion.insert(
            date: now,
            gold24k: drift.Value(g24),
            gold22k: drift.Value(g22),
            gold18k: drift.Value(g18),
            gold16k: drift.Value(g16),
            silverRate: drift.Value(silver),
          ),
        );
      }

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Today\'s metal rates saved successfully.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving rates: $e'),
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

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.price_change_rounded,
                          color: colorScheme.onPrimaryContainer,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today\'s Metal Rates',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Standard rates per gram used across all calculations',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  // 24K Gold
                  TextFormField(
                    controller: _gold24kCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Gold 24K (Pure / 999) Rate / gram',
                      prefixText: '₹ ',
                      suffixText: '/ g',
                      hintText: 'e.g. 7450',
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      final val = double.tryParse(v);
                      if (val == null || val <= 0) return 'Enter valid rate';
                      return null;
                    },
                    onChanged: _on24kChanged,
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Checkbox(
                        value: _autoCalculateFractions,
                        onChanged: (v) {
                          setState(() => _autoCalculateFractions = v ?? true);
                        },
                      ),
                      Expanded(
                        child: Text(
                          'Auto-derive 22K, 18K & 16K from 24K rate',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // 22K Gold & 18K Gold Row
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _gold22kCtrl,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Gold 22K (916) / g',
                            prefixText: '₹ ',
                            suffixText: '/ g',
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Required';
                            final val = double.tryParse(v);
                            if (val == null || val <= 0) return 'Invalid';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _gold18kCtrl,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Gold 18K (750) / g',
                            prefixText: '₹ ',
                            suffixText: '/ g',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 16K Gold & Silver Row
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _gold16kCtrl,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Gold 16K (667) / g',
                            prefixText: '₹ ',
                            suffixText: '/ g',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _silverCtrl,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Silver Rate / gram',
                            prefixText: '₹ ',
                            suffixText: '/ g',
                            hintText: 'e.g. 88.5',
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Required';
                            final val = double.tryParse(v);
                            if (val == null || val <= 0) return 'Invalid';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
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
                            : const Icon(Icons.check_rounded, size: 18),
                        label: Text(_isSaving ? 'Saving...' : 'Save Today\'s Rates'),
                        onPressed: _isSaving ? null : _saveRates,
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
