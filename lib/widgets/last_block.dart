import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_o_game/constants/app_constants.dart';
import 'package:x_o_game/constants/theme_enum.dart';
import 'package:x_o_game/providers/game/game_provider.dart';
import 'package:x_o_game/providers/theme_provider.dart';

class LastBlock extends ConsumerWidget {
  const LastBlock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String result = ref.read(gameProvider.notifier).checkWinner();
    ThemeEnum theme = ref.read(themeProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          result != '' ? '$result is The Winner' : result,
          style: TextStyle(
            fontFamily: AppConstants.fontFamily,
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          padding: EdgeInsets.only(bottom: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.zero),
          ),
          child: ElevatedButton.icon(
            onPressed: () => ref.watch(gameProvider.notifier).restartGame(),
            icon: Icon(
              Icons.replay,
              color:
                  theme == ThemeEnum.dark ? Colors.white : Colors.grey.shade900,
            ),
            label: Text(
              'Restart the Game',
              style: TextStyle(
                fontSize: 18,
                color: theme == ThemeEnum.dark
                    ? Colors.white
                    : Colors.grey.shade900,
                fontWeight: FontWeight.w500,
                fontFamily: AppConstants.fontFamily,
              ),
            ),
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              backgroundColor: Theme.of(context).splashColor,
              padding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
}
