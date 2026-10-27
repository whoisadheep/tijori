import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tijori/core/licensing/freemium_service.dart';
import 'package:tijori/core/licensing/upgrade_paywall_dialog.dart';
import 'package:tijori/core/updater/update_checker_widget.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateFmt = DateFormat('dd MMM yyyy, hh:mm a');

    final license = ref.watch(freemiumProvider);
    final freemiumNotifier = ref.read(freemiumProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Configuration'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. License & Subscription Card
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
                                Icon(
                                  Icons.verified_user_rounded,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'License & Edition',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: license.effectiveTier.isPaid
                                    ? Colors.amber.shade100
                                    : colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: license.effectiveTier.isPaid
                                      ? Colors.amber.shade800
                                      : colorScheme.outlineVariant,
                                ),
                              ),
                              child: Text(
                                '${license.effectiveTier.displayName.toUpperCase()} EDITION',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: license.effectiveTier.isPaid
                                      ? Colors.amber.shade900
                                      : colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Text(
                          'Shop Name: ${license.shopName ?? "Tijori Jewellers (Local)"}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        if (license.ownerEmail != null)
                          Text('Owner Email: ${license.ownerEmail}'),
                        const SizedBox(height: 8),
                        Text(
                          'Last Remote Verification: ${dateFmt.format(license.lastVerifiedAt)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          license.isOfflineGraceExpired()
                              ? 'Offline grace period has expired (> 7 days).'
                              : 'Offline Mode: Valid for up to 7 days without internet.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: license.isOfflineGraceExpired()
                                ? colorScheme.error
                                : Colors.green.shade700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            OutlinedButton.icon(
                              icon: const Icon(Icons.sync_rounded, size: 18),
                              label: const Text('Refresh License Now'),
                              onPressed: () async {
                                final res = await freemiumNotifier
                                    .refreshLicenseSilently();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(res
                                          ? 'License successfully verified with server.'
                                          : 'Working offline — using cached license.'),
                                    ),
                                  );
                                }
                              },
                            ),
                            const SizedBox(width: 12),
                            if (!license.effectiveTier.isPaid)
                              FilledButton.icon(
                                icon: const Icon(Icons.star_rounded, size: 18),
                                label: const Text('Upgrade Edition'),
                                onPressed: () => UpgradePaywallDialog.show(
                                  context,
                                  feature: GatedFeature.karigarManagement,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 2. OTA Software Update Widget
                const UpdateCheckerWidget(),
                const SizedBox(height: 20),

                // 3. System & Database Diagnostics
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
                          children: [
                            Icon(
                              Icons.storage_rounded,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Local Storage & Offline Database',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        const Text(
                          'Database Engine: SQLite (Native Drift C-Bindings)',
                        ),
                        const Text(
                          'Database File: tijori_erp.sqlite (Local Documents)',
                        ),
                        const Text(
                          'Data Sovereignty: 100% Offline-First. No business transaction or customer data is transmitted to third-party clouds.',
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
  }
}
