class DailyTask {
  final String id;
  final String goalId;
  final String title;
  final String? description;
  final DateTime date;
  final int difficulty;
  final String status; // PENDING, COMPLETED, SKIPPED
  final DateTime createdAt;
  final DateTime updatedAt;

  // Convenience getter for dueDate (same as date)
  DateTime get dueDate => date;

  DailyTask({
    required this.id,
    required this.goalId,
    required this.title,
    this.description,
    required this.date,
    required this.difficulty,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DailyTask.fromJson(Map<String, dynamic> json) {
    return DailyTask(
      id: json['id'],
      goalId: json['goalId'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      difficulty: json['difficulty'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'goalId': goalId,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'difficulty': difficulty,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  bool get isPending => status == 'PENDING';
  bool get isCompleted => status == 'COMPLETED';
  bool get isSkipped => status == 'SKIPPED';

  DailyTask copyWith({
    String? id,
    String? goalId,
    String? title,
    String? description,
    DateTime? date,
    int? difficulty,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DailyTask(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      difficulty: difficulty ?? this.difficulty,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
