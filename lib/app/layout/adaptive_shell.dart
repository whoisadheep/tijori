import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tijori/app/theme/app_colors.dart';
import 'package:tijori/core/updater/ota_update_service.dart';
import 'package:tijori/core/updater/update_checker_widget.dart';
import 'package:tijori/features/daily_rates/presentation/daily_rates_providers.dart';
import 'package:tijori/features/daily_rates/presentation/update_rates_dialog.dart';

/// Responsive Desktop & Mobile layout shell with persistent navigation,
/// live metal rates ticker header, and tier indicators.
class AdaptiveShell extends ConsumerWidget {
  final Widget child;

  const AdaptiveShell({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/girvi')) return 1;
    if (location.startsWith('/daily-rates')) return 2;
    if (location.startsWith('/parties')) return 3;
    if (location.startsWith('/karigar')) return 4;
    if (location.startsWith('/gst')) return 5;
    if (location.startsWith('/settings')) return 6;
    return 0; // Dashboard
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/girvi');
        break;
      case 2:
        context.go('/daily-rates');
        break;
      case 3:
        context.go('/parties');
        break;
      case 4:
        context.go('/karigar');
        break;
      case 5:
        context.go('/gst');
        break;
      case 6:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 1024;

    final selectedIndex = _calculateSelectedIndex(context);
    final latestRateAsync = ref.watch(latestDailyRateProvider);
    final otaState = ref.watch(otaUpdateProvider);

    final Widget shellContent;
    if (isDesktop) {
      shellContent = Scaffold(
        body: Row(
          children: [
            // Left Desktop Navigation Sidebar
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: (idx) => _onItemTapped(idx, context),
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.champagneGold, AppColors.burntAmber],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.burntAmber.withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.shield_rounded,
                        color: AppColors.champagneOn,
                        size: 26,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'TIJORI',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        color: AppColors.champagneGlow,
                      ),
                    ),
                    Text(
                      'ERP',
                      style: theme.textTheme.labelSmall?.copyWith(
                        letterSpacing: 2,
                        color: AppColors.burntAmber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.champagneLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.champagneBorder),
                      ),
                      child: const Text(
                        'PRO EDITION',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AppColors.champagneDark,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard_rounded),
                  label: Text('Overview'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.account_balance_outlined),
                  selectedIcon: Icon(Icons.account_balance_rounded),
                  label: Text('Girvi Loans'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.price_change_outlined),
                  selectedIcon: Icon(Icons.price_change_rounded),
                  label: Text('Daily Rates'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.people_outline_rounded),
                  selectedIcon: Icon(Icons.people_rounded),
                  label: Text('Parties'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.handyman_outlined),
                  selectedIcon: Icon(Icons.handyman_rounded),
                  label: Text('Karigar'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long_rounded),
                  label: Text('GST Billing'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings_rounded),
                  label: Text('Settings'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),

            // Main Content Area with Persistent Live Rates Bar
            Expanded(
              child: Column(
                children: [
                  // Top Live Header Bar
                  Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      border: Border(
                        bottom: BorderSide(color: colorScheme.outlineVariant),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Rates Ticker
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () => UpdateRatesDialog.show(context),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                  Icon(
                                    Icons.trending_up_rounded,
                                    size: 18,
                                    color: colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Today\'s Metal Rates:',
                                    style: theme.textTheme.labelMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  latestRateAsync.when(
                                    data: (rate) {
                                      if (rate == null) {
                                        return Text(
                                          'Not set today — Click to update',
                                          style: TextStyle(
                                            color: colorScheme.error,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        );
                                      }
                                      return Row(
                                        children: [
                                          _buildHeaderRatePill(
                                            '24K',
                                            rate.gold24k != null
                                                ? '₹${rate.gold24k!.toStringAsFixed(0)}'
                                                : '—',
                                            AppColors.champagneDark,
                                          ),
                                          const SizedBox(width: 10),
                                          _buildHeaderRatePill(
                                            '22K',
                                            rate.gold22k != null
                                                ? '₹${rate.gold22k!.toStringAsFixed(0)}'
                                                : '—',
                                            AppColors.champagneGold,
                                          ),
                                          const SizedBox(width: 10),
                                          _buildHeaderRatePill(
                                            'Silver',
                                            rate.silverRate != null
                                                ? '₹${rate.silverRate!.toStringAsFixed(1)}'
                                                : '—',
                                            AppColors.silverRate,
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(
                                            Icons.edit_outlined,
                                            size: 14,
                                            color: colorScheme.outline,
                                          ),
                                        ],
                                      );
                                    },
                                    loading: () =>
                                        const Text('Loading rates...'),
                                    error: (_, __) =>
                                        const Text('Rates unavailable'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                        // OTA Update Notification Badge
                        if (otaState.status == UpdateStatus.updateAvailable ||
                            otaState.status ==
                                UpdateStatus.mandatoryUpdateRequired) ...[
                          IconButton(
                            tooltip: 'New Software Update Available',
                            icon: const Icon(
                              Icons.new_releases_rounded,
                              color: AppColors.burntAmber,
                            ),
                            onPressed: () => context.go('/settings'),
                          ),
                          const SizedBox(width: 8),
                        ],

                        // Current Edition Badge
                        ActionChip(
                          avatar: const Icon(
                            Icons.verified_rounded,
                            size: 16,
                            color: AppColors.champagneDark,
                          ),
                          backgroundColor: AppColors.champagneLight,
                          side: const BorderSide(
                            color: AppColors.champagneBorder,
                          ),
                          label: const Text(
                            'Full Edition',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: AppColors.champagneDark,
                            ),
                          ),
                          onPressed: () => context.go('/settings'),
                        ),
                      ],
                    ),
                  ),

                  // Screen Content
                  Expanded(child: child),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      // Mobile / Tablet View
      shellContent = Scaffold(
        body: child,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex > 3 ? 0 : selectedIndex,
          onDestinationSelected: (idx) => _onItemTapped(idx, context),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded),
              label: 'Overview',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_balance_outlined),
              selectedIcon: Icon(Icons.account_balance_rounded),
              label: 'Girvi',
            ),
            NavigationDestination(
              icon: Icon(Icons.price_change_outlined),
              selectedIcon: Icon(Icons.price_change_rounded),
              label: 'Rates',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      );
    }

    if (!otaState.isMandatory) {
      return shellContent;
    }

    return Stack(
      children: [
        shellContent,
        Positioned.fill(
          child: Container(
            color: Colors.black.withValues(alpha: 0.65),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(24),
            child: const MandatoryUpdateDialog(),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderRatePill(String label, String value, Color color) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
