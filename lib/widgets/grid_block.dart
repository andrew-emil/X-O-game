import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_constants.dart';
import '../providers/game/game_provider.dart';
import '../providers/game/game_state.dart';
import '../providers/history/history_provider.dart';
import '../providers/history/history_state.dart';
import '../providers/switch_list_provider.dart';

class GridBlock extends ConsumerWidget {
  const GridBlock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GameState game = ref.watch(gameProvider); // Keep this for UI updates
    final GameProvider gameRef =
        ref.read(gameProvider.notifier); // Use ref.read for direct actions
    final SwitchListProvider switchNotifier =
        ref.read(isSwitchedOnProvider.notifier);
    final historyNotifier = ref.read(historyProvider.notifier);

    // Listen to game state changes
    ref.listen<GameState>(gameProvider, (previous, next) {
      if (_shouldTriggerAI(next, previous, switchNotifier)) {
        // If it's AI's turn, make a move
        Future.delayed(Duration.zero, () {
          int aiIndex = gameRef.getBestMove();
          gameRef.playGame(aiIndex, next.activePlayer);
          _updateGameState(next, gameRef, historyNotifier, aiIndex);
        });
      }
    });

    return Expanded(
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8.0,
        childAspectRatio: 1.0,
        padding: const EdgeInsets.all(8),
        children: List.generate(
          9,
          (index) => GestureDetector(
            onTap: game.gameOver
                ? null
                : () => _handleClick(
                    index, game, gameRef, switchNotifier, historyNotifier),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              decoration: BoxDecoration(
                color: game.getWinningIndices.contains(index)
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Theme.of(context).colorScheme.shadow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  game.playerX.contains(index)
                      ? 'X'
                      : game.playerO.contains(index)
                          ? 'O'
                          : '',
                  style: TextStyle(
                    fontSize: 52,
                    fontFamily: AppConstants.fontFamily,
                    fontWeight: FontWeight.bold,
                    color: game.playerX.contains(index)
                        ? Theme.of(context).colorScheme.tertiary
                        : Theme.of(context).colorScheme.secondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _shouldTriggerAI(
      GameState next, GameState? previous, SwitchListProvider switchNotifier) {
    return !next.gameOver &&
        switchNotifier.isSwitchedOn &&
        next.activePlayer == 'O' &&
        previous?.activePlayer != next.activePlayer &&
        next.turns < 9;
  }

  void _handleClick(int index, GameState game, GameProvider ref,
      SwitchListProvider switchProvider, HistoryProvider notifier) {
    // Human player move
    if ((game.playerO.isEmpty || !game.playerO.contains(index)) &&
        (game.playerX.isEmpty || !game.playerX.contains(index))) {
      ref.playGame(index, game.activePlayer);
      _updateGameState(game, ref, notifier, index);
    }
  }

  void _updateGameState(GameState game, GameProvider ref,
      HistoryProvider notifier, int lastMoveIndex) {
    // Increment the turn count
    ref.incrementTurns(game.turns);

    // Check if the game is over
    if (game.turns >= 4) {
      String winner = ref.checkWinner();
      if (winner == 'X' || winner == 'O' || game.turns == 9) {
        ref.setGameOver = true;
        int index = max(game.playerO.length, game.playerX.length);
        List<String> moves = [];
        for (int i = 0; i < index; i++) {
          if (i < game.playerX.length) {
            moves.add('X${game.playerX[i]}');
          }
          if (i < game.playerO.length) {
            moves.add('O${game.playerO[i]}');
          }
        }
        moves.add('$winner$lastMoveIndex');

        final gameHistory = HistoryState(
          winner: winner,
          moves: moves,
          date: DateTime.now().toIso8601String(),
        );
        notifier.addGame(gameHistory);
        return;
      }
    }

    // Toggle the player if the game is not over
    if (!game.gameOver) {
      ref.togglePlayer(game.activePlayer);
    }
  }
}
