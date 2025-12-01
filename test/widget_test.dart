// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:japanese_verb_trainer/main.dart';

void main() {
  testWidgets('Main screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const JapaneseVerbApp());

    // Verify that the title is displayed.
    expect(find.text('Ichidan Verb Practice'), findsOneWidget);

    // Verify that the furigana switch is displayed.
    expect(find.byType(CupertinoSwitch), findsOneWidget);

    // Verify that there are conjugation and translation options.
    expect(find.text('Check'), findsOneWidget);
  });
}
