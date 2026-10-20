import 'dart:math';

/// The outcome of rolling two standard six-sided dice.
///
/// A total of [winningScore] or higher is considered a win.
class DiceRoll {
  const DiceRoll({
    required this.firstDie,
    required this.secondDie,
  })  : assert(firstDie >= 1 && firstDie <= 6),
        assert(secondDie >= 1 && secondDie <= 6);

  static const int winningScore = 10;
  static const String happyAsset = 'assets/happy.png';
  static const String sadAsset = 'assets/sad.png';

  final int firstDie;
  final int secondDie;

  int get total => firstDie + secondDie;

  bool get isWin => total >= winningScore;

  String get imagePath => isWin ? happyAsset : sadAsset;

  String get resultTitle => isWin ? 'You Win!' : 'You Lose';

  String get resultMessage => isWin
      ? 'Fantastic roll! You reached $winningScore or more.'
      : 'Not this time. Give it another roll!';

  factory DiceRoll.random(Random random) {
    return DiceRoll(
      firstDie: random.nextInt(6) + 1,
      secondDie: random.nextInt(6) + 1,
    );
  }
}
