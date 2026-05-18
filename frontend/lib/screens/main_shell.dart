import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'task_list_screen.dart';
import 'calendar_screen.dart';
import 'account_screen.dart';
import 'add_task_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    TaskListScreen(),
    CalendarScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButton: _currentIndex == 0 || _currentIndex == 1
          ? FloatingActionButton(
              onPressed: () => _openAddTask(context),
              backgroundColor: AppColors.primary,
              elevation: 4,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            )
          : null,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.navBarBg,
          border: Border(
            top: BorderSide(color: AppColors.divider, width: 1),
          ),
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: Colors.transparent,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.task_outlined),
                activeIcon: Icon(Icons.task_rounded),
                label: 'Tasks',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined),
                activeIcon: Icon(Icons.calendar_month_rounded),
                label: 'Calendar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                activeIcon: Icon(Icons.person_rounded),
                label: 'Account',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openAddTask(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddTaskScreen()),
    );
  }
}
