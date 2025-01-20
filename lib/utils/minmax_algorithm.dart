import 'dart:math';

class MinmaxAlgorithm {
  final List<String> originBoard;

  MinmaxAlgorithm({required this.originBoard});

  List<int> emptySpots(List<String> board) {
    List<int> availableSpots = [];
    for (int i = 0; i < board.length; i++) {
      if (board[i] == '') {
        availableSpots.add(i);
      }
    }
    return availableSpots;
  }

  String? _checkWinner(List<String> board) {
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

    for (final List<int> combination in winningCombinations) {
      if (board[combination[0]] != '' &&
          board[combination[0]] == board[combination[1]] &&
          board[combination[0]] == board[combination[2]]) {
        return board[combination[0]];
      }
    }

    return emptySpots(board).isEmpty ? 'Draw' : null;
  }

  int minmax(List<String> board, String player) {
    String? result = _checkWinner(board);
    if (result != null) {
      if (result == 'O') {
        return 10; // AI wins
      } else if (result == 'X') {
        return -10; // Player wins
      } else {
        return 0; // Draw
      }
    }

    List<int> availableSpots = emptySpots(board);
    if (player == 'O') {
      int bestScore = -1000;
      for (int index in availableSpots) {
        board[index] = 'O';
        int score = minmax(board, 'X');
        board[index] = '';
        bestScore = max(bestScore, score);
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int index in availableSpots) {
        board[index] = 'X';
        int score = minmax(board, 'O');
        board[index] = '';
        bestScore = min(bestScore, score);
      }
      return bestScore;
    }
  }
}
