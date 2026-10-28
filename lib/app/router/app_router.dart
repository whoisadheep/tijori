import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tijori/app/layout/adaptive_shell.dart';
import 'package:tijori/features/daily_rates/presentation/daily_rates_screen.dart';
import 'package:tijori/features/dashboard/presentation/dashboard_screen.dart';
import 'package:tijori/features/girvi/presentation/girvi_detail_screen.dart';
import 'package:tijori/features/girvi/presentation/girvi_list_screen.dart';
import 'package:tijori/features/girvi/presentation/new_girvi_loan_screen.dart';
import 'package:tijori/features/gst/presentation/gst_screen.dart';
import 'package:tijori/features/karigar/presentation/karigar_detail_screen.dart';
import 'package:tijori/features/karigar/presentation/karigar_screen.dart';
import 'package:tijori/features/parties/presentation/parties_screen.dart';
import 'package:tijori/features/settings/presentation/settings_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AdaptiveShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/girvi',
            name: 'girvi_list',
            builder: (context, state) => const GirviListScreen(),
            routes: [
              GoRoute(
                path: 'new',
                name: 'new_girvi_loan',
                builder: (context, state) => const NewGirviLoanScreen(),
              ),
              GoRoute(
                path: ':id',
                name: 'girvi_detail',
                builder: (context, state) {
                  final idStr = state.pathParameters['id'] ?? '0';
                  final loanId = int.tryParse(idStr) ?? 0;
                  return GirviDetailScreen(loanId: loanId);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/daily-rates',
            name: 'daily_rates',
            builder: (context, state) => const DailyRatesScreen(),
          ),
          GoRoute(
            path: '/parties',
            name: 'parties',
            builder: (context, state) => const PartiesScreen(),
          ),
          GoRoute(
            path: '/karigar',
            name: 'karigar',
            builder: (context, state) => const KarigarScreen(),
            routes: [
              GoRoute(
                path: ':id',
                name: 'karigar_detail',
                builder: (context, state) {
                  final idStr = state.pathParameters['id'] ?? '0';
                  final karigarId = int.tryParse(idStr) ?? 0;
                  return KarigarDetailScreen(karigarId: karigarId);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/gst',
            name: 'gst',
            builder: (context, state) => const GstScreen(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
}
