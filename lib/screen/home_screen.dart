import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_o_game/screen/history_screen.dart';

import '../constants/app_constants.dart';
import '../constants/theme_enum.dart';
import '../providers/game/game_provider.dart';
import '../providers/switch_list_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/grid_block.dart';
import '../widgets/last_block.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isSwitchOn = ref.watch(isSwitchedOnProvider);
    bool gameOver = ref.watch(gameProvider).gameOver;
    String activePlayer = ref.watch(gameProvider).activePlayer.toUpperCase();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'XO game',
          style: TextStyle(
            fontFamily: AppConstants.fontFamily,
            fontSize: 20,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SwitchListTile.adaptive(
              title: Text(
                'Turn on/off Two Players',
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
            const SizedBox(
              height: 8,
            ),
            Text(
              gameOver ? '' : 'It\'s $activePlayer turn',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontFamily: AppConstants.fontFamily,
              ),
            ),
            GridBlock(),
            LastBlock(),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
