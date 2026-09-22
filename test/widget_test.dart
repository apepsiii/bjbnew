import 'package:flutter_test/flutter_test.dart';
import 'package:digi_bank_bjb/main.dart';
import 'package:digi_bank_bjb/screens/splash_screen.dart';

void main() {
  testWidgets('DIGI Bank BJB App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DigiBjbApp());

    // Verify that SplashScreen is displayed.
    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
