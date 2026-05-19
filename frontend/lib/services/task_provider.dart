import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/api_service.dart';

class TaskProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Task> get activeTasks {
    final active = _tasks.where((t) => !t.isCompleted).toList();
    active.sort((a, b) =>
        (b.priorityScore ?? 0).compareTo(a.priorityScore ?? 0));
    return active;
  }

  List<Task> get completedTasks {
    final done = _tasks.where((t) => t.isCompleted).toList();
    done.sort((a, b) => b.deadline.compareTo(a.deadline));
    return done;
  }

  Task? get mostUrgentTask =>
      activeTasks.isNotEmpty ? activeTasks.first : null;

  List<Task> get urgentNotifications {
    final now = DateTime.now();
    return activeTasks
        .where((t) => t.deadline.difference(now).inDays <= 3)
        .take(3)
        .toList();
  }

  Future<void> loadTasks() async {
    final alreadyHasData = _tasks.isNotEmpty;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fetched = await _apiService.getTasks();
      _tasks = fetched.map((t) => t.copyWith(
        priorityScore: _calcScore(t),
      )).toList();
    } catch (e) {
      _error = e.toString();
      if (!alreadyHasData) {
        _tasks = _dummyTasks();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Tambah task langsung ke list lokal DAN ke Supabase via backend
  void addTaskLocally(Task task) {
    final scored = task.copyWith(priorityScore: _calcScore(task));
    _tasks.add(scored);
    notifyListeners();

    // Sync ke backend di background
    _apiService.createTask(scored.toJson()).then((createdTask) {
      // Ganti task lokal dengan task dari server (dapat ID resmi)
      final idx = _tasks.indexWhere((t) => t.id == scored.id);
      if (idx != -1) {
        _tasks[idx] = createdTask.copyWith(
          priorityScore: _calcScore(createdTask),
        );
        notifyListeners();
      }
    }).catchError((e) {
      // Task tetap ada secara lokal walau API gagal
      debugPrint('Failed to sync task to backend: $e');
    });
  }

  void updateTaskProgress(String taskId, double progress, String note) {
    final idx = _tasks.indexWhere((t) => t.id == taskId);
    if (idx == -1) return;

    // Update lokal langsung
    _tasks[idx].progressPercent = progress;
    if (progress >= 100) {
      _tasks[idx].isCompleted = true;
    }

    // Recalculate priority score setelah progress berubah
    _tasks[idx] = _tasks[idx].copyWith(
      progressPercent: progress,
      isCompleted: progress >= 100,
      priorityScore: _calcScore(_tasks[idx]),
    );

    notifyListeners();

    // Sync ke backend di background
    if (note.isNotEmpty || progress >= 0) {
      _apiService.addProgressUpdate(taskId, {
        'progress_percent': progress,
        'note': note,
      }).catchError((e) {
        debugPrint('Failed to sync progress to backend: $e');
      });
    }
  }

  void updateTaskProgressWithHistory(
      String taskId, double progress, String note, ProgressUpdate update) {
    final idx = _tasks.indexWhere((t) => t.id == taskId);
    if (idx == -1) return;

    final updatedUpdates = [..._tasks[idx].progressUpdates, update];

    _tasks[idx] = _tasks[idx].copyWith(
      progressPercent: progress,
      isCompleted: progress >= 100,
      priorityScore: _calcScore(_tasks[idx].copyWith(progressPercent: progress)),
      progressUpdates: updatedUpdates,
    );

    notifyListeners();

    // Sync ke backend di background
    _apiService.addProgressUpdate(taskId, {
      'progress_percent': progress,
      'note': note,
    }).catchError((e) {
      debugPrint('Failed to sync progress: $e');
    });
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();

    _apiService.deleteTask(taskId).catchError((e) {
      debugPrint('Failed to delete task from backend: $e');
    });
  }

  List<Task> getTasksForDate(DateTime date) {
    return _tasks.where((t) {
      return t.deadline.year == date.year &&
          t.deadline.month == date.month &&
          t.deadline.day == date.day;
    }).toList();
  }

  double _calcScore(Task task) {
    if (task.isCompleted) return 0;

    final hoursLeft = task.deadline.difference(DateTime.now()).inHours;
    final deadlineFactor = hoursLeft <= 0
        ? 100.0
        : (100.0 * (1 - hoursLeft.clamp(0, 168) / 168));

    final difficultyFactor = task.difficulty == 'easy'
        ? 33.3
        : task.difficulty == 'hard'
            ? 100.0
            : 66.7;

    final progressFactor = 100.0 - task.progressPercent;

    final score = (0.5 * deadlineFactor) +
        (0.3 * difficultyFactor) +
        (0.2 * progressFactor);

    return double.parse(score.toStringAsFixed(2));
  }

  List<Task> _dummyTasks() {
    final now = DateTime.now();
    final tasks = [
      Task(
        id: '1',
        subjectName: 'Kalkulus',
        taskName: 'Tugas Integral Lipat',
        description: 'Kerjakan soal integral lipat dua dan tiga dari buku',
        difficulty: 'hard',
        deadline: now.add(const Duration(days: 2)),
        progressPercent: 30,
      ),
      Task(
        id: '2',
        subjectName: 'Pemrograman Web',
        taskName: 'Project UAS React',
        description: 'Buat aplikasi web menggunakan React dan deploy ke Vercel',
        difficulty: 'hard',
        deadline: now.add(const Duration(days: 7)),
        progressPercent: 60,
      ),
      Task(
        id: '3',
        subjectName: 'Basis Data',
        taskName: 'Laporan ERD',
        description: 'Buat Entity Relationship Diagram untuk sistem perpustakaan',
        difficulty: 'medium',
        deadline: now.add(const Duration(days: 4)),
        progressPercent: 10,
      ),
      Task(
        id: '4',
        subjectName: 'Fisika Dasar',
        taskName: 'Resume Materi Termodinamika',
        description: 'Resume bab 5 dan 6 dari buku fisika university',
        difficulty: 'easy',
        deadline: now.add(const Duration(days: 1)),
        progressPercent: 75,
      ),
      Task(
        id: '5',
        subjectName: 'Algoritma',
        taskName: 'Implementasi Binary Tree',
        description: 'Implementasi BST dengan operasi insert, delete, search',
        difficulty: 'medium',
        deadline: now.subtract(const Duration(days: 1)),
        progressPercent: 100,
        isCompleted: true,
      ),
    ];

    // Hitung skor untuk semua dummy tasks
    return tasks.map((t) => t.copyWith(priorityScore: _calcScore(t))).toList();
  }
}