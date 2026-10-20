import 'package:flutter_test/flutter_test.dart';
import 'package:dice_challenge/models/dice_roll.dart';
import 'package:dice_challenge/models/game_stats.dart';

void main() {
  const win = DiceRoll(firstDie: 5, secondDie: 5);
  const lose = DiceRoll(firstDie: 1, secondDie: 2);

  group('GameStats', () {
    test('starts empty', () {
      const stats = GameStats();
      expect(stats.rolls, 0);
      expect(stats.bestStreak, 0);
    });

    test('counts wins, losses, and total rolls', () {
      final stats = const GameStats().record(win).record(lose).record(win);
      expect(stats.wins, 2);
      expect(stats.losses, 1);
      expect(stats.rolls, 3);
    });

    test('tracks the current and best win streak', () {
      var stats = const GameStats().record(win).record(win).record(win);
      expect(stats.streak, 3);
      expect(stats.bestStreak, 3);

      stats = stats.record(lose);
      expect(stats.streak, 0);
      expect(stats.bestStreak, 3);

      stats = stats.record(win);
      expect(stats.streak, 1);
      expect(stats.bestStreak, 3);
    });
  });
}
