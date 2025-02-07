class GameState {
  static const x = 'X';
  static const o = 'O';
  static const empty = '';

  List<int> playerX;
  List<int> playerO;
  List<int> winningIndices;
  List<String> board;
  String activePlayer;
  int turns;
  bool gameOver;

  GameState({
    this.playerX = const [],
    this.playerO = const [],
    this.winningIndices = const [],
    this.board = const ['', '', '', '', '', '', '', '', ''],
    this.activePlayer = x,
    this.turns = 0,
    this.gameOver = false,
  });

  GameState copyWith({
    List<int>? playerX,
    List<int>? playerO,
    List<int>? winningIndices,
    List<String>? board,
    String? activePlayer,
    int? turns,
    bool? gameOver,
  }) {
    return GameState(
      playerX: playerX ?? this.playerX,
      playerO: playerO ?? this.playerO,
      winningIndices: winningIndices ?? this.winningIndices,
      board: board ?? this.board,
      activePlayer: activePlayer ?? this.activePlayer,
      turns: turns ?? this.turns,
      gameOver: gameOver ?? this.gameOver,
      
    );
  }

  List<int> get getWinningIndices {
    return winningIndices;
  }

  set setWinningIndices(List<int> newIndices) {
    winningIndices = newIndices;
  }
}

extension ContainsAll on List {
  bool containsAll(int x, int y, [z]) {
    if (z == null) return contains(x) && contains(y);

    return contains(x) && contains(y) && contains(z);
  }
}
