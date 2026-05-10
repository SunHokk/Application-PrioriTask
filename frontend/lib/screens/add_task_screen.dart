import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _courseController = TextEditingController();
  DateTime? _selectedDate;
  int _difficulty = 3;

  void _saveTask() async {
    if (_titleController.text.isEmpty || _selectedDate == null) return;

    final data = {
      "title": _titleController.text,
      "courseName": _courseController.text,
      "difficulty": _difficulty,
      "deadline": _selectedDate!.toIso8601String(),
    };

    try {
      await ApiService().addTask(data);
      if (mounted) Navigator.pop(context, true); // Kembali ke Home & beri sinyal refresh
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Tugas Baru")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: "Judul Tugas")),
            TextField(controller: _courseController, decoration: const InputDecoration(labelText: "Nama Mata Kuliah")),
            const SizedBox(height: 20),
            ListTile(
              title: Text(_selectedDate == null ? "Pilih Deadline" : DateFormat('yyyy-MM-dd').format(_selectedDate!)),
              trailing: const Icon(Icons.calendar_month),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
            ),
            const SizedBox(height: 10),
            Text("Tingkat Kesulitan: $_difficulty"),
            Slider(
              value: _difficulty.toDouble(),
              min: 1, max: 5, divisions: 4,
              onChanged: (v) => setState(() => _difficulty = v.toInt()),
            ),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: _saveTask, child: const Text("Simpan ke Database")),
          ],
        ),
      ),
    );
  }
}