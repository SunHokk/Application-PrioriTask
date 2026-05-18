import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../theme/app_theme.dart';
import '../services/task_provider.dart';
import '../models/task.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  String _difficulty = 'medium';
  DateTime _deadline = DateTime.now().add(const Duration(days: 3));
  bool _isLoading = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tambah Tugas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('Mata Kuliah'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _subjectController,
                  decoration: const InputDecoration(
                    hintText: 'Contoh: Kalkulus, Basis Data...',
                    prefixIcon:
                        Icon(Icons.school_outlined, color: AppColors.primary),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                _buildLabel('Nama Tugas'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Contoh: Tugas Integral Lipat...',
                    prefixIcon: Icon(Icons.assignment_outlined,
                        color: AppColors.primary),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                _buildLabel('Deskripsi Tugas'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Tambahkan detail tugas...',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 16),
                _buildLabel('Tingkat Kesulitan'),
                const SizedBox(height: 8),
                _buildDifficultySelector(),
                const SizedBox(height: 16),
                _buildLabel('Deadline'),
                const SizedBox(height: 8),
                _buildDeadlinePicker(context),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitTask,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Tambahkan Tugas'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildDifficultySelector() {
    final options = [
      ('easy', 'Mudah', AppColors.easy),
      ('medium', 'Sedang', AppColors.medium),
      ('hard', 'Sulit', AppColors.hard),
    ];

    return Row(
      children: options.map((opt) {
        final isSelected = _difficulty == opt.$1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: opt.$1 == 'hard' ? 0 : 8),
            child: GestureDetector(
              onTap: () => setState(() => _difficulty = opt.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? opt.$3 : opt.$3.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? opt.$3 : opt.$3.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  opt.$2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : opt.$3,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDeadlinePicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await _showDateTimePicker(context);
        if (picked != null) setState(() => _deadline = picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined,
                color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Text(
              DateFormat('EEEE, d MMMM yyyy  •  HH:mm').format(_deadline),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(Icons.edit_outlined,
                size: 16, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _showDateTimePicker(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme:
              const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (date == null) return null;
    if (!context.mounted) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_deadline),
    );
    if (time == null) return date;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> _submitTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final newTask = Task(
        id: const Uuid().v4(),
        subjectName: _subjectController.text.trim(),
        taskName: _nameController.text.trim(),
        description: _descController.text.trim(),
        difficulty: _difficulty,
        deadline: _deadline,
        progressPercent: 0,
        isCompleted: false,
      );

      // Langsung tambah ke provider secara lokal, tanpa menunggu API
      context.read<TaskProvider>().addTaskLocally(newTask);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tugas berhasil ditambahkan'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambahkan tugas: $e'),
            backgroundColor: AppColors.urgent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}