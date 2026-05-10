import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/add_task_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String addTask = '/add-task';

  static Map<String, WidgetBuilder> get routes => {
    home: (context) => const HomeScreen(),
    addTask: (context) => const AddTaskScreen(),
  };
}