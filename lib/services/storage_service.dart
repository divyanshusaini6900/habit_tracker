import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';

class StorageService {
  final SharedPreferences _prefs;
  
  // keys for storing different data
  static const String habitsKey = 'user_habits';
  static const String themeKey = 'app_theme';
  static const String firstTimeKey = 'first_time_user';
  
  StorageService(this._prefs);
  
  // save all habits to local storage
  Future<bool> saveHabits(List<Habit> habits) async {
    try {
      // converting list of habits to json string
      final habitMaps = habits.map((h) => h.toMap()).toList();
      final jsonString = json.encode(habitMaps);
      
      return await _prefs.setString(habitsKey, jsonString);
    } catch (error) {
      print('Problem saving habits: $error');
      return false;
    }
  }
  
  // load habits from storage
  List<Habit> loadHabits() {
    try {
      final jsonString = _prefs.getString(habitsKey);
      
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      
      final List<dynamic> habitMaps = json.decode(jsonString);
      
      // converting each map back to habit object
      return habitMaps.map((map) => Habit.fromMap(map)).toList();
    } catch (error) {
      print('Problem loading habits: $error');
      return [];
    }
  }
  
  // check if this is user's first time
  bool isFirstTimeUser() {
    return _prefs.getBool(firstTimeKey) ?? true;
  }
  
  // mark that user has opened app before
  Future<void> setNotFirstTime() async {
    await _prefs.setBool(firstTimeKey, false);
  }
  
  // save theme preference
  Future<void> saveThemeMode(bool isDark) async {
    await _prefs.setBool(themeKey, isDark);
  }
  
  // get saved theme preference
  bool getThemeMode() {
    return _prefs.getBool(themeKey) ?? false;
  }
  
  // clear all data (for testing or reset)
  Future<void> clearAllData() async {
    await _prefs.clear();
  }
}