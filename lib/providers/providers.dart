import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reflection_frontend/features/goal_creation/state/goal_creation_state.dart';
import 'package:reflection_frontend/features/goal_details/state/goal_details_state.dart';
import 'package:reflection_frontend/features/goals/state/my_goals_state.dart';
import 'package:reflection_frontend/features/task_history/state/task_history_state.dart';
import '../data/services/goal_api_service.dart';
import '../data/repositories/goal_repository.dart';
import '../data/repositories/goal_session_repository.dart';
import '../features/goals/viewmodel/my_goals_viewmodel.dart';
import '../features/goal_creation/viewmodel/goal_creation_viewmodel.dart';
import '../features/goal_details/viewmodel/goal_details_viewmodel.dart';
import '../features/task_history/viewmodel/task_history_viewmodel.dart';
import '../data/models/goal.dart';

// ============================================================================
// SERVICE PROVIDERS
// ============================================================================

/// Provider for the Goal API Service (singleton)
final goalApiServiceProvider = Provider<GoalApiService>((ref) {
  return GoalApiService();
});

// ============================================================================
// REPOSITORY PROVIDERS
// ============================================================================

/// Provider for the Goal Repository
final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  final apiService = ref.watch(goalApiServiceProvider);
  return GoalRepository(apiService);
});

/// Provider for the Goal Session Repository
final goalSessionRepositoryProvider = Provider<GoalSessionRepository>((ref) {
  final apiService = ref.watch(goalApiServiceProvider);
  return GoalSessionRepository(apiService);
});

// ============================================================================
// VIEWMODEL PROVIDERS
// ============================================================================

/// Provider for My Goals screen ViewModel
/// Pass userId as parameter
final myGoalsViewModelProvider =
    StateNotifierProvider.family<MyGoalsViewModel, MyGoalsState, String>((
      ref,
      userId,
    ) {
      final repository = ref.watch(goalRepositoryProvider);
      return MyGoalsViewModel(repository, userId);
    });

/// Provider for Goal Creation screen ViewModel
/// Pass userId as parameter
final goalCreationViewModelProvider =
    StateNotifierProvider.family<
      GoalCreationViewModel,
      GoalCreationState,
      String
    >((ref, userId) {
      final repository = ref.watch(goalSessionRepositoryProvider);
      return GoalCreationViewModel(repository, userId);
    });

/// Provider for Goal Details screen ViewModel
/// Pass Goal object as parameter
final goalDetailsViewModelProvider =
    StateNotifierProvider.family<GoalDetailsViewModel, GoalDetailsState, Goal>((
      ref,
      goal,
    ) {
      final repository = ref.watch(goalRepositoryProvider);
      return GoalDetailsViewModel(repository, goal);
    });

/// Provider for Task History screen ViewModel
/// Pass Goal object as parameter
final taskHistoryViewModelProvider =
    StateNotifierProvider.family<TaskHistoryViewModel, TaskHistoryState, Goal>((
      ref,
      goal,
    ) {
      final repository = ref.watch(goalRepositoryProvider);
      return TaskHistoryViewModel(repository, goal);
    });
