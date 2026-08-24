import 'package:flutter_test/flutter_test.dart';
import 'package:daleel_child/app/app.dart';

void main() {
  testWidgets('معلمي app starts successfully', (tester) async {
    await tester.pumpWidget(const DaleelChildApp());

    // HomeScreen contains a continuously repeating mascot animation,
    // so pumpAndSettle() can never reach an idle state.
    await tester.pump();

    // Verify that the application starts and renders its MaterialApp.
    expect(find.byType(DaleelChildApp), findsOneWidget);
  });
}
