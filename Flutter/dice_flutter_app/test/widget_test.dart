import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dice_challenge/main.dart';
import 'package:dice_challenge/theme/app_theme.dart';

Widget _app() => MaterialApp(
      theme: AppTheme.dark,
      home: DiceScreen(
        random: Random(7),
        rollDuration: const Duration(milliseconds: 180),
      ),
    );

void main() {
  testWidgets('starts with dice at 1, total 2, and the sad result',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(_app());

    expect(find.text('2'), findsOneWidget);
    expect(find.text('You Lose'), findsOneWidget);
  });

  testWidgets('rolling hides the result, then reveals it and re-enables Roll',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(_app());

    await tester.tap(find.text('Roll dice'));
    await tester.pump();

    expect(find.text('Rolling…'), findsOneWidget);
    final rollButton = tester.widget<FilledButton>(
      find.byWidgetPredicate((w) => w is FilledButton),
    );
    expect(rollButton.onPressed, isNull);

    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('Rolling…'), findsNothing);
    final resultCount = find.text('You Win!').evaluate().length +
        find.text('You Lose').evaluate().length;
    expect(resultCount, 1);
    final enabledButton = tester.widget<FilledButton>(
      find.byWidgetPredicate((w) => w is FilledButton),
    );
    expect(enabledButton.onPressed, isNotNull);
  });

  testWidgets('reset returns to total 2 and the sad result', (tester) async {
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(_app());

    await tester.tap(find.text('Roll dice'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    expect(find.text('2'), findsOneWidget);
    expect(find.text('You Lose'), findsOneWidget);
  });
}
