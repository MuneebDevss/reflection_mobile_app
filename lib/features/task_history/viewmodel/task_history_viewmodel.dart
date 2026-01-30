import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/goal.dart';
import '../../../data/models/daily_task.dart';
import '../../../data/repositories/goal_repository.dart';
import '../state/task_history_state.dart';

class TaskHistoryViewModel extends StateNotifier<TaskHistoryState> {
  final GoalRepository _repository;
  final Goal goal;

  TaskHistoryViewModel(this._repository, this.goal)
    : super(TaskHistoryState.initial()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final tasks = await _repository.getPreviousTasks(
        goal.id,
        period: state.selectedPeriod,
      );

      final grouped = _groupTasksByDate(tasks);

      state = state.copyWith(groupedTasks: grouped, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void changePeriod(String period) {
    state = state.copyWith(selectedPeriod: period);
    loadHistory();
  }

  Map<DateTime, List<DailyTask>> _groupTasksByDate(List<DailyTask> tasks) {
    final Map<DateTime, List<DailyTask>> grouped = {};

    // Sort tasks newest to oldest
    tasks.sort((a, b) => b.date.compareTo(a.date));

    for (final task in tasks) {
      final dateOnly = DateTime(task.date.year, task.date.month, task.date.day);
      if (!grouped.containsKey(dateOnly)) {
        grouped[dateOnly] = [];
      }
      grouped[dateOnly]!.add(task);
    }

    return grouped;
  }
}
