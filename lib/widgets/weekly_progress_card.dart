// lib/widgets/weekly_progress_card.dart
import 'package:flutter/material.dart';
import '../models/habit.dart';

class WeeklyProgressCard extends StatelessWidget {
  final List<Habit> habits;
  
  const WeeklyProgressCard({
    super.key,
    required this.habits,
  });
  
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekday = now.weekday;
    final daysFromMonday = weekday - 1;
    final weekStart = now.subtract(Duration(days: daysFromMonday));
    
    // Calculate weekly stats
    int totalWeeklyTasks = 0;
    int completedWeeklyTasks = 0;
    
    for (var habit in habits) {
      for (int i = 0; i < weekday; i++) {
        totalWeeklyTasks++;
        final checkDate = weekStart.add(Duration(days: i));
        final dateKey = _makeDateKey(checkDate);
        if (habit.daysCompleted[dateKey] == true) {
          completedWeeklyTasks++;
        }
      }
    }
    
    final weeklyPercentage = totalWeeklyTasks > 0 
        ? (completedWeeklyTasks / totalWeeklyTasks * 100).round()
        : 0;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'This Week\'s Progress',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$weeklyPercentage%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          
          // Week days indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {
              final dayDate = weekStart.add(Duration(days: index));
              final isToday = _isToday(dayDate);
              final isFuture = dayDate.isAfter(now);
              
              // Check if any habit was completed on this day
              bool hasCompletion = false;
              for (var habit in habits) {
                final dateKey = _makeDateKey(dayDate);
                if (habit.daysCompleted[dateKey] == true) {
                  hasCompletion = true;
                  break;
                }
              }
              
              return Column(
                children: [
                  Text(
                    _getDayName(index),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: isFuture 
                          ? Colors.white.withOpacity(0.2)
                          : hasCompletion 
                              ? Colors.green 
                              : Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                      border: isToday 
                          ? Border.all(color: Colors.white, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: isFuture
                          ? const SizedBox()
                          : Icon(
                              hasCompletion ? Icons.check : Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                    ),
                  ),
                ],
              );
            }),
          ),
          
          const SizedBox(height: 15),
          
          // Weekly streak info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  _getWeeklyStreakMessage(habits),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  String _makeDateKey(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
  
  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
           date.month == now.month &&
           date.day == now.day;
  }
  
  String _getDayName(int index) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return days[index];
  }
  
  String _getWeeklyStreakMessage(List<Habit> habits) {
    if (habits.isEmpty) return 'Start your first habit!';
    
    // Find the best weekly streak among all habits
    int bestWeekStreak = 0;
    for (var habit in habits) {
      if (habit.currentWeekStreak > bestWeekStreak) {
        bestWeekStreak = habit.currentWeekStreak;
      }
    }
    
    if (bestWeekStreak == 0) {
      return 'Complete a full week to start a streak!';
    } else if (bestWeekStreak == 1) {
      return '1 week streak! Keep going! 🔥';
    } else {
      return '$bestWeekStreak week streak! Amazing! 🔥';
    }
  }
}