import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tijori/app/tijori_app.dart';

void main() {
  testWidgets('Tijori App root loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: TijoriApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tijori Dashboard — Coming Soon'), findsOneWidget);
  });
}
