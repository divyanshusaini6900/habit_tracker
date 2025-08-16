// lib/widgets/habit_tile.dart
import 'package:flutter/material.dart';
import '../models/habit.dart';
import 'streak_counter.dart';

class HabitTile extends StatefulWidget {
  final Habit habit;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  
  const HabitTile({
    super.key,
    required this.habit,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<HabitTile> createState() => _HabitTileState();
}

class _HabitTileState extends State<HabitTile> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  bool _isExpanded = false;  // NEW: for expanding tile
  
  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeInOut,
      ),
    );
  }
  
  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }
  
  void _handleTap() {
    // animate the tap
    _animController.forward().then((_) {
      _animController.reverse();
    });
    
    // call the callback
    widget.onTap();
  }
  
  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.habit.didTodayTask();
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: widget.habit.habitColor.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _handleTap,
                onLongPress: widget.onDelete,
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // emoji icon
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: widget.habit.habitColor.withOpacity(
                                isCompleted ? 0.3 : 0.1,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                widget.habit.emoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          // habit details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.habit.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    decoration: isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                StreakCounter(habit: widget.habit),
                              ],
                            ),
                          ),
                          
                          // completion checkbox with expand button
                          Column(
                            children: [
                              _buildCompletionIndicator(isCompleted),
                              const SizedBox(height: 4),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isExpanded = !_isExpanded;
                                  });
                                },
                                child: Icon(
                                  _isExpanded 
                                    ? Icons.expand_less 
                                    : Icons.expand_more,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      // Expanded details section
                      if (_isExpanded)
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              _buildDetailRow(
                                'This Week',
                                '${widget.habit.getThisWeekProgress()}/7 days',
                                Colors.blue,
                              ),
                              const SizedBox(height: 8),
                              _buildDetailRow(
                                'Best Week Streak',
                                '${widget.habit.longestWeekStreak} weeks',
                                Colors.purple,
                              ),
                              const SizedBox(height: 8),
                              _buildDetailRow(
                                'Total Days',
                                '${widget.habit.daysCompleted.values.where((v) => v).length} completed',
                                Colors.green,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildDetailRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildCompletionIndicator(bool isCompleted) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isCompleted
            ? Colors.green
            : Colors.grey.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isCompleted ? Icons.check : Icons.circle_outlined,
        color: isCompleted ? Colors.white : Colors.grey,
        size: 20,
      ),
    );
  }
}