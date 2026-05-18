class Task {
  final String id;
  final String subjectName;
  final String taskName;
  final String description;
  final String difficulty; // 'easy', 'medium', 'hard'
  final DateTime deadline;
  double progressPercent;
  bool isCompleted;
  final List<ProgressUpdate> progressUpdates;
  final DateTime createdAt;
  double? priorityScore;

  Task({
    required this.id,
    required this.subjectName,
    required this.taskName,
    required this.description,
    required this.difficulty,
    required this.deadline,
    this.progressPercent = 0.0,
    this.isCompleted = false,
    List<ProgressUpdate>? progressUpdates,
    DateTime? createdAt,
    this.priorityScore,
  })  : progressUpdates = progressUpdates ?? [],
        createdAt = createdAt ?? DateTime.now();

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      subjectName: json['subject_name'] as String,
      taskName: json['task_name'] as String,
      description: json['description'] as String? ?? '',
      difficulty: json['difficulty'] as String,
      deadline: DateTime.parse(json['deadline'] as String),
      progressPercent: (json['progress_percent'] as num?)?.toDouble() ?? 0.0,
      isCompleted: json['is_completed'] as bool? ?? false,
      progressUpdates: (json['progress_updates'] as List<dynamic>?)
              ?.map((u) => ProgressUpdate.fromJson(u as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      priorityScore: (json['priority_score'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject_name': subjectName,
      'task_name': taskName,
      'description': description,
      'difficulty': difficulty,
      'deadline': deadline.toIso8601String(),
      'progress_percent': progressPercent,
      'is_completed': isCompleted,
      'created_at': createdAt.toIso8601String(),
    };
  }

  int get difficultyValue {
    switch (difficulty) {
      case 'easy':
        return 1;
      case 'medium':
        return 2;
      case 'hard':
        return 3;
      default:
        return 1;
    }
  }

  int get daysUntilDeadline {
    return deadline.difference(DateTime.now()).inDays;
  }

  bool get isOverdue => deadline.isBefore(DateTime.now()) && !isCompleted;

  Task copyWith({
    String? id,
    String? subjectName,
    String? taskName,
    String? description,
    String? difficulty,
    DateTime? deadline,
    double? progressPercent,
    bool? isCompleted,
    List<ProgressUpdate>? progressUpdates,
    double? priorityScore,
  }) {
    return Task(
      id: id ?? this.id,
      subjectName: subjectName ?? this.subjectName,
      taskName: taskName ?? this.taskName,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      deadline: deadline ?? this.deadline,
      progressPercent: progressPercent ?? this.progressPercent,
      isCompleted: isCompleted ?? this.isCompleted,
      progressUpdates: progressUpdates ?? this.progressUpdates,
      createdAt: createdAt,
      priorityScore: priorityScore ?? this.priorityScore,
    );
  }
}

class ProgressUpdate {
  final String id;
  final String taskId;
  final String note;
  final double progressPercent;
  final String? imageUrl;
  final DateTime createdAt;

  ProgressUpdate({
    required this.id,
    required this.taskId,
    required this.note,
    required this.progressPercent,
    this.imageUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ProgressUpdate.fromJson(Map<String, dynamic> json) {
    return ProgressUpdate(
      id: json['id'] as String,
      taskId: json['task_id'] as String,
      note: json['note'] as String? ?? '',
      progressPercent: (json['progress_percent'] as num).toDouble(),
      imageUrl: json['image_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_id': taskId,
      'note': note,
      'progress_percent': progressPercent,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
