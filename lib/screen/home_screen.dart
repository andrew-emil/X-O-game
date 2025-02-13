import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_constants.dart';
import '../constants/theme_enum.dart';
import '../providers/game/game_provider.dart';
import '../providers/switch_list_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/grid_block.dart';
import '../widgets/last_block.dart';
import 'history_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isSwitchOn = ref.watch(isSwitchedOnProvider);
    bool gameOver = ref.watch(gameProvider).gameOver;
    String activePlayer = ref.watch(gameProvider).activePlayer.toUpperCase();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'XO game',
          style: textTheme.headlineLarge?.copyWith(
            fontFamily: AppConstants.fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Consumer(
            builder: (BuildContext context, WidgetRef ref, _) {
              final themeRef = ref.watch(themeProvider);
              return IconButton(
                onPressed: () async {
                  await ref.read(themeProvider.notifier).toggleTheme();
                },
                icon: Icon(
                  themeRef == ThemeEnum.light
                      ? AppConstants.darkThemeIcon
                      : AppConstants.lightThemeIcon,
                ),
              );
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => HistoryScreen(),
                ),
              );
            },
            icon: Icon(AppConstants.historyIcon),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: MediaQuery.of(context).size.width > 600
              ? Row(
                  children: [
                    ..._largeScreenLayout(
                        context, isSwitchOn, gameOver, ref, activePlayer),
                  ],
                )
              : Column(
                  children: [
                    ..._smallScreenLayout(
                        context, isSwitchOn, gameOver, ref, activePlayer),
                  ],
                ),
        ),
      ),
    );
  }

  List<Widget> _smallScreenLayout(BuildContext context, bool isSwitchOn,
          bool gameOver, WidgetRef ref, String activePlayer) =>
      [
        SwitchListTile.adaptive(
          title: Text(
            'Play with AI',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontFamily: AppConstants.fontFamily,
            ),
          ),
          activeColor: Theme.of(context).colorScheme.onSurface,
          hoverColor: null,
          value: isSwitchOn,
          onChanged: gameOver
              ? null
              : (newVal) {
                  ref.watch(isSwitchedOnProvider.notifier).toggleSwitch();
                },
        ),
        const SizedBox(height: 8),
        Text(
          gameOver ? '' : 'It\'s $activePlayer turn',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontFamily: AppConstants.fontFamily,
          ),
        ),
        Expanded(
          child: AspectRatio(
            aspectRatio: 1.0, // 1:1 aspect ratio (square)
            child: GridBlock(),
          ),
        ),
        const SizedBox(height: 8),
        LastBlock(),
        const SizedBox(height: 16),
      ];

  List<Widget> _largeScreenLayout(BuildContext context, bool isSwitchOn,
          bool gameOver, WidgetRef ref, String activePlayer) =>
      [
        Expanded(
          child: Column(
            children: [
              SwitchListTile.adaptive(
                title: Text(
                  'Play with AI',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: AppConstants.fontFamily,
                  ),
                ),
                activeColor: Theme.of(context).colorScheme.onSurface,
                hoverColor: null,
                value: isSwitchOn,
                onChanged: gameOver
                    ? null
                    : (newVal) {
                        ref.watch(isSwitchedOnProvider.notifier).toggleSwitch();
                      },
              ),
              const SizedBox(height: 8),
              LastBlock(),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                gameOver ? '' : 'It\'s $activePlayer turn',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: AppConstants.fontFamily,
                ),
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: GridBlock(),
                ),
              ),
            ],
          ),
        ),
      ];
}
