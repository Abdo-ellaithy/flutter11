import 'package:flutter/material.dart';

import 'theme/app_theme.dart';

/// A styled, animated six-sided die drawn with real pips.
class Dice extends StatelessWidget {
  const Dice({super.key, required this.value})
      : assert(value >= 1 && value <= 6);

  final int value;

  static const double _size = 112;
  static const double _pipSize = 17;

  static const Map<int, List<Alignment>> _pips = {
    1: [Alignment.center],
    2: [Alignment.topLeft, Alignment.bottomRight],
    3: [Alignment.topLeft, Alignment.center, Alignment.bottomRight],
    4: [
      Alignment.topLeft,
      Alignment.topRight,
      Alignment.bottomLeft,
      Alignment.bottomRight,
    ],
    5: [
      Alignment.topLeft,
      Alignment.topRight,
      Alignment.center,
      Alignment.bottomLeft,
      Alignment.bottomRight,
    ],
    6: [
      Alignment.topLeft,
      Alignment.topRight,
      Alignment.centerLeft,
      Alignment.centerRight,
      Alignment.bottomLeft,
      Alignment.bottomRight,
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Die showing $value',
      excludeSemantics: true,
      child: Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF292943), AppColors.surfaceElevated],
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.border, width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 22,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          switchInCurve: Curves.easeOutBack,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            final rotation = Tween<double>(begin: -0.08, end: 0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            );
            return RotationTransition(
              turns: rotation,
              child: ScaleTransition(scale: animation, child: child),
            );
          },
          child: _Face(key: ValueKey<int>(value), pips: _pips[value]!),
        ),
      ),
    );
  }
}

class _Face extends StatelessWidget {
  const _Face({super.key, required this.pips});

  final List<Alignment> pips;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Stack(
        children: [
          for (final alignment in pips)
            Align(
              alignment: alignment,
              child: Container(
                width: Dice._pipSize,
                height: Dice._pipSize,
                decoration: const BoxDecoration(
                  color: AppColors.primaryBright,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Color(0x669B8CFF), blurRadius: 8),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
