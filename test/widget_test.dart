import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tijori/app/tijori_app.dart';
import 'package:tijori/core/database/app_database.dart';
import 'test_sqlite_helper.dart';

void main() {
  setUpAll(() {
    initializeTestSqlite();
  });

  testWidgets('Tijori App root loads dashboard successfully', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
        ],
        child: const TijoriApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('New Girvi Pledge'), findsOneWidget);
    expect(find.text('TIJORI'), findsOneWidget);

    await db.close();
  });
}
