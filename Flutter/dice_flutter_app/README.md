# Dice Challenge 🎲

A polished, dark-themed Flutter mini-game. Roll two six-sided dice: totals of **10 or more** show the happy result and `You Win!`; lower totals show the sad result and `You Lose`.

## Features

- Material 3 dark theme with a cohesive violet palette.
- Real dice faces drawn with pips (1–6), with animated face changes.
- Tumbling roll animation with haptic feedback; the result is revealed only when the roll finishes.
- Session stats: wins, losses, and best win streak.
- Roll button is disabled while rolling, so taps can't overlap.
- Animated score and win/loss result transitions.
- Responsive layout with scroll support on smaller screens.
- Local happy/sad PNG assets; no network access or third-party runtime packages.
- Unit and widget tests for game rules, stats, and the roll/reset flow.

## Project structure

```text
dice_flutter_app/
├── assets/
│   ├── happy.png
│   └── sad.png
├── lib/
│   ├── main.dart
│   ├── dice.dart
│   ├── models/
│   │   ├── dice_roll.dart
│   │   └── game_stats.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── widgets/
│       └── result_panel.dart
├── test/
│   ├── dice_roll_test.dart
│   ├── game_stats_test.dart
│   └── widget_test.dart
├── analysis_options.yaml
├── pubspec.yaml
└── README.md
```

## Run the app

1. Install the Flutter SDK and configure an emulator or connect a device.
2. Open a terminal in this project directory.
3. This archive contains only the Dart sources, so generate the platform folders once, then run:

   ```bash
   flutter create .
   flutter pub get
   flutter run
   ```

## Run tests

```bash
flutter test
```

## Game rules

- Each die produces a random integer from 1 to 6.
- **Win:** total is greater than or equal to 10.
- **Lose:** total is less than 10.
- **Reset:** both dice return to 1, total returns to 2, the sad result is shown, and session stats are cleared.

## Code organization

- `main.dart`: app entry point, screen state, roll animation, and page layout.
- `dice.dart`: reusable die widget, taking `value` (1–6) through its constructor.
- `models/dice_roll.dart`: dice-roll values, total, win condition, asset path, and display copy.
- `models/game_stats.dart`: immutable win/loss/streak statistics.
- `theme/app_theme.dart`: centralized colors and Material theme.
- `widgets/result_panel.dart`: animated result (or "rolling") state and feedback text.
