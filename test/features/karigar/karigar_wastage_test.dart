import 'package:flutter_test/flutter_test.dart';
import 'package:tijori/core/database/app_database.dart';
import 'package:tijori/features/karigar/presentation/karigar_providers.dart';

void main() {
  group('Karigar Ghat (Wastage) & Metal Ledger Suite', () {
    test('settles metal account accurately when permissible wastage is accounted', () {
      final now = DateTime.now();
      final txns = [
        // Issue 100g 24K pure gold bar (100g pure)
        KarigarTransaction(
          id: 1,
          voucherNumber: 'KRG-000001',
          karigarId: 5,
          date: now.subtract(const Duration(days: 7)),
          type: KarigarTxnType.issue,
          itemDescription: 'Fine Gold 24K',
          quantity: 1,
          grossWeight: 100.0,
          purityPercent: 100.0,
          netWeight: 100.0,
          estimatedValue: 700000,
        ),
        // Receive 97g 22K finished ornaments (88.852g pure)
        KarigarTransaction(
          id: 2,
          voucherNumber: 'KRG-000002',
          karigarId: 5,
          date: now,
          type: KarigarTxnType.receive,
          itemDescription: '22K Bangles',
          quantity: 4,
          grossWeight: 97.0,
          purityPercent: 91.6,
          netWeight: 88.852,
          estimatedValue: 620000,
        ),
        // Return Scrap/Trimmings (9.148g pure)
        KarigarTransaction(
          id: 3,
          voucherNumber: 'KRG-000003',
          karigarId: 5,
          date: now,
          type: KarigarTxnType.receive,
          itemDescription: 'Gold Dust & Trimmings',
          quantity: 1,
          grossWeight: 10.0,
          purityPercent: 91.48,
          netWeight: 9.148,
          estimatedValue: 64000,
        ),
        // Permissible Wastage (Ghat) allowance: 2.0g pure
        KarigarTransaction(
          id: 4,
          voucherNumber: 'KRG-000004',
          karigarId: 5,
          date: now,
          type: KarigarTxnType.receive,
          itemDescription: 'Permissible Making Loss (Ghat 2.0%)',
          quantity: 1,
          grossWeight: 2.0,
          purityPercent: 100.0,
          netWeight: 2.0,
          estimatedValue: 14000,
        ),
      ];

      final summary = KarigarMetalSummary.fromTransactions(5, txns);

      expect(summary.totalIssuedPure, equals(100.0));
      expect(summary.totalReceivedPure, equals(100.0));
      expect(summary.pendingPureBalance, equals(0.0));
    });
  });
}
