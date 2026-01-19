import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warframetools/void_relics.dart';
import '../constants/app_constants.dart';
import '../../models/relic_item.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Theme persistence
  static Future<void> saveThemeMode(bool isDark) async {
    await _prefs?.setBool(AppConstants.themeKey, isDark);
  }

  static bool getThemeMode() {
    return _prefs?.getBool(AppConstants.themeKey) ?? false;
  }

  // Relic data persistence
  static Future<void> saveRelicData(List<RelicItem> items) async {
    final jsonList = items.map((item) => item.toJson()).toList();
    await _prefs?.setString(AppConstants.relicDataKey, jsonEncode(jsonList));
  }

  static List<RelicItem> getDefaultRelicData() {
    return allRelics;
  }

  // Relic update frequency
  static const String _relicUpdateFrequencyKey = 'relic_update_frequency';

  static Future<void> setRelicUpdateFrequency(String frequency) async {
    await _prefs?.setString(_relicUpdateFrequencyKey, frequency);
  }

  static String getRelicUpdateFrequency() {
    return _prefs?.getString(_relicUpdateFrequencyKey) ?? 'never';
  }
}
