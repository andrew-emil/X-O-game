import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/minmax_algorithm.dart';
import 'game_state.dart';

class GameProvider extends StateNotifier<GameState> {
  GameProvider() : super(GameState());

  set setGameOver(bool setGameOver) {
    state.gameOver = setGameOver;
  }

  void playGame(int index, String activePlayer) {
    if (activePlayer == 'X') {
      state = state.copyWith(
        playerX: [...state.playerX, index],
        board: [...state.board]..[index] = 'X',
      );
    } else {
      state = state.copyWith(
        playerO: [...state.playerO, index],
        board: [...state.board]..[index] = 'O',
      );
    }
  }

  String checkWinner() {
    List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (List<int> combination in winningCombinations) {
      if (state.playerX
          .containsAll(combination[0], combination[1], combination[2])) {
        state.winningIndices = combination;
        
        return 'X';
      } else if (state.playerO
          .containsAll(combination[0], combination[1], combination[2])) {
        state.winningIndices = combination;
        
        return 'O';
      }
    }

    state.winningIndices = [];
    return '';
  }

  int getBestMove() {
    MinmaxAlgorithm minmax = MinmaxAlgorithm(originBoard: state.board);

    // Get all empty spots once to avoid redundant checks
    List<int> availableSpots = minmax.emptySpots(state.board);

    for (int spot in availableSpots) {
      final List<String> tempBoard = List.from(state.board);
      tempBoard[spot] = 'O';
      if (minmax.checkWin(tempBoard, [0, 1, 2], 'O') ||
          minmax.checkWin(tempBoard, [3, 4, 5], 'O') ||
          minmax.checkWin(tempBoard, [6, 7, 8], 'O') ||
          minmax.checkWin(tempBoard, [0, 3, 6], 'O') ||
          minmax.checkWin(tempBoard, [1, 4, 7], 'O') ||
          minmax.checkWin(tempBoard, [2, 5, 8], 'O') ||
          minmax.checkWin(tempBoard, [0, 4, 8], 'O') ||
          minmax.checkWin(tempBoard, [2, 4, 6], 'O')) {
        return spot; // Win immediately
      }

      tempBoard[spot] = 'X'; // Check for opponent's win
      if (minmax.checkWin(tempBoard, [0, 1, 2], 'X') ||
          minmax.checkWin(tempBoard, [3, 4, 5], 'X') ||
          minmax.checkWin(tempBoard, [6, 7, 8], 'X') ||
          minmax.checkWin(tempBoard, [0, 3, 6], 'X') ||
          minmax.checkWin(tempBoard, [1, 4, 7], 'X') ||
          minmax.checkWin(tempBoard, [2, 5, 8], 'X') ||
          minmax.checkWin(tempBoard, [0, 4, 8], 'X') ||
          minmax.checkWin(tempBoard, [2, 4, 6], 'X')) {
        return spot; // Block opponent's win
      }
    }
    // 2. Weighted Randomness:
    int bestMove = -1;
    double bestScore = -double.infinity; // Initialize to negative infinity
    final scores = <int, double>{};

    for (int spot in availableSpots) {
      final List<String> tempBoard = List.from(state.board);
      tempBoard[spot] = 'O';
      final score = minmax.minmax(tempBoard, 'X');
      scores[spot] = score.toDouble(); // Store the minimax score

      if (score > bestScore) {
        bestScore = score.toDouble();
        bestMove = spot;
      }
    }

    final random = Random();
    double totalWeight = 0;
    for (final score in scores.values) {
      totalWeight += (score + 10); // adding 10 to make all weights positive
    }

    double randomNumber = random.nextDouble() * totalWeight;
    double cumulativeWeight = 0;

    for (int spot in availableSpots) {
      double weight =
          scores[spot]! + 10; // adding 10 to make all weights positive
      cumulativeWeight += weight;
      if (randomNumber < cumulativeWeight) {
        return spot;
      }
    }

    return bestMove;
  }

  void incrementTurns(int turns) {
    state = state.copyWith(turns: ++turns);
  }

  void togglePlayer(String player) {
    state = state.copyWith(
      activePlayer: player == 'X' ? 'O' : 'X',
    );
  }

  void restartGame() {
    state = state.copyWith(
      playerO: [],
      playerX: [],
      winningIndices: [],
      board: ['', '', '', '', '', '', '', '', ''],
      turns: 0,
      activePlayer: 'X',
      gameOver: false,
    );
  }
}

final gameProvider = StateNotifierProvider<GameProvider, GameState>(
  (_) => GameProvider(),
);
