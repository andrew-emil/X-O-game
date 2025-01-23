import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/game/game_provider.dart';
import '../constants/app_constants.dart';

final winnerTextProvider = Provider<String>((ref) {
  final winner = ref.read(gameProvider.notifier).checkWinner();
  return winner != '' ? 'Player $winner is The Winner' : '';
});

final drawTextProvider = Provider<String>((ref) {
  final game = ref.watch(gameProvider);
  return game.turns == 9 ? 'Draw' : '';
});

class LastBlock extends ConsumerWidget {
  const LastBlock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final winnerText = ref.watch(winnerTextProvider);
    final drawText = ref.watch(drawTextProvider);
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          winnerText.isNotEmpty ? winnerText : drawText,
          style: TextStyle(
            fontFamily: AppConstants.fontFamily,
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5),
        ElevatedButton.icon(
          onPressed: () => ref.read(gameProvider.notifier).restartGame(),
          icon: Icon(
            Icons.replay,
            color: theme.brightness == Brightness.dark
                ? Colors.white
                : Colors.grey.shade900,
          ),
          label: Text(
            'Restart the Game',
            style: TextStyle(
              fontSize: 18,
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.grey.shade900,
              fontWeight: FontWeight.w500,
              fontFamily: AppConstants.fontFamily,
            ),
          ),
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            backgroundColor: theme.splashColor,
            padding: const EdgeInsets.all(14),
          ),
        ),
      ],
    );
  }
}
