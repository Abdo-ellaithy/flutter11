import 'dart:math';

import 'dice_roll.dart';

/// Immutable session statistics, updated one roll at a time.
class GameStats {
  const GameStats({
    this.wins = 0,
    this.losses = 0,
    this.streak = 0,
    this.bestStreak = 0,
  });

  final int wins;
  final int losses;

  /// Current run of consecutive wins.
  final int streak;

  /// Longest run of consecutive wins in this session.
  final int bestStreak;

  int get rolls => wins + losses;

  GameStats record(DiceRoll roll) {
    if (roll.isWin) {
      final nextStreak = streak + 1;
      return GameStats(
        wins: wins + 1,
        losses: losses,
        streak: nextStreak,
        bestStreak: max(bestStreak, nextStreak),
      );
    }
    return GameStats(
      wins: wins,
      losses: losses + 1,
      streak: 0,
      bestStreak: bestStreak,
    );
  }
}
