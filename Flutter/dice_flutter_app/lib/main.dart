import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dice.dart';
import 'models/dice_roll.dart';
import 'models/game_stats.dart';
import 'theme/app_theme.dart';
import 'widgets/result_panel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dice Challenge',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const DiceScreen(),
    );
  }
}

class DiceScreen extends StatefulWidget {
  const DiceScreen({
    super.key,
    this.random,
    this.rollDuration = const Duration(milliseconds: 720),
  });

  /// Source of the real result. Injectable so tests are deterministic.
  final Random? random;

  /// How long the tumbling animation lasts before the result is revealed.
  final Duration rollDuration;

  @override
  State<DiceScreen> createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen> {
  static const Duration _tick = Duration(milliseconds: 90);
  static const DiceRoll _initialRoll = DiceRoll(firstDie: 1, secondDie: 1);

  late final Random _random = widget.random ?? Random();
  // Only used for the cosmetic tumble, so it never affects the real result.
  final Random _tumble = Random();

  Timer? _timer;
  bool _rolling = false;
  DiceRoll _roll = _initialRoll;
  GameStats _stats = const GameStats();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _rollDice() {
    if (_rolling) return;

    // Decide the outcome up front; the animation is purely visual.
    final result = DiceRoll.random(_random);
    final ticks = max(1, widget.rollDuration.inMilliseconds ~/ _tick.inMilliseconds);
    var elapsed = 0;

    HapticFeedback.lightImpact();
    setState(() => _rolling = true);

    _timer = Timer.periodic(_tick, (timer) {
      elapsed++;
      if (elapsed >= ticks) {
        timer.cancel();
        _timer = null;
        HapticFeedback.mediumImpact();
        setState(() {
          _rolling = false;
          _roll = result;
          _stats = _stats.record(result);
        });
      } else {
        setState(() => _roll = DiceRoll.random(_tumble));
      }
    });
  }

  void _resetDice() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _rolling = false;
      _roll = _initialRoll;
      _stats = const GameStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.casino_rounded, size: 27),
        title: const Text(
          'Dice Challenge',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.3),
        ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF17172A), AppColors.background],
            stops: [0, 0.65],
          ),
        ),
        child: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: max(0, constraints.maxHeight - 38),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _ScoreHeader(total: _rolling ? null : _roll.total),
                          const SizedBox(height: 16),
                          ResultPanel(roll: _roll, isRolling: _rolling),
                          const SizedBox(height: 22),
                          const _SectionLabel(label: 'YOUR DICE'),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Center(child: Dice(value: _roll.firstDie)),
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Center(child: Dice(value: _roll.secondDie)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: _rolling ? null : _rollDice,
                                  icon: const Icon(Icons.casino_rounded),
                                  label: const Text('Roll dice'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _resetDice,
                                  icon: const Icon(Icons.refresh_rounded),
                                  label: const Text('Reset'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _StatsRow(stats: _stats),
                          const SizedBox(height: 16),
                          const Text(
                            'Reach a total of 10 or more to win',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.mutedText,
                              fontSize: 12,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ScoreHeader extends StatelessWidget {
  const _ScoreHeader({required this.total});

  /// `null` while the dice are still rolling.
  final int? total;

  @override
  Widget build(BuildContext context) {
    final label = total?.toString() ?? '?';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TOTAL SCORE',
                  style: TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 2),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  transitionBuilder: (child, animation) => SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.25),
                      end: Offset.zero,
                    ).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                  child: Text(
                    label,
                    key: ValueKey<String>(label),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 34,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(31),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.primary.withAlpha(89)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.flag_rounded, size: 15, color: AppColors.primaryBright),
                SizedBox(width: 6),
                Text(
                  'TARGET 10+',
                  style: TextStyle(
                    color: AppColors.primaryBright,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});

  final GameStats stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            label: 'WINS',
            value: '${stats.wins}',
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatTile(
            label: 'LOSSES',
            value: '${stats.losses}',
            color: AppColors.danger,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatTile(
            label: 'BEST STREAK',
            value: '${stats.bestStreak}',
            color: AppColors.primaryBright,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.mutedText,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.mutedText,
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.7,
      ),
    );
  }
}
