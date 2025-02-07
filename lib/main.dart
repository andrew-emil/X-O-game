import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constants/app_theme.dart';
import 'constants/theme_enum.dart';
import 'providers/theme_provider.dart';
import 'screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    return MaterialApp(
      title: 'XO Champ',
      debugShowCheckedModeBanner: false,
      theme: themeState == ThemeEnum.light
          ? AppTheme.lightTheme
          : AppTheme.darkTheme,
      home: HomeScreen(),
    );
  }
}
