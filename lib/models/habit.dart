// lib/models/habit.dart
import 'package:flutter/material.dart';

class Habit {
  String id;
  String title;
  String emoji;
  Color habitColor;
  Map<String, bool> daysCompleted;
  int currentStreak;
  int longestStreak;
  int currentWeekStreak;  // NEW: weekly streak
  int longestWeekStreak;  // NEW: best weekly streak
  DateTime startDate;

  Habit({
    required this.id,
    required this.title,
    this.emoji = '⭐',
    Color? habitColor,
    Map<String, bool>? daysCompleted,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.currentWeekStreak = 0,  // NEW
    this.longestWeekStreak = 0,  // NEW
    DateTime? startDate,
  })  : habitColor = habitColor ?? Colors.blue,
        daysCompleted = daysCompleted ?? {},
        startDate = startDate ?? DateTime.now();

  // checking if user completed habit today
  bool didTodayTask() {
    final todayKey = _makeDateKey(DateTime.now());
    return daysCompleted[todayKey] ?? false;
  }

  // mark today as complete or incomplete
  void toggleTodayStatus() {
    final todayKey = _makeDateKey(DateTime.now());
    final currentStatus = daysCompleted[todayKey] ?? false;
    daysCompleted[todayKey] = !currentStatus;
    
    // recalculate both daily and weekly streaks
    updateStreakCount();
    updateWeeklyStreak();  // NEW
  }

  // helper method to create consistent date keys
  String _makeDateKey(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  // calculate current and best daily streaks
  void updateStreakCount() {
    int tempStreak = 0;
    DateTime checkingDate = DateTime.now();
    
    for (int dayCount = 0; dayCount < 365; dayCount++) {
      String dateToCheck = _makeDateKey(checkingDate);
      
      if (daysCompleted[dateToCheck] == true) {
        tempStreak++;
        checkingDate = checkingDate.subtract(const Duration(days: 1));
      } else if (dayCount == 0) {
        checkingDate = checkingDate.subtract(const Duration(days: 1));
        String yesterdayKey = _makeDateKey(checkingDate);
        
        if (daysCompleted[yesterdayKey] == true) {
          continue;
        } else {
          break;
        }
      } else {
        break;
      }
    }
    
    currentStreak = tempStreak;
    
    if (currentStreak > longestStreak) {
      longestStreak = currentStreak;
    }
  }

  // NEW: Calculate weekly streaks
  void updateWeeklyStreak() {
    int weekStreak = 0;
    DateTime currentDate = DateTime.now();
    
    // Start from the beginning of current week (Monday)
    int daysFromMonday = currentDate.weekday - 1;
    DateTime weekStart = currentDate.subtract(Duration(days: daysFromMonday));
    
    // Check consecutive weeks
    for (int weekCount = 0; weekCount < 52; weekCount++) {
      if (_isWeekComplete(weekStart)) {
        weekStreak++;
        weekStart = weekStart.subtract(const Duration(days: 7));
      } else if (weekCount == 0) {
        // Current week might be partial, check if at least 5 days done
        if (_getWeekCompletionCount(weekStart) >= 5) {
          weekStreak = 1;  // Count current week if mostly complete
        }
        break;
      } else {
        break;
      }
    }
    
    currentWeekStreak = weekStreak;
    
    if (currentWeekStreak > longestWeekStreak) {
      longestWeekStreak = currentWeekStreak;
    }
  }

  // Check if a week has all 7 days completed
  bool _isWeekComplete(DateTime weekStart) {
    for (int i = 0; i < 7; i++) {
      DateTime checkDate = weekStart.add(Duration(days: i));
      String dateKey = _makeDateKey(checkDate);
      if (daysCompleted[dateKey] != true) {
        return false;
      }
    }
    return true;
  }

  // Get number of completed days in a week
  int _getWeekCompletionCount(DateTime weekStart) {
    int count = 0;
    for (int i = 0; i < 7; i++) {
      DateTime checkDate = weekStart.add(Duration(days: i));
      // Don't count future days
      if (checkDate.isAfter(DateTime.now())) break;
      
      String dateKey = _makeDateKey(checkDate);
      if (daysCompleted[dateKey] == true) {
        count++;
      }
    }
    return count;
  }

  // Get this week's progress (for display)
  int getThisWeekProgress() {
    DateTime currentDate = DateTime.now();
    int daysFromMonday = currentDate.weekday - 1;
    DateTime weekStart = currentDate.subtract(Duration(days: daysFromMonday));
    
    return _getWeekCompletionCount(weekStart);
  }

  // convert habit to map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'emoji': emoji,
      'habitColor': habitColor.value,
      'daysCompleted': daysCompleted,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'currentWeekStreak': currentWeekStreak,  // NEW
      'longestWeekStreak': longestWeekStreak,  // NEW
      'startDate': startDate.toIso8601String(),
    };
  }

  // create habit from stored map
  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      title: map['title'],
      emoji: map['emoji'] ?? '⭐',
      habitColor: Color(map['habitColor']),
      daysCompleted: Map<String, bool>.from(map['daysCompleted'] ?? {}),
      currentStreak: map['currentStreak'] ?? 0,
      longestStreak: map['longestStreak'] ?? 0,
      currentWeekStreak: map['currentWeekStreak'] ?? 0,  // NEW
      longestWeekStreak: map['longestWeekStreak'] ?? 0,  // NEW
      startDate: DateTime.parse(map['startDate']),
    );
  }
}