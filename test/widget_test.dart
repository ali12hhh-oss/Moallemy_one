import 'package:flutter_test/flutter_test.dart';
import 'package:daleel_child/app/app.dart';

void main() {
  testWidgets('معلمي starts', (tester) async {
    await tester.pumpWidget(const DaleelChildApp());
    // HomeScreen contains a continuously repeating mascot animation, so
    // pumpAndSettle() can never reach an idle state. Pump one frame instead.
    await tester.pump();
    expect(find.text('🌈 معلمي'), findsOneWidget);
  });
}
