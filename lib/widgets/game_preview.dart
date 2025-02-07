import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class GamePreview extends StatelessWidget {
  const GamePreview({
    super.key,
    required this.gameMoves,
    required this.gameIndex,
  });

  final List<String> gameMoves;
  final int gameIndex;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8.0,
      childAspectRatio: 1.0,
      padding: const EdgeInsets.all(8),
      children: List.generate(
        9,
        (index) {
          final move = gameMoves.take(gameIndex + 1).firstWhere(
                (element) => element.substring(1) == index.toString(),
                orElse: () => '',
              );
          final symbol = move.isNotEmpty ? move[0] : '';

          return LayoutBuilder(
            builder: (context, constraints) => AnimatedContainer(
                duration: Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.shadow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    symbol,
                    style: TextStyle(
                      fontSize: constraints.maxWidth * 0.5,
                      fontFamily: AppConstants.fontFamily,
                      fontWeight: FontWeight.bold,
                      color: symbol == 'X'
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
        },
      ),
    );
  }
}
