import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tijori/core/database/app_database.dart';
import '../../test_sqlite_helper.dart';

void main() {
  late AppDatabase db;

  setUpAll(() {
    initializeTestSqlite();
  });

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async => await db.close());

  group('Atomic Transactions & Sequence Integrity', () {
    test('transaction rolls back cleanly when secondary step fails', () async {
      final partyId = await db.partiesDao.insertParty(
        PartiesCompanion.insert(
          name: 'Suresh Patil',
          groupType: PartyGroupType.customer,
        ),
      );

      expect(
        () async => await db.transaction(() async {
          // 1. Insert loan
          await db.girviLoansDao.insertLoan(
            GirviLoansCompanion.insert(
              slipNumber: 'GIRVI-ROLLBACK-01',
              partyId: partyId,
              transactionDate: DateTime.now(),
              interestStartDate: DateTime.now(),
              roi: 1.5,
              interestType: InterestType.monthWise,
              metalType: MetalType.gold,
              grossWeight: 10.0,
              purityPercent: 91.6,
              netWeight: 9.16,
              estimatedValue: 70000,
              principalAmount: 50000,
              paymentMode: PaymentMode.cash,
              itemDescription: 'Gold Ring',
            ),
          );

          // 2. Deliberate failure during transaction
          throw Exception('Simulated crash during sanction workflow');
        }),
        throwsException,
      );

      // Verify no orphaned loan exists in the database
      final loans = await db.select(db.girviLoans).get();
      expect(loans, isEmpty);
    });

    test('generateNextSlipNumber avoids collisions when intermediate records are deleted', () async {
      final partyId = await db.partiesDao.insertParty(
        PartiesCompanion.insert(name: 'Test Customer', groupType: PartyGroupType.customer),
      );

      // Insert Loan 1 & Loan 2
      final id1 = await db.girviLoansDao.insertLoan(
        GirviLoansCompanion.insert(
          slipNumber: 'GIRVI-000001',
          partyId: partyId,
          transactionDate: DateTime.now(),
          interestStartDate: DateTime.now(),
          roi: 1.5,
          interestType: InterestType.monthWise,
          metalType: MetalType.gold,
          grossWeight: 10,
          purityPercent: 91.6,
          netWeight: 9.16,
          estimatedValue: 70000,
          principalAmount: 50000,
          paymentMode: PaymentMode.cash,
          itemDescription: 'Ring 1',
        ),
      );

      await db.girviLoansDao.insertLoan(
        GirviLoansCompanion.insert(
          slipNumber: 'GIRVI-000002',
          partyId: partyId,
          transactionDate: DateTime.now(),
          interestStartDate: DateTime.now(),
          roi: 1.5,
          interestType: InterestType.monthWise,
          metalType: MetalType.gold,
          grossWeight: 10,
          purityPercent: 91.6,
          netWeight: 9.16,
          estimatedValue: 70000,
          principalAmount: 50000,
          paymentMode: PaymentMode.cash,
          itemDescription: 'Ring 2',
        ),
      );

      // Delete loan 1
      await (db.delete(db.girviLoans)..where((t) => t.id.equals(id1))).go();

      // Next slip number MUST NOT reuse 'GIRVI-000002'
      final nextSlip = await db.girviLoansDao.generateNextSlipNumber();
      expect(nextSlip, equals('GIRVI-000003'));
    });
  });
}
