class HistoryState {
  final String winner;
  final List<String> moves;
  final String date;

  HistoryState({
    required this.winner,
    required this.moves,
    required this.date,
  });

  // Convert to Map for saving
  Map<String, dynamic> toMap() {
    return {'winner': winner, 'moves': moves, 'date': date};
  }

  // Create a Game instance from a Map
  factory HistoryState.fromMap(Map<String, dynamic> map) {
    return HistoryState(
      winner: map['winner'],
      moves: List<String>.from(map['moves']),
      date: map['date'],
    );
  }
}
