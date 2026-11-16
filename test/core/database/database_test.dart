import 'package:drift/drift.dart' hide isNotNull, isNull;
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
    // Create an in-memory SQLite instance for testing
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Drift In-Memory Database Tests', () {
    test('Can insert and retrieve Daily Rates', () async {
      final now = DateTime.now();
      final rateId = await db.dailyRatesDao.insertRate(
        DailyRatesCompanion.insert(
          date: now,
          gold24k: const Value(7500.0),
          gold22k: const Value(6875.0),
          gold18k: const Value(5625.0),
          silverRate: const Value(85.0),
        ),
      );

      expect(rateId, isPositive);

      final latest = await db.dailyRatesDao.getLatestRate();
      expect(latest, isNotNull);
      expect(latest!.gold24k, equals(7500.0));
      expect(latest.silverRate, equals(85.0));
    });

    test('Can insert Party and Girvi Loan with Slip Number generation', () async {
      // 1. Insert Party
      final partyId = await db.partiesDao.insertParty(
        PartiesCompanion.insert(
          name: 'Ramesh Jewellers / Customer',
          groupType: PartyGroupType.customer,
          mobile: const Value('9876543210'),
          address: const Value('Zaveri Bazaar, Mumbai'),
        ),
      );
      expect(partyId, isPositive);

      // 2. Auto-generate Slip Number
      final slipNo = await db.girviLoansDao.generateNextSlipNumber();
      expect(slipNo, equals('GIRVI-000001'));

      // 3. Insert Girvi Loan
      final loanDate = DateTime(2025, 1, 1);
      final loanId = await db.girviLoansDao.insertLoan(
        GirviLoansCompanion.insert(
          slipNumber: slipNo,
          partyId: partyId,
          transactionDate: loanDate,
          interestStartDate: loanDate,
          roi: 1.5,
          interestType: InterestType.monthWise,
          metalType: MetalType.gold,
          grossWeight: 20.0,
          purityPercent: 91.6,
          netWeight: 18.32,
          estimatedValue: 125000.0,
          principalAmount: 80000.0,
          paymentMode: PaymentMode.cash,
          itemDescription: 'Gold Chain (22K Hallmark)',
        ),
      );
      expect(loanId, isPositive);

      // 4. Verify loan retrieval
      final loan = await db.girviLoansDao.getLoanById(loanId);
      expect(loan, isNotNull);
      expect(loan!.slipNumber, equals('GIRVI-000001'));
      expect(loan.principalAmount, equals(80000.0));
      expect(loan.status, equals(LoanStatus.active));

      // 5. Active loan count
      final activeCount = await db.girviLoansDao.countActiveLoans();
      expect(activeCount, equals(1));

      // 6. Insert Loan Receipt
      final recNo = await db.loanReceiptsDao.generateNextReceiptNumber();
      expect(recNo, equals('REC-000001'));

      final receiptId = await db.loanReceiptsDao.insertReceipt(
        LoanReceiptsCompanion.insert(
          receiptNumber: recNo,
          loanId: loanId,
          date: DateTime(2025, 2, 1),
          paymentMode: PaymentMode.cash,
          receiptType: ReceiptType.interestOnly,
          amount: 1200.0,
        ),
      );
      expect(receiptId, isPositive);

      final receipts = await db.loanReceiptsDao.getReceiptsForLoan(loanId);
      expect(receipts.length, equals(1));
      expect(receipts.first.amount, equals(1200.0));
    });
  });
}
