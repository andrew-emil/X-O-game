import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_o_game/providers/history/history_state.dart';

class HistoryProvider extends StateNotifier<List<HistoryState>> {
  HistoryProvider() : super([]) {
    _loadHistory();
  }

  static const _historyKey = 'gameHistory';

  // Load history from SharedPreferences
  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(_historyKey) ?? [];
    state = historyJson
        .map((json) => HistoryState.fromMap(jsonDecode(json)))
        .toList();
  }

  // Add a new game to the history
  Future<void> addGame(HistoryState game) async {
    state = [...state, game];
    await _saveToPreferences();
  }

  Future<void> removeGame(int index) async {
    List<HistoryState> updatedHistoryList = state.toList();
    updatedHistoryList.removeAt(index);
    state = updatedHistoryList;
    await _saveToPreferences();
  }

  // Clear the history
  Future<void> clearHistory() async {
    state = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  // Save history to SharedPreferences
  Future<void> _saveToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = state.map((game) => jsonEncode(game.toMap())).toList();
    await prefs.setStringList(_historyKey, historyJson);
  }

  String timeAgo(String timestamp) {
    try {
      final DateTime dateTime = DateTime.parse(timestamp);
      final Duration difference = DateTime.now().difference(dateTime);

      if (difference.inDays > 0) {
        return "${difference.inDays}d ${difference.inHours % 24}h ago";
      } else if (difference.inHours > 0) {
        return "${difference.inHours}h ${difference.inMinutes % 60}m ago";
      } else if (difference.inMinutes > 0) {
        return "${difference.inMinutes}m ${difference.inSeconds % 60}s ago";
      } else {
        return "${difference.inSeconds}s ago";
      }
    } catch (e) {
      return "Invalid date";
    }
  }
}

final historyProvider =
    StateNotifierProvider<HistoryProvider, List<HistoryState>>(
  (_) => HistoryProvider(),
);
