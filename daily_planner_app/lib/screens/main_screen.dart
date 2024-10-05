import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:daily_planner_app/models/user.dart';
import 'package:daily_planner_app/screens/calendar_screen.dart';
import 'package:daily_planner_app/screens/setting_screen.dart';
import 'package:daily_planner_app/screens/task_list_screen.dart';
import 'package:daily_planner_app/screens/task_reminders_screen.dart';
import 'package:daily_planner_app/screens/task_statistics_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required User user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentPage = 0;
  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      const TaskListScreen(),
      const CalendarScreen(),
      const TaskStatisticsScreen(),
      const TaskRemindersScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white.withOpacity(1),
        buttonBackgroundColor: const Color.fromRGBO(83, 13, 126, 10),
        color:
            const Color.fromRGBO(83, 13, 126, 10), 
        animationDuration: const Duration(milliseconds: 300),
        letIndexChange: (int newIndex) {
          setState(() {
            _currentPage = newIndex;
          });
          return true;
        },

        items: const [
          Icon(
            Icons.home_outlined,
            size: 26,
            color: Colors.white,
          ),
          Icon(Icons.calendar_today_outlined,
              size: 26, color: Colors.white),
          Icon(Icons.bar_chart, size: 26, color: Colors.white),
          Icon(Icons.notifications_outlined, size: 26, color: Colors.white),
          Icon(Icons.settings, size: 26, color: Colors.white),
        ],
      ),
      body: screens[_currentPage],
    );
  }
}