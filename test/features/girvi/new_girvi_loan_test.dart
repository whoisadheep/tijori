import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tijori/core/database/app_database.dart';
import 'package:tijori/features/girvi/presentation/new_girvi_loan_screen.dart';
import '../../test_sqlite_helper.dart';

void main() {
  setUpAll(() {
    initializeTestSqlite();
  });

  testWidgets('Sanction loan flow test', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase(NativeDatabase.memory());

    // Insert a party
    await db.partiesDao.insertParty(
      PartiesCompanion.insert(
        name: 'Adheep Test',
        groupType: PartyGroupType.customer,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: NewGirviLoanScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify initial screen loaded
    expect(find.text('New Girvi (Pawn) Pledge'), findsOneWidget);

    // Click Sanction Loan button without filling form
    final sanctionBtn = find.text('Sanction Loan & Issue Slip');
    expect(sanctionBtn, findsOneWidget);
    await tester.ensureVisible(sanctionBtn);
    await tester.pumpAndSettle();
    await tester.tap(sanctionBtn);
    await tester.pumpAndSettle();

    // Verify errors and SnackBar warning appeared
    expect(find.text('Please select a customer'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.textContaining('Please complete required fields: Customer / Borrower'), findsOneWidget);

    // Dismiss SnackBar so it doesn't obscure buttons
    ScaffoldMessenger.of(tester.element(find.byType(Scaffold))).clearSnackBars();
    await tester.pumpAndSettle();

    // Now select the customer from the dropdown
    final dropdownFinder = find.byType(DropdownButtonFormField<int>);
    expect(dropdownFinder, findsOneWidget);
    await tester.ensureVisible(dropdownFinder);
    await tester.tap(dropdownFinder);
    await tester.pumpAndSettle();

    // Tap the item 'Adheep Test'
    await tester.tap(find.text('Adheep Test').last);
    await tester.pumpAndSettle();

    // Fill in Gross Weight
    final grossWeightFinder = find.widgetWithText(TextFormField, 'Gross Weight *');
    await tester.ensureVisible(grossWeightFinder);
    await tester.enterText(grossWeightFinder, '10.5');
    await tester.pumpAndSettle();

    // Fill in Item Description
    final itemDescFinder = find.widgetWithText(TextFormField, 'Item Description *');
    await tester.ensureVisible(itemDescFinder);
    await tester.enterText(itemDescFinder, '22K Gold Bangle');
    await tester.pumpAndSettle();

    // Fill in Principal Amount
    final principalFinder = find.widgetWithText(TextFormField, 'Principal Loan Amount *');
    await tester.ensureVisible(principalFinder);
    await tester.enterText(principalFinder, '45000');
    await tester.pumpAndSettle();

    // Tap Sanction Loan
    await tester.ensureVisible(sanctionBtn);
    await tester.tap(sanctionBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify dialog appeared
    expect(find.text('Pledge Slip Generated!'), findsOneWidget);

    // Verify loan in database
    final loans = await db.girviLoansDao.select(db.girviLoansDao.girviLoans).get();
    expect(loans.length, 1);
    expect(loans.first.principalAmount, 45000.0);
    expect(loans.first.itemDescription, '22K Gold Bangle');

    await db.close();
  });
}
