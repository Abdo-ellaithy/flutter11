import 'package:flutter/material.dart';

import '../models/dice_roll.dart';
import '../theme/app_theme.dart';

class ResultPanel extends StatelessWidget {
  const ResultPanel({super.key, required this.roll, this.isRolling = false});

  final DiceRoll roll;

  /// While true, the panel shows a neutral "rolling" state instead of the
  /// win/lose result so the outcome is not revealed early.
  final bool isRolling;

  @override
  Widget build(BuildContext context) {
    final resultColor = isRolling
        ? AppColors.primary
        : (roll.isWin ? AppColors.success : AppColors.danger);
    final stateKey = isRolling ? 2 : (roll.isWin ? 1 : 0);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 20),
      decoration: BoxDecoration(
        color: AppColors.surface.withAlpha(224),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: resultColor.withAlpha(64), width: 1.2),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.94, end: 1).animate(animation),
            child: child,
          ),
        ),
        child: Column(
          key: ValueKey<int>(stateKey),
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 176,
              height: 176,
              child: isRolling
                  ? const Icon(
                      Icons.casino_rounded,
                      size: 96,
                      color: AppColors.primaryBright,
                      semanticLabel: 'Rolling dice',
                    )
                  : Image.asset(
                      roll.imagePath,
                      fit: BoxFit.contain,
                      semanticLabel: roll.isWin ? 'Happy face' : 'Sad face',
                    ),
            ),
            const SizedBox(height: 6),
            Semantics(
              liveRegion: true,
              child: Text(
                isRolling ? 'Rolling…' : roll.resultTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: resultColor,
                      fontSize: 25,
                    ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              isRolling ? 'Fingers crossed…' : roll.resultMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.mutedText,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
