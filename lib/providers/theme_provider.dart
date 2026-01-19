import 'package:riverpod/legacy.dart';

import '../core/utils/storage_service.dart';

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(StorageService.getThemeMode());

  void toggleTheme() {
    state = !state;
    StorageService.saveThemeMode(state);
  }

  void setTheme(bool isDark) {
    state = isDark;
    StorageService.saveThemeMode(isDark);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>(
  (ref) => ThemeNotifier(),
);
