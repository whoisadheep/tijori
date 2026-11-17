import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tijori/app/theme/app_colors.dart';

import 'shop_profile_provider.dart';

/// Modal dialog allowing the jeweller to customize shop branding,
/// address, phone number, GSTIN, and receipt footer notes.
class EditShopProfileDialog extends ConsumerStatefulWidget {
  const EditShopProfileDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => const EditShopProfileDialog(),
    );
  }

  @override
  ConsumerState<EditShopProfileDialog> createState() =>
      _EditShopProfileDialogState();
}

class _EditShopProfileDialogState extends ConsumerState<EditShopProfileDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _taglineCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _gstinCtrl;
  late final TextEditingController _licenseCtrl;
  late final TextEditingController _termsCtrl;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(shopProfileProvider);
    _nameCtrl = TextEditingController(text: profile.shopName);
    _taglineCtrl = TextEditingController(text: profile.tagline ?? '');
    _addressCtrl = TextEditingController(text: profile.address ?? '');
    _phoneCtrl = TextEditingController(text: profile.phone ?? '');
    _emailCtrl = TextEditingController(text: profile.email ?? '');
    _gstinCtrl = TextEditingController(text: profile.gstin ?? '');
    _licenseCtrl = TextEditingController(text: profile.licenseNumber ?? '');
    _termsCtrl = TextEditingController(text: profile.termsAndConditions ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _taglineCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _gstinCtrl.dispose();
    _licenseCtrl.dispose();
    _termsCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final updated = ShopProfile(
      shopName: _nameCtrl.text.trim(),
      tagline: _taglineCtrl.text.trim().isEmpty ? null : _taglineCtrl.text.trim(),
      address: _addressCtrl.text.trim().isEmpty ? null : _addressCtrl.text.trim(),
      phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
      email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
      gstin: _gstinCtrl.text.trim().isEmpty ? null : _gstinCtrl.text.trim(),
      licenseNumber:
          _licenseCtrl.text.trim().isEmpty ? null : _licenseCtrl.text.trim(),
      termsAndConditions:
          _termsCtrl.text.trim().isEmpty ? null : _termsCtrl.text.trim(),
    );

    await ref.read(shopProfileProvider.notifier).updateProfile(updated);

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Shop profile updated: ${updated.shopName}'),
          backgroundColor: AppColors.champagneDark,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.champagneLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.storefront_rounded,
              color: AppColors.champagneDark,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Text('Edit Shop Profile & Print Header'),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'These details appear on thermal pledge slips, payment receipts, Karigar hisaab statements, and GST invoices.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),

                // Shop Name
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Shop Name *',
                    hintText: 'e.g. Shree Krishna Jewellers',
                    prefixIcon: Icon(Icons.store_outlined),
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your shop name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Tagline / Specialty
                TextFormField(
                  controller: _taglineCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Tagline / Specialty',
                    hintText: 'e.g. 916 Hallmark Gold & Govt. Approved Valuer',
                    prefixIcon: Icon(Icons.label_important_outline_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                // Address
                TextFormField(
                  controller: _addressCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Shop Address',
                    hintText: 'e.g. Shop 4, Sarafa Bazar, M.G. Road, Pune - 411002',
                    prefixIcon: Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                // Phone & Email Row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _phoneCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Phone / WhatsApp',
                          hintText: 'e.g. +91 98765 43210',
                          prefixIcon: Icon(Icons.phone_outlined),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _emailCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          hintText: 'e.g. info@shreekrishna.com',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // GSTIN & License No Row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _gstinCtrl,
                        decoration: const InputDecoration(
                          labelText: 'GSTIN Number',
                          hintText: 'e.g. 27AAAPL1234C1ZV',
                          prefixIcon: Icon(Icons.receipt_long_outlined),
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.characters,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _licenseCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Girvi / Money Lending License',
                          hintText: 'e.g. LIC/MH/PUN/2024/098',
                          prefixIcon: Icon(Icons.badge_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Terms & Conditions Footer
                TextFormField(
                  controller: _termsCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Receipt Terms & Footer Notes',
                    hintText: 'e.g. Subject to local jurisdiction. Valid ID required for redemption.',
                    prefixIcon: Icon(Icons.gavel_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          icon: const Icon(Icons.check_circle_rounded),
          label: const Text('Save Shop Profile'),
          onPressed: _handleSave,
        ),
      ],
    );
  }
}
