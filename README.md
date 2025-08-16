Habit Tracker

A lightweight Flutter app for building daily habits with streaks, weekly progress, achievements, and playful celebrations.

1) How to Run the Project

Prerequisites

Flutter SDK: Dart 3.x (project environment: ">=3.0.0 <4.0.0"). Use the latest stable Flutter 3.x.

Android: Android Studio, Android SDK; device/emulator running Android 5.0+ (minSdk 21, targetSdk 34, compileSdk 35).

iOS (optional): Xcode on macOS; iOS 13+ recommended.

Web (optional): Chrome (or another supported browser).

Install dependencies

flutter pub get

Run on a device / emulator

# Android
aadb devices  # (optional) ensure your device is detected
flutter run -d android

# iOS (on macOS)
flutter run -d ios

# Web
flutter run -d chrome

Build release artifacts

# Android APK (release)
flutter build apk --release

# Android AppBundle (Play Store)
flutter build appbundle --release

# iOS (archive via Xcode)
flutter build ipa --release   # then finish signing in Xcode/Transporter

# Web (static site in build/web)
flutter build web

App ID / Package Name

Current Android applicationId: com.example.habit_tracker (in android/app/build.gradle.kts).

Change this before store release as needed.

2) Project Structure

habit_tracker/
├── lib/
│   ├── main.dart                    # App entry, Provider setup, theme
│   ├── models/
│   │   └── habit.dart               # Habit entity + streak logic & serialization
│   ├── services/
│   │   └── storage_service.dart     # SharedPreferences persistence layer
│   ├── providers/
│   │   └── habit_provider.dart      # ChangeNotifier: state, commands, selectors
│   ├── screens/
│   │   ├── home_screen.dart         # Dashboard: list, today toggle, confetti
│   │   ├── add_habit_screen.dart    # Create habit: emoji/color picker
│   │   └── stats_screen.dart        # Achievements, top streaks, totals
│   ├── widgets/
│   │   ├── habit_tile.dart          # Single habit row + today toggle
│   │   ├── streak_counter.dart      # Streak visual & copy
│   │   ├── weekly_progress_card.dart# Weekly summary across all habits
│   │   └── celebration_animation.dart# Confetti wrapper
│   └── utils/
│       ├── constants.dart           # Colors, emojis, strings
│       └── helpers.dart             # Date formatters, messages, week helpers
├── pubspec.yaml                      # Deps: provider, shared_preferences, confetti, etc.
└── android/ ios/ web/                # Platform scaffolding

3) Key Decisions & Architecture

a) State Management — Provider + ChangeNotifier

A single HabitProvider is the app’s source of truth for:

Habit collection (CRUD)

Theme mode (light/dark)

Derived values (today’s progress, weekly aggregates, top streaks)

Rationale: minimal surface area, familiar, lightweight; great for a small/mid app.

b) Persistence — SharedPreferences via StorageService

Habits are serialized to JSON in SharedPreferences.

Decoupled I/O in StorageService makes it easy to swap storage later (e.g., Hive/SQLite/Cloud) without touching UI/business logic.

c) Domain Model — Habit

Holds UI-facing fields (title, emoji, habitColor) and behavior:

didTodayTask(), toggleTodayStatus()

Streak calc + week-based keys (dates mapped to yyyy-MM-dd string keys)

Keeps streaks precomputed (currentStreak, longestStreak, plus weekly variants) to avoid recomputing on each frame.

d) UI Layer — Screens + Widgets

HomeScreen: list of habits, quick toggle for today, confetti celebration when milestones hit.

AddHabitScreen: emoji and color pickers for personalization.

StatsScreen: achievements, top streaks, totals.

Reusable widgets (HabitTile, StreakCounter, WeeklyProgressCard, CelebrationAnimation).

e) Theming

HabitProvider.toggleTheme() persists theme state in SharedPreferences.

Material 3, color seeded by Deep Purple.

f) Separation of Concerns

View (Screens/Widgets) is dumb; it calls Provider methods for mutations.

Provider orchestrates domain logic and persistence via Service.

Model encapsulates habit logic + (de)serialization.

4) Features

 Add/Edit/Delete habits with emoji & color

 One-tap today completion toggle per habit

 Streaks: current & longest

 Weekly progress snapshot across all habits

 Achievements (e.g., 7/30/100 days) with confetti celebration

 Motivational messages based on streak length

 Light/Dark theme persisted between launches

5) Bonus Touches & UX Details
 
 Leaderboard (local only): Track and display the highest streaks for each habit.
 
 Celebration modal with a positive message on hitting milestones.

 WeeklyProgressCard uses gradient cards and subtle shadows.

 Helpers.getMotivationalMessage() tailors copy by streak length for encouragement.

 Clean constants (emojis, color palette, strings) for a consistent look