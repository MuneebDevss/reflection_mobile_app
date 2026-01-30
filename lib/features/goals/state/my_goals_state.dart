import 'package:flutter/foundation.dart';
import '../../../data/models/goal.dart';

/// State for My Goals screen
@immutable
class MyGoalsState {
  final List<Goal>? goals;
  final bool isLoading;
  final String? errorMessage;

  const MyGoalsState({this.goals, this.isLoading = false, this.errorMessage});

  /// Initial state
  factory MyGoalsState.initial() {
    return const MyGoalsState(isLoading: true);
  }

  /// Loading state
  MyGoalsState copyWithLoading() {
    return MyGoalsState(goals: goals, isLoading: true, errorMessage: null);
  }

  /// Success state
  MyGoalsState copyWithSuccess(List<Goal> goals) {
    return MyGoalsState(goals: goals, isLoading: false, errorMessage: null);
  }

  /// Error state
  MyGoalsState copyWithError(String error) {
    return MyGoalsState(goals: goals, isLoading: false, errorMessage: error);
  }

  /// Calculate dashboard statistics
  Map<String, dynamic> getDashboardStats() {
    if (goals == null || goals!.isEmpty) {
      return {
        'total': 0,
        'completed': 0,
        'inProgress': 0,
        'overdue': 0,
        'avgProgress': 0.0,
      };
    }

    final now = DateTime.now();
    final completed = goals!.where((g) => g.progress == 100).length;
    final overdue = goals!
        .where((g) => g.deadline.isBefore(now) && g.progress < 100)
        .length;
    final inProgress = goals!.length - completed;
    final avgProgress = goals!.isEmpty
        ? 0.0
        : goals!.map((g) => g.progress).reduce((a, b) => a + b) / goals!.length;

    return {
      'total': goals!.length,
      'completed': completed,
      'inProgress': inProgress,
      'overdue': overdue,
      'avgProgress': avgProgress,
    };
  }

  bool get hasGoals => goals != null && goals!.isNotEmpty;
  bool get hasError => errorMessage != null;
}
