import 'package:flutter_riverpod/flutter_riverpod.dart';

class SwitchListProvider extends StateNotifier<bool> {
  SwitchListProvider(super.state);

  void toggleSwitch() {
    state = !state;
  }

  bool get isSwitchedOn => state;
}

final isSwitchedOnProvider = StateNotifierProvider<SwitchListProvider, bool>(
  (_) => SwitchListProvider(false),
);
