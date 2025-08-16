// lib/widgets/streak_counter.dart
import 'package:flutter/material.dart';
import '../models/habit.dart';

class StreakCounter extends StatelessWidget {
  final Habit habit;
  
  const StreakCounter({
    super.key,
    required this.habit,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Daily streaks row
        Row(
          children: [
            _buildStreakChip(
              icon: Icons.local_fire_department,
              value: habit.currentStreak,
              label: 'day streak',
              color: habit.currentStreak > 0 ? Colors.orange : Colors.grey,
            ),
            const SizedBox(width: 12),
            _buildStreakChip(
              icon: Icons.emoji_events,
              value: habit.longestStreak,
              label: 'best',
              color: Colors.amber,
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Weekly streaks row
        Row(
          children: [
            _buildStreakChip(
              icon: Icons.calendar_today,
              value: habit.currentWeekStreak,
              label: 'week streak',
              color: habit.currentWeekStreak > 0 ? Colors.blue : Colors.grey,
            ),
            const SizedBox(width: 12),
            _buildStreakChip(
              icon: Icons.star,
              value: habit.getThisWeekProgress(),
              label: '/7 this week',
              color: Colors.purple,
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildStreakChip({
    required IconData icon,
    required int value,
    required String label,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 3),
        Text(
          '$value $label',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}