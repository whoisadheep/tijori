import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tijori/core/database/app_database.dart';

import 'update_rates_dialog.dart';

class DailyRatesScreen extends ConsumerWidget {
  const DailyRatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateFmt = DateFormat('EEEE, dd MMM yyyy');

    final db = ref.watch(appDatabaseProvider);
    final ratesStream = (db.select(db.dailyRates)
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Metal Rates History'),
        actions: [
          FilledButton.icon(
            icon: const Icon(Icons.add_rounded),
            label: const Text('Update Today\'s Rates'),
            onPressed: () => UpdateRatesDialog.show(context),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: StreamBuilder<List<DailyRate>>(
        stream: ratesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final rates = snapshot.data ?? [];
          if (rates.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.price_change_outlined,
                    size: 48,
                    color: colorScheme.outline,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No metal rates recorded yet.',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Enter Today\'s Rates'),
                    onPressed: () => UpdateRatesDialog.show(context),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: rates.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, idx) {
              final rate = rates[idx];

              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: colorScheme.outlineVariant),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: Text(
                          dateFmt.format(rate.date),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '24K: ₹${rate.gold24k?.toStringAsFixed(0) ?? "—"}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '22K: ₹${rate.gold22k?.toStringAsFixed(0) ?? "—"}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '18K: ₹${rate.gold18k?.toStringAsFixed(0) ?? "—"}',
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Silver: ₹${rate.silverRate?.toStringAsFixed(1) ?? "—"}',
                          style: TextStyle(
                            color: Colors.blueGrey.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
