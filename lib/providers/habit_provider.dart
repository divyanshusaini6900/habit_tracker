import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';
import '../services/storage_service.dart';

class HabitProvider extends ChangeNotifier {
  late StorageService _storage;
  List<Habit> _allHabits = [];
  bool _isDarkMode = false;
  bool _isLoading = true;
  
  // achievement milestones for badges
  final Map<int, String> achievements = {
    7: 'Week Champion 🏅',
    30: 'Monthly Hero 🏆',
    100: 'Century Legend 💎',
  };
  
  HabitProvider(SharedPreferences prefs) {
    _storage = StorageService(prefs);
    _loadEverything();
  }
  
  // getters for accessing data
  List<Habit> get allHabits => _allHabits;
  bool get isDarkMode => _isDarkMode;
  bool get isLoading => _isLoading;
  
  // load habits and preferences from storage
  Future<void> _loadEverything() async {
    _isLoading = true;
    notifyListeners();
    
    // small delay to show loading state (optional)
    await Future.delayed(const Duration(milliseconds: 500));
    
    _allHabits = _storage.loadHabits();
    _isDarkMode = _storage.getThemeMode();
    
    _isLoading = false;
    notifyListeners();
  }
  
  // add new habit to the list
  Future<void> addNewHabit(Habit habit) async {
    _allHabits.add(habit);
    await _storage.saveHabits(_allHabits);
    notifyListeners();
  }
  
  // remove habit from list
  Future<void> removeHabit(String habitId) async {
    _allHabits.removeWhere((h) => h.id == habitId);
    await _storage.saveHabits(_allHabits);
    notifyListeners();
  }
  
  // toggle habit completion for today
  Future<int?> toggleHabitStatus(String habitId) async {
    final habitIndex = _allHabits.indexWhere((h) => h.id == habitId);
    
    if (habitIndex == -1) return null;
    
    final habit = _allHabits[habitIndex];
    final wasCompleted = habit.didTodayTask();
    
    habit.toggleTodayStatus();
    await _storage.saveHabits(_allHabits);
    notifyListeners();
    
    // check if user earned a badge
    if (!wasCompleted && habit.currentStreak > 0) {
      for (var milestone in achievements.keys) {
        if (habit.currentStreak == milestone) {
          return milestone;
        }
      }
    }
    
    return null;
  }
  
  // update existing habit
  Future<void> updateHabit(Habit updatedHabit) async {
    final index = _allHabits.indexWhere((h) => h.id == updatedHabit.id);
    
    if (index != -1) {
      _allHabits[index] = updatedHabit;
      await _storage.saveHabits(_allHabits);
      notifyListeners();
    }
  }
  
  // toggle app theme
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _storage.saveThemeMode(_isDarkMode);
    notifyListeners();
  }
  
  // get habits sorted by best streak
  List<Habit> getTopStreaks() {
    final sortedList = List<Habit>.from(_allHabits);
    sortedList.sort((a, b) => b.longestStreak.compareTo(a.longestStreak));
    return sortedList.take(5).toList();
  }
  
  // calculate total completed tasks today
  int getTodayProgress() {
    if (_allHabits.isEmpty) return 0;
    
    int completed = 0;
    for (var habit in _allHabits) {
      if (habit.didTodayTask()) {
        completed++;
      }
    }
    
    return completed;
  }
  
  // get completion percentage for today
  double getTodayPercentage() {
    if (_allHabits.isEmpty) return 0.0;
    
    final completed = getTodayProgress();
    return (completed / _allHabits.length) * 100;
  }
}