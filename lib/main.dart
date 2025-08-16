import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  // making sure everything is initialized before app starts
  WidgetsFlutterBinding.ensureInitialized();
  
  // getting shared prefs instance for data storage
  final prefs = await SharedPreferences.getInstance();
  
  runApp(MyHabitApp(storage: prefs));
}

class MyHabitApp extends StatelessWidget {
  final SharedPreferences storage;
  
  const MyHabitApp({
    super.key,
    required this.storage,
  });

  @override
  Widget build(BuildContext context) {
    // wrapping whole app with provider for state management
    return ChangeNotifierProvider(
      create: (_) => HabitProvider(storage),
      child: Consumer<HabitProvider>(
        builder: (context, habitProvider, _) {
          return MaterialApp(
            title: 'Daily Habits',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.deepPurple,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: habitProvider.isDarkMode ? Brightness.dark : Brightness.light,
              ),
              useMaterial3: true,
            ),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}