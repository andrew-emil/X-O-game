import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';
import '../providers/history/history_provider.dart';
import '../providers/history/history_state.dart';
import 'game_screen.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<HistoryState> historyList =
        ref.watch(historyProvider).reversed.toList();

    return Scaffold(
      appBar: AppBar(
        elevation: Theme.of(context).appBarTheme.elevation,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        centerTitle: true,
        title: Text(
          'History',
          style: TextStyle(
            fontSize: 20,
            fontFamily: AppConstants.fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: historyList.isEmpty
                ? null
                : () => _showDialog(
                      context,
                      ref,
                      null,
                      'Delete History',
                      'Are you sure you want to delete the history?',
                      false,
                    ),
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: historyList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_toggle_off,
                    size: 100,
                    color: Theme.of(context)
                        .colorScheme
                        .shadow
                        .withValues(alpha: .5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No games played yet!",
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: .7),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: historyList.length,
              itemBuilder: (ctx, index) {
                final game = historyList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Theme.of(context).colorScheme.surface,
                  shadowColor: Theme.of(context).colorScheme.shadow,
                  elevation: 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        game.winner == '' ? '' : game.winner.substring(0, 1),
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    title: Text(
                      game.winner == '' ? 'Draw' : 'Winner: ${game.winner}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Moves: ${game.moves.join(', ')}"),
                        const SizedBox(height: 4),
                        Text(
                          ref.read(historyProvider.notifier).timeAgo(game.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.replay_outlined,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => GameScreen(
                                    gameHistoryState: historyList[index]),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          onPressed: () => _showDialog(
                            context,
                            ref,
                            index,
                            'Delete Game',
                            'Are you sure you want to delete this game?',
                            true,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<dynamic> _showDialog(BuildContext context, WidgetRef ref, int? index,
      String title, String content, bool isOneGame) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(
          content,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
            ),
          ),
          TextButton(
            onPressed: () async {
              isOneGame && index != null
                  ? ref.read(historyProvider.notifier).removeGame(index)
                  : await ref.watch(historyProvider.notifier).clearHistory();
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
