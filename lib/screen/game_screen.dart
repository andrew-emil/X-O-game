import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../providers/history/history_state.dart';
import '../widgets/game_preview.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.gameHistoryState,
  });
  final HistoryState gameHistoryState;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    List<String> moves = widget.gameHistoryState.moves;
    int blockIndex = int.parse(moves[index][1]) + 1;
    String currentPlayer = moves[index][0];

    void previousMove() {
      setState(() {
        if (index > 0) index--;
      });
    }

    void nextMove() {
      setState(() {
        if (index < moves.length - 1) index++;
        log(blockIndex.toString());
        log(currentPlayer);
        log(moves[index]);
      });
    }

    return Scaffold(
      appBar: AppBar(
        elevation: Theme.of(context).appBarTheme.elevation,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        centerTitle: true,
        title: Text(
          'Game',
          style: TextStyle(
            fontSize: 20,
            fontFamily: AppConstants.fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Text(
              '${widget.gameHistoryState.winner} is the Winner',
              style: TextStyle(
                fontSize: 18,
                fontFamily: AppConstants.fontFamily,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GamePreview(
                gameMoves: moves,
                gameIndex: index,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Player $currentPlayer plays in block $blockIndex',
              style: TextStyle(
                fontFamily: AppConstants.fontFamily,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: index <= 0 ? null : previousMove,
                  icon: Platform.isIOS
                      ? Icon(Icons.arrow_back_ios_new)
                      : Icon(Icons.arrow_back),
                  color: Theme.of(context).colorScheme.shadow,
                ),
                const SizedBox(
                  width: 5,
                ),
                IconButton(
                  onPressed: index >= moves.length - 1 ? null : nextMove,
                  icon: Platform.isIOS
                      ? Icon(Icons.arrow_forward_ios)
                      : Icon(Icons.arrow_forward),
                  color: Theme.of(context).colorScheme.shadow,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
