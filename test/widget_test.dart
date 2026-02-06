// Phone Detective - Widget Test

import 'package:flutter_test/flutter_test.dart';
import 'package:phone_detective/app.dart';

void main() {
  testWidgets('App launches correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const PhoneDetectiveApp());

    // Wait for splash screen
    await tester.pump(const Duration(milliseconds: 100));

    // Verify app title appears (on splash or after navigation)
    expect(find.textContaining('PHONE'), findsWidgets);
  });
}
