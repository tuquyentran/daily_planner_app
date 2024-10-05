
import 'screens/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DailyPlannerApp());
}

class DailyPlannerApp extends StatelessWidget {
  const DailyPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WelcomeScreen(),
      // home: MainScreen(user: User(),)
    );
  }
}
