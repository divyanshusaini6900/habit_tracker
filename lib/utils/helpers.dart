class Helpers {
  // format date for display
  static String formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
  
  // get motivational message based on streak
  static String getMotivationalMessage(int streak) {
    if (streak == 0) {
      return 'Start your journey today!';
    } else if (streak < 7) {
      return 'Great start! Keep going!';
    } else if (streak < 30) {
      return 'You\'re on fire! 🔥';
    } else if (streak < 100) {
      return 'Incredible dedication!';
    } else {
      return 'You\'re a legend! 👑';
    }
  }
  
  // calculate days since habit started
  static int daysSinceStart(DateTime startDate) {
    final now = DateTime.now();
    return now.difference(startDate).inDays;
  }
  
  // check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
           date.month == now.month &&
           date.day == now.day;
  }
  
  // get week day name
  static String getWeekdayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    
    return days[weekday - 1];
  }
}