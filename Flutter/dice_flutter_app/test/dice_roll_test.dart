import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:dice_challenge/models/dice_roll.dart';

void main() {
  group('DiceRoll', () {
    test('calculates the total of both dice', () {
      const roll = DiceRoll(firstDie: 3, secondDie: 4);
      expect(roll.total, 7);
    });

    test('treats a total of 10 as a win', () {
      const roll = DiceRoll(firstDie: 4, secondDie: 6);
      expect(roll.isWin, isTrue);
      expect(roll.imagePath, DiceRoll.happyAsset);
      expect(roll.resultTitle, 'You Win!');
    });

    test('treats totals above 10 as wins', () {
      const roll = DiceRoll(firstDie: 5, secondDie: 6);
      expect(roll.isWin, isTrue);
    });

    test('shows the sad state for totals below 10', () {
      const roll = DiceRoll(firstDie: 2, secondDie: 5);
      expect(roll.isWin, isFalse);
      expect(roll.imagePath, DiceRoll.sadAsset);
      expect(roll.resultTitle, 'You Lose');
    });

    test('generates two valid six-sided dice', () {
      final random = Random(42);
      for (var i = 0; i < 100; i++) {
        final roll = DiceRoll.random(random);
        expect(roll.firstDie, inInclusiveRange(1, 6));
        expect(roll.secondDie, inInclusiveRange(1, 6));
      }
    });
  });
}
