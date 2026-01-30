import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/goal.dart';
import '../../../data/repositories/goal_repository.dart';
import '../state/goal_details_state.dart';

class GoalDetailsViewModel extends StateNotifier<GoalDetailsState> {
  final GoalRepository _repository;
  final Goal goal;

  GoalDetailsViewModel(this._repository, this.goal)
    : super(GoalDetailsState.initial()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final tasks = await _repository.getTodayTasks(goal.id);
      state = state.copyWith(tasks: tasks, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> generateTasks() async {
    try {
      final tasks = await _repository.generateTasks(goal.id);
      state = state.copyWith(tasks: tasks);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> toggleTaskStatus(String taskId) async {
    final task = state.tasks.firstWhere((t) => t.id == taskId);
    final newStatus = task.status == 'COMPLETED' ? 'PENDING' : 'COMPLETED';

    // Optimistic update
    final updatedTasks = state.tasks.map((t) {
      if (t.id == taskId) {
        return t.copyWith(status: newStatus);
      }
      return t;
    }).toList();

    state = state.copyWith(tasks: updatedTasks);

    try {
      await _repository.updateTaskStatus(taskId, newStatus);
    } catch (e) {
      // Revert on error
      await loadTasks();
      rethrow;
    }
  }
}
