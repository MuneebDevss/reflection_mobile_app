import 'package:flutter/foundation.dart';
import '../../../data/models/daily_task.dart';

@immutable
class GoalDetailsState {
  final List<DailyTask> tasks;
  final bool isLoading;
  final String? error;

  const GoalDetailsState({
    this.tasks = const [],
    this.isLoading = false,
    this.error,
  });

  factory GoalDetailsState.initial() {
    return const GoalDetailsState(isLoading: true);
  }

  GoalDetailsState copyWith({
    List<DailyTask>? tasks,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return GoalDetailsState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  bool get hasTasks => tasks.isNotEmpty;
}
