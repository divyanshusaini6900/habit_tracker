// lib/screens/stats_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Stats'),
        elevation: 0,
      ),
      body: Consumer<HabitProvider>(
        builder: (context, provider, child) {
          final topHabits = provider.getTopStreaks();
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // achievements section
                const Text(
                  '🏆 Achievements',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildAchievementCards(provider),
                
                const SizedBox(height: 30),
                
                // leaderboard section
                const Text(
                  '📊 Top Streaks',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                
                if (topHabits.isEmpty)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      child: Text(
                        'Start completing habits to see your streaks here!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  ...topHabits.asMap().entries.map((entry) {
                    final index = entry.key;
                    final habit = entry.value;
                    
                    return _buildLeaderboardItem(
                      context: context,  // pass context here
                      position: index + 1,
                      habit: habit,
                    );
                  }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildAchievementCards(HabitProvider provider) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      children: provider.achievements.entries.map((entry) {
        final days = entry.key;
        final title = entry.value;
        
        // check if any habit has reached this milestone
        bool isUnlocked = false;
        for (var habit in provider.allHabits) {
          if (habit.longestStreak >= days) {
            isUnlocked = true;
            break;
          }
        }
        
        return Container(
          decoration: BoxDecoration(
            color: isUnlocked
                ? Colors.deepPurple.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isUnlocked ? Colors.deepPurple : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title.split(' ').last,
                style: TextStyle(
                  fontSize: 30,
                  color: isUnlocked ? null : Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$days days',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isUnlocked ? Colors.deepPurple : Colors.grey,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildLeaderboardItem({
    required BuildContext context,  // add context parameter
    required int position,
    required habit,
  }) {
    String medal = '';
    Color? medalColor;
    
    switch (position) {
      case 1:
        medal = '🥇';
        medalColor = Colors.amber;
        break;
      case 2:
        medal = '🥈';
        medalColor = Colors.grey;
        break;
      case 3:
        medal = '🥉';
        medalColor = Colors.brown;
        break;
      default:
        medal = '#$position';
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,  // now context is available
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // position/medal
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: medalColor?.withOpacity(0.2) ?? Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                medal,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // habit info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      habit.emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      habit.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Best: ${habit.longestStreak} days | Current: ${habit.currentStreak} days',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // streak badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: habit.habitColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${habit.longestStreak}',
              style: TextStyle(
                color: habit.habitColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}