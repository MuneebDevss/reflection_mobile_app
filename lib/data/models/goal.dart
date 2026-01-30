class Goal {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final DateTime deadline;
  final int progress;
  final DateTime createdAt;
  final DateTime updatedAt;

  Goal({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.deadline,
    required this.progress,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      description: json['description'],
      deadline: DateTime.parse(json['deadline']),
      progress: json['progress'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'progress': progress,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Goal copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    DateTime? deadline,
    int? progress,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Goal(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CreateGoalRequest {
  final String userId;
  final String title;
  final String? description;
  final DateTime deadline;
  final int progress;

  CreateGoalRequest({
    required this.userId,
    required this.title,
    this.description,
    required this.deadline,
    this.progress = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'progress': progress,
    };
  }
}
