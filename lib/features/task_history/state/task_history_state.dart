import 'package:flutter/foundation.dart';
import '../../../data/models/daily_task.dart';

@immutable
class TaskHistoryState {
  final Map<DateTime, List<DailyTask>> groupedTasks;
  final bool isLoading;
  final String? error;
  final String selectedPeriod;

  const TaskHistoryState({
    this.groupedTasks = const {},
    this.isLoading = false,
    this.error,
    this.selectedPeriod = 'LastWeek',
  });

  factory TaskHistoryState.initial() {
    return const TaskHistoryState(isLoading: true);
  }

  TaskHistoryState copyWith({
    Map<DateTime, List<DailyTask>>? groupedTasks,
    bool? isLoading,
    String? error,
    String? selectedPeriod,
    bool clearError = false,
  }) {
    return TaskHistoryState(
      groupedTasks: groupedTasks ?? this.groupedTasks,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
    );
  }

  int get totalTasks =>
      groupedTasks.values.fold(0, (sum, tasks) => sum + tasks.length);
  int get completedTasks => groupedTasks.values
      .expand((tasks) => tasks)
      .where((task) => task.isCompleted)
      .length;
  int get skippedTasks => groupedTasks.values
      .expand((tasks) => tasks)
      .where((task) => task.isSkipped)
      .length;
}
