import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/goal_repository.dart';
import '../state/my_goals_state.dart';

/// ViewModel for My Goals screen
/// Handles all business logic for goals list and dashboard
class MyGoalsViewModel extends StateNotifier<MyGoalsState> {
  final GoalRepository _repository;
  final String userId;

  MyGoalsViewModel(this._repository, this.userId)
    : super(MyGoalsState.initial()) {
    loadGoals();
  }

  /// Load all goals for the user
  Future<void> loadGoals() async {
    state = state.copyWithLoading();

    try {
      final goals = await _repository.getGoals(userId);
      state = state.copyWithSuccess(goals);
    } catch (e) {
      state = state.copyWithError(e.toString());
    }
  }

  /// Refresh goals
  Future<void> refreshGoals() async {
    await loadGoals();
  }
}
