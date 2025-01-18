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
    int bestScore = -1000;
    int bestMove = -1;

    // Get all empty spots once to avoid redundant checks
    List<int> availableSpots = minmax.emptySpots(state.board);

    for (int i in availableSpots) {
      // Clone the board and make the move
      List<String> tempBoard = List.from(state.board);
      tempBoard[i] = 'O';

      // Use minmax to evaluate the move
      int score = minmax.minmax(tempBoard, "X");

      // Update the best score and move if this move is better
      if (score > bestScore) {
        bestScore = score;
        bestMove = i;
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
