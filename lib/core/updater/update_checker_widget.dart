import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ota_update_service.dart';

/// Compact UI widget displaying update status, changelogs, download progress,
/// and installation triggers. Can be mounted in settings or dashboard.
class UpdateCheckerWidget extends ConsumerWidget {
  const UpdateCheckerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateState = ref.watch(otaUpdateProvider);
    final notifier = ref.read(otaUpdateProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
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
              children: [
                Icon(
                  Icons.system_update_rounded,
                  color: colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Software Updates',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (updateState.currentVersion != null)
                        Text(
                          'Current Version: v${updateState.currentVersion}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                if (updateState.status == UpdateStatus.idle ||
                    updateState.status == UpdateStatus.upToDate ||
                    updateState.status == UpdateStatus.error)
                  OutlinedButton.icon(
                    icon: const Icon(Icons.refresh_rounded, size: 16),
                    label: const Text('Check Now'),
                    onPressed: () => notifier.checkForUpdates(),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Dynamic Body by Status
            switch (updateState.status) {
              UpdateStatus.idle => const SizedBox.shrink(),
              UpdateStatus.checking => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Checking GitHub Releases for updates...'),
                    ],
                  ),
                ),
              UpdateStatus.upToDate => Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: Colors.green.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Tijori is up to date!',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              UpdateStatus.updateAvailable ||
              UpdateStatus.mandatoryUpdateRequired =>
                _buildUpdateAvailableView(
                  context,
                  updateState,
                  notifier,
                  isMandatory: updateState.status ==
                      UpdateStatus.mandatoryUpdateRequired,
                ),
              UpdateStatus.downloading => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Downloading update... ${(updateState.downloadProgress * 100).toStringAsFixed(0)}%',
                          style: theme.textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () => notifier.cancelDownload(),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: updateState.downloadProgress > 0
                          ? updateState.downloadProgress
                          : null,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              UpdateStatus.readyToInstall => Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.download_done_rounded,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Update package ready to install.',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      FilledButton.icon(
                        icon: const Icon(Icons.install_desktop_rounded, size: 18),
                        label: const Text('Install & Restart'),
                        onPressed: () => notifier.installUpdate(),
                      ),
                    ],
                  ),
                ),
              UpdateStatus.error => Row(
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: colorScheme.error,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        updateState.errorMessage ?? 'An error occurred.',
                        style: TextStyle(color: colorScheme.error),
                      ),
                    ),
                    TextButton(
                      onPressed: () => notifier.checkForUpdates(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
            },
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateAvailableView(
    BuildContext context,
    UpdateState state,
    OtaUpdateNotifier notifier, {
    required bool isMandatory,
  }) {
    final info = state.releaseInfo;
    if (info == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMandatory
            ? colorScheme.errorContainer.withValues(alpha: 0.3)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isMandatory ? colorScheme.error : colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isMandatory ? Icons.warning_rounded : Icons.new_releases_rounded,
                color: isMandatory ? colorScheme.error : colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                isMandatory
                    ? 'Mandatory Update: v${info.latestVersion}'
                    : 'New Version Available: v${info.latestVersion}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isMandatory ? colorScheme.error : colorScheme.onSurface,
                ),
              ),
            ],
          ),
          if (info.changelog.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              info.changelog,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              icon: const Icon(Icons.download_rounded, size: 18),
              label: Text(isMandatory ? 'Update Now (Required)' : 'Download Update'),
              style: isMandatory
                  ? FilledButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      foregroundColor: colorScheme.onError,
                    )
                  : null,
              onPressed: () => notifier.downloadUpdate(),
            ),
          ),
        ],
      ),
    );
  }
}

/// A non-dismissible modal dialog displayed when current app version is
/// below [ReleaseInfo.minRequiredVersion].
class MandatoryUpdateDialog extends ConsumerWidget {
  const MandatoryUpdateDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(otaUpdateProvider);
    final notifier = ref.read(otaUpdateProvider.notifier);
    final info = state.releaseInfo;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopScope(
      canPop: false, // Prevents closing or back-navigation
      child: AlertDialog(
        icon: Icon(Icons.security_update_warning_rounded,
            size: 48, color: colorScheme.error),
        title: const Text('Update Required'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'A critical database or security update (v${info?.latestVersion ?? ""}) is required to continue using Tijori ERP.',
              style: theme.textTheme.bodyMedium,
            ),
            if (info != null && info.changelog.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Changelog:',
                style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Container(
                constraints: const BoxConstraints(maxHeight: 120),
                child: SingleChildScrollView(
                  child: Text(
                    info.changelog,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (state.status == UpdateStatus.downloading) ...[
              LinearProgressIndicator(value: state.downloadProgress),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Downloading: ${(state.downloadProgress * 100).toStringAsFixed(0)}%',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (state.status == UpdateStatus.readyToInstall)
            FilledButton.icon(
              icon: const Icon(Icons.install_mobile_rounded),
              label: const Text('Install & Restart'),
              onPressed: () => notifier.installUpdate(),
            )
          else if (state.status != UpdateStatus.downloading)
            FilledButton.icon(
              icon: const Icon(Icons.download_rounded),
              label: const Text('Download Update Now'),
              onPressed: () => notifier.downloadUpdate(),
            ),
        ],
      ),
    );
  }
}
