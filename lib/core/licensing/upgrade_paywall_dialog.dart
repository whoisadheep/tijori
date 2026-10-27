import 'package:flutter/material.dart';

import 'license_models.dart';

/// Modal paywall dialog shown when a user attempts to access a gated feature.
class UpgradePaywallDialog extends StatelessWidget {
  final GatedFeature feature;
  final VoidCallback? onUpgrade;

  const UpgradePaywallDialog({
    super.key,
    required this.feature,
    this.onUpgrade,
  });

  /// Displays the modal dialog over [context].
  static Future<void> show(
    BuildContext context, {
    required GatedFeature feature,
    VoidCallback? onUpgrade,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => UpgradePaywallDialog(
        feature: feature,
        onUpgrade: onUpgrade,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header icon & title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.lock_rounded,
                      color: colorScheme.onPrimaryContainer,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          feature.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Requires ${feature.requiredTier.displayName} Edition',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                feature.description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),

              // Feature comparison matrix
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  children: [
                    _buildTierRow(
                      context,
                      'Free Tier',
                      'Max 25 active loans, Watermarked slips, Girvi-only',
                      isCurrent: true,
                    ),
                    const Divider(height: 16),
                    _buildTierRow(
                      context,
                      'Pro Edition',
                      'Unlimited loans, Karigar, GST Invoicing, Clean slips',
                      isRecommended: true,
                    ),
                    const Divider(height: 16),
                    _buildTierRow(
                      context,
                      'Enterprise',
                      'Multi-branch sync, Audit trail, Tally XML & Priority support',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Maybe Later'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    icon: const Icon(Icons.star_rounded, size: 20),
                    label: const Text('Upgrade License'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onUpgrade != null) {
                        onUpgrade!();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please contact your Tijori administrator to upgrade your license.',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTierRow(
    BuildContext context,
    String title,
    String subtitle, {
    bool isCurrent = false,
    bool isRecommended = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isCurrent
              ? Icons.radio_button_checked
              : (isRecommended
                  ? Icons.check_circle_rounded
                  : Icons.circle_outlined),
          size: 18,
          color: isRecommended ? colorScheme.primary : colorScheme.outline,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isRecommended
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                    ),
                  ),
                  if (isRecommended) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'RECOMMENDED',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onPrimary,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
