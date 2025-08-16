import 'package:flutter/material.dart';

class AppColors {
  static const List<Color> habitColors = [
    Colors.blue,
    Colors.purple,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.pink,
    Colors.teal,
    Colors.amber,
    Colors.indigo,
    Colors.cyan,
    Colors.lime,
    Colors.brown,
  ];
}

class AppEmojis {
  static const List<String> habitEmojis = [
    '⭐', '💪', '📚', '🏃', '💧', '🧘',
    '✍️', '🎨', '🎵', '🌱', '🎯', '📖',
    '🏋️', '🚴', '🧠', '💻', '🍎', '😴',
    '🧹', '💰', '📱', '🎮', '🍵', '🚶',
  ];
}

class AppStrings {
  static const String appName = 'Habit Tracker';
  static const String addHabitTitle = 'Add New Habit';
  static const String deleteConfirmation = 'Are you sure you want to delete this habit?';
  static const String noHabitsMessage = 'No habits yet! Tap + to add your first habit.';
}