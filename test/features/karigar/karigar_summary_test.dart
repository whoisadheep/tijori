import 'package:flutter_test/flutter_test.dart';
import 'package:tijori/core/database/app_database.dart';
import 'package:tijori/features/karigar/presentation/karigar_providers.dart';

void main() {
  group('Karigar Metal Ledger Calculations', () {
    test('calculates correct pure gold balance when raw metal is issued', () {
      final now = DateTime.now();
      final txns = [
        KarigarTransaction(
          id: 1,
          voucherNumber: 'KRG-000001',
          karigarId: 10,
          date: now,
          type: KarigarTxnType.issue,
          itemDescription: '24K Pure Gold Bar',
          quantity: 1,
          grossWeight: 50.0,
          purityPercent: 99.5,
          netWeight: 49.75, // 50 * 0.995
          estimatedValue: 350000,
          remarks: 'Bangle order',
        ),
      ];

      final summary = KarigarMetalSummary.fromTransactions(10, txns);

      expect(summary.totalIssuedGross, 50.0);
      expect(summary.totalIssuedPure, 49.75);
      expect(summary.totalReceivedGross, 0.0);
      expect(summary.totalReceivedPure, 0.0);
      expect(summary.pendingPureBalance, 49.75);
      expect(summary.transactionCount, 1);
    });

    test('updates outstanding balance when finished ornaments are received', () {
      final now = DateTime.now();
      final txns = [
        // Issue 50g 24K pure gold bar (49.75g pure)
        KarigarTransaction(
          id: 1,
          voucherNumber: 'KRG-000001',
          karigarId: 10,
          date: now.subtract(const Duration(days: 3)),
          type: KarigarTxnType.issue,
          itemDescription: '24K Pure Gold Bar',
          quantity: 1,
          grossWeight: 50.0,
          purityPercent: 99.5,
          netWeight: 49.75,
          estimatedValue: 350000,
          remarks: 'Necklace order',
        ),
        // Receive 40g 22K finished necklace (36.64g pure)
        KarigarTransaction(
          id: 2,
          voucherNumber: 'KRG-000002',
          karigarId: 10,
          date: now,
          type: KarigarTxnType.receive,
          itemDescription: '1 Hallmark 22K Necklace',
          quantity: 1,
          grossWeight: 40.0,
          purityPercent: 91.6,
          netWeight: 36.64,
          estimatedValue: 260000,
          remarks: 'Completed item',
        ),
      ];

      final summary = KarigarMetalSummary.fromTransactions(10, txns);

      expect(summary.totalIssuedPure, 49.75);
      expect(summary.totalReceivedPure, 36.64);
      // Outstanding pure gold still with karigar: 49.75 - 36.64 = 13.11g
      expect(summary.pendingPureBalance, closeTo(13.11, 0.001));
      expect(summary.transactionCount, 2);
    });

    test('confirms zero balance when artisan completely settles metal', () {
      final now = DateTime.now();
      final txns = [
        KarigarTransaction(
          id: 1,
          voucherNumber: 'KRG-000001',
          karigarId: 12,
          date: now.subtract(const Duration(days: 2)),
          type: KarigarTxnType.issue,
          itemDescription: 'Fine Gold',
          quantity: 1,
          grossWeight: 20.0,
          purityPercent: 100.0,
          netWeight: 20.0,
          estimatedValue: 140000,
          remarks: null,
        ),
        KarigarTransaction(
          id: 2,
          voucherNumber: 'KRG-000002',
          karigarId: 12,
          date: now,
          type: KarigarTxnType.receive,
          itemDescription: 'Finished Rings + Scrap Return',
          quantity: 3,
          grossWeight: 20.0,
          purityPercent: 100.0,
          netWeight: 20.0,
          estimatedValue: 140000,
          remarks: 'Full settlement',
        ),
      ];

      final summary = KarigarMetalSummary.fromTransactions(12, txns);

      expect(summary.pendingPureBalance, closeTo(0.0, 0.0001));
    });
  });
}
