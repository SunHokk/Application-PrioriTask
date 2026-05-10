import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final Color color;
  final VoidCallback? onDone;

  const TaskCard({
    super.key, 
    required this.task, 
    required this.color, 
    this.onDone
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          task.title, 
          style: const TextStyle(fontWeight: FontWeight.bold)
        ),
        subtitle: Text("${task.courseName} • Skor: ${task.priorityScore.toStringAsFixed(1)}"),
        trailing: task.isCompleted 
          ? const Icon(Icons.check_circle, color: Colors.green)
          : IconButton(
              icon: const Icon(Icons.circle_outlined),
              onPressed: onDone,
            ),
      ),
    );
  }
}