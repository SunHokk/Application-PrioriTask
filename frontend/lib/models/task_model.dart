class Task {
  final int? id;
  final String title;
  final String courseName;
  final int difficulty;
  final DateTime deadline;
  final double priorityScore;
  final bool isCompleted;

  Task({
    this.id,
    required this.title,
    required this.courseName,
    required this.difficulty,
    required this.deadline,
    this.priorityScore = 0.0,
    this.isCompleted = false,
  });

  // Fungsi untuk konversi JSON dari API ke Objek Task
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      courseName: json['courseName'],
      difficulty: json['difficulty'],
      deadline: DateTime.parse(json['deadline']),
      priorityScore: (json['priorityScore'] as num).toDouble(),
      isCompleted: json['isCompleted'],
    );
  }

  // Fungsi untuk konversi Objek Task ke JSON (untuk kirim ke API)
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "courseName": courseName,
      "difficulty": difficulty,
      "deadline": deadline.toIso8601String(),
    };
  }
}