// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/models/habit.dart';

void main() {
  // set up shared preferences for testing
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App launches and shows home screen', (WidgetTester tester) async {
    // getting mock shared preferences
    final prefs = await SharedPreferences.getInstance();
    
    // Build our app and trigger a frame
    await tester.pumpWidget(MyHabitApp(storage: prefs));
    await tester.pumpAndSettle();

    // Verify that home screen loads with expected elements
    expect(find.text('Good Morning'), findsOneWidget); // or afternoon/evening based on time
    expect(find.text('Keep your streak going!'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget); // FAB for adding habits
  });

  testWidgets('Shows empty state when no habits', (WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();
    
    await tester.pumpWidget(MyHabitApp(storage: prefs));
    await tester.pumpAndSettle();

    // Check for empty state message
    expect(find.text('No habits yet!'), findsOneWidget);
    expect(find.text('Tap the + button to add your first habit'), findsOneWidget);
  });

  testWidgets('Can navigate to add habit screen', (WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();
    
    await tester.pumpWidget(MyHabitApp(storage: prefs));
    await tester.pumpAndSettle();

    // Tap the add button
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify add habit screen is shown
    expect(find.text('Create New Habit'), findsOneWidget);
    expect(find.text('Habit Name'), findsOneWidget);
    expect(find.text('Choose an Icon'), findsOneWidget);
    expect(find.text('Pick a Color'), findsOneWidget);
  });

  testWidgets('Progress card shows correct initial state', (WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();
    
    await tester.pumpWidget(MyHabitApp(storage: prefs));
    await tester.pumpAndSettle();

    // Check progress card
    expect(find.text('Today\'s Progress'), findsOneWidget);
    expect(find.text('0 / 0'), findsOneWidget);
    expect(find.text('0% Complete'), findsOneWidget);
  });

  testWidgets('Bottom navigation has correct items', (WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();
    
    await tester.pumpWidget(MyHabitApp(storage: prefs));
    await tester.pumpAndSettle();

    // Check bottom nav items
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Stats'), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.bar_chart), findsOneWidget);
  });

  testWidgets('Can toggle theme between light and dark', (WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();
    
    await tester.pumpWidget(MyHabitApp(storage: prefs));
    await tester.pumpAndSettle();

    // Find theme toggle button - it should show dark_mode icon initially (light theme)
    expect(find.byIcon(Icons.dark_mode), findsOneWidget);

    // Tap to toggle theme
    await tester.tap(find.byIcon(Icons.dark_mode));
    await tester.pumpAndSettle();

    // Should now show light_mode icon (dark theme active)
    expect(find.byIcon(Icons.light_mode), findsOneWidget);
  });

  // unit test for habit model
  test('Habit model correctly tracks completion', () {
    final habit = Habit(
      id: '1',
      title: 'Test Habit',
      emoji: '⭐',
      habitColor: Colors.blue,
    );

    // initially should not be completed
    expect(habit.didTodayTask(), false);
    expect(habit.currentStreak, 0);

    // toggle completion for today
    habit.toggleTodayStatus();
    expect(habit.didTodayTask(), true);
    expect(habit.currentStreak, 1);

    // toggle again to mark incomplete
    habit.toggleTodayStatus();
    expect(habit.didTodayTask(), false);
    expect(habit.currentStreak, 0);
  });

  test('Habit model serialization works correctly', () {
    final habit = Habit(
      id: '123',
      title: 'Exercise',
      emoji: '🏃',
      habitColor: Colors.green,
      currentStreak: 5,
      longestStreak: 10,
    );

    // convert to map
    final map = habit.toMap();
    expect(map['id'], '123');
    expect(map['title'], 'Exercise');
    expect(map['emoji'], '🏃');
    expect(map['currentStreak'], 5);
    expect(map['longestStreak'], 10);

    // convert back from map
    final habitFromMap = Habit.fromMap(map);
    expect(habitFromMap.id, '123');
    expect(habitFromMap.title, 'Exercise');
    expect(habitFromMap.emoji, '🏃');
    expect(habitFromMap.currentStreak, 5);
    expect(habitFromMap.longestStreak, 10);
  });
}