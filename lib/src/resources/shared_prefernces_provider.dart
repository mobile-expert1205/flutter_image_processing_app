import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordfinderx/src/models/user_preferences_model.dart';
import 'package:wordfinderx/src/resources/resources.dart';

/// This class implements local storing and fetching user's preferences.
class SharedPreferencesProvider implements PreferencesProvider {
  /// Key to store values inside local shared preferences.
  static const String _userPreferencesKey = 'userPreferences';

  /// Static instance to implement singleton.
  static final SharedPreferencesProvider _instance =
      SharedPreferencesProvider._internal();

  /// Private constructor.
  SharedPreferencesProvider._internal();

  /// Factory to provide singleton.
  factory SharedPreferencesProvider() => _instance;

  /// Disposes all allocated resources.
  @override
  void dispose() {}

  /// Returns stored user's preferences.
  @override
  Future<UserPreferencesModel> getPreferences() async {
    String? prefString;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefString = prefs.getString(_userPreferencesKey);
    } catch (e) {
      prefString = '{}';
    }
    return UserPreferencesModel.fromJson(jsonDecode(prefString ?? '{}'));
  }

  /// Sets (saves) user's preferences.
  @override
  Future<void> setPreferences(UserPreferencesModel userPreferences) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String prefString = jsonEncode(userPreferences);
    await prefs.setString(_userPreferencesKey, prefString);
  }
}
