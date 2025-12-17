// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:myapp/main.dart';

void main() {
  testWidgets('MoodApp displays quote and button', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MoodApp());

    // Verify that the button is present.
    expect(find.text('MOOD\'U DEĞİŞTİR'), findsOneWidget);

    // Verify that some quote text is displayed (could be welcome message or a quote).
    expect(find.byType(Text), findsWidgets);

    // Tap the button to change the quote.
    await tester.tap(find.text('MOOD\'U DEĞİŞTİR'));
    await tester.pump();

    // Verify that the app still has text displayed after button tap.
    expect(find.byType(Text), findsWidgets);
  });
}
