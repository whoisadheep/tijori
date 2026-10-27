import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tijori/core/database/app_database.dart';

/// Modal dialog for quickly registering a new customer, karigar, or supplier.
class QuickAddPartyDialog extends ConsumerStatefulWidget {
  final PartyGroupType initialGroup;

  const QuickAddPartyDialog({
    super.key,
    this.initialGroup = PartyGroupType.customer,
  });

  /// Displays the dialog and returns the newly created [Party] if saved.
  static Future<Party?> show(
    BuildContext context, {
    PartyGroupType initialGroup = PartyGroupType.customer,
  }) {
    return showDialog<Party?>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => QuickAddPartyDialog(initialGroup: initialGroup),
    );
  }

  @override
  ConsumerState<QuickAddPartyDialog> createState() =>
      _QuickAddPartyDialogState();
}

class _QuickAddPartyDialogState extends ConsumerState<QuickAddPartyDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _stateCtrl = TextEditingController(text: 'Maharashtra');
  final _kycNumberCtrl = TextEditingController();

  late PartyGroupType _selectedGroup;
  String _selectedKycType = 'Aadhaar';
  bool _isSaving = false;

  final List<String> _kycDocTypes = const [
    'Aadhaar',
    'PAN Card',
    'Voter ID',
    'Driving License',
    'Passport',
  ];

  @override
  void initState() {
    super.initState();
    _selectedGroup = widget.initialGroup;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _mobileCtrl.dispose();
    _addressCtrl.dispose();
    _stateCtrl.dispose();
    _kycNumberCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final dao = ref.read(partiesDaoProvider);

    try {
      final partyCompanion = PartiesCompanion.insert(
        name: _nameCtrl.text.trim(),
        groupType: _selectedGroup,
        mobile: _mobileCtrl.text.trim().isNotEmpty
            ? drift.Value(_mobileCtrl.text.trim())
            : const drift.Value.absent(),
        address: _addressCtrl.text.trim().isNotEmpty
            ? drift.Value(_addressCtrl.text.trim())
            : const drift.Value.absent(),
        state: _stateCtrl.text.trim().isNotEmpty
            ? drift.Value(_stateCtrl.text.trim())
            : const drift.Value.absent(),
        kycDocType: _kycNumberCtrl.text.trim().isNotEmpty
            ? drift.Value(_selectedKycType)
            : const drift.Value.absent(),
        kycDocNumber: _kycNumberCtrl.text.trim().isNotEmpty
            ? drift.Value(_kycNumberCtrl.text.trim())
            : const drift.Value.absent(),
      );

      final newId = await dao.insertParty(partyCompanion);
      final createdParty = await dao.getPartyById(newId);

      if (mounted) {
        Navigator.of(context).pop(createdParty);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save party: $e'),
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
        constraints: const BoxConstraints(maxWidth: 520),
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
                          color: colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.person_add_rounded,
                          color: colorScheme.onSecondaryContainer,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add New Party',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Add customer, karigar, or supplier details',
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

                  // Group Type selector
                  SegmentedButton<PartyGroupType>(
                    segments: const [
                      ButtonSegment(
                        value: PartyGroupType.customer,
                        label: Text('Customer'),
                        icon: Icon(Icons.person_outline),
                      ),
                      ButtonSegment(
                        value: PartyGroupType.karigar,
                        label: Text('Karigar'),
                        icon: Icon(Icons.handyman_outlined),
                      ),
                      ButtonSegment(
                        value: PartyGroupType.supplier,
                        label: Text('Supplier'),
                        icon: Icon(Icons.storefront_outlined),
                      ),
                    ],
                    selected: {_selectedGroup},
                    onSelectionChanged: (val) {
                      setState(() => _selectedGroup = val.first);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Full Name
                  TextFormField(
                    controller: _nameCtrl,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Full Name *',
                      prefixIcon: Icon(Icons.badge_outlined),
                      hintText: 'e.g. Rameshwar S. Patil',
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Party name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Mobile & State
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: _mobileCtrl,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Mobile Number',
                            prefixIcon: Icon(Icons.phone_outlined),
                            hintText: '10-digit mobile',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _stateCtrl,
                          decoration: const InputDecoration(
                            labelText: 'State',
                            prefixIcon: Icon(Icons.location_city_outlined),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Address
                  TextFormField(
                    controller: _addressCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      prefixIcon: Icon(Icons.home_outlined),
                      hintText: 'Shop / Residence address',
                    ),
                  ),
                  const SizedBox(height: 12),

                  // KYC Row
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedKycType,
                          decoration: const InputDecoration(
                            labelText: 'KYC Doc',
                            isDense: true,
                          ),
                          items: _kycDocTypes
                              .map(
                                (t) => DropdownMenuItem(
                                  value: t,
                                  child: Text(t),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              setState(() => _selectedKycType = v);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: _kycNumberCtrl,
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                            labelText: 'Document / ID Number',
                            hintText: 'e.g. 1234 5678 9012',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _isSaving
                            ? null
                            : () => Navigator.of(context).pop(),
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
                            : const Icon(Icons.save_rounded, size: 18),
                        label: Text(_isSaving ? 'Saving...' : 'Save Party'),
                        onPressed: _isSaving ? null : _submit,
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
