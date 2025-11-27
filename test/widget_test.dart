// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:callme/main.dart';

void main() {
  testWidgets('Phone dialer smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the display shows 'Enter number'
    expect(find.text('Enter number'), findsOneWidget);

    // Tap a digit button, say '1'
    await tester.tap(find.text('1'));
    await tester.pump();

    // Verify that the display shows '1'
    expect(find.text('1'), findsOneWidget);
  });
}
