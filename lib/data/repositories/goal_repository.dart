import '../models/goal.dart';
import '../models/daily_task.dart';
import '../services/goal_api_service.dart';

/// Repository for goal-related operations
/// Handles all goal data operations and business logic
class GoalRepository {
  final GoalApiService _apiService;

  GoalRepository(this._apiService);

  /// Fetches all goals for a specific user
  Future<List<Goal>> getGoals(String userId) async {
    return await _apiService.getGoals(userId);
  }

  /// Fetches a single goal by ID
  Future<Goal> getGoal(String id) async {
    return await _apiService.getGoal(id);
  }

  /// Creates a new goal
  Future<Goal> createGoal(CreateGoalRequest request) async {
    return await _apiService.createGoal(request);
  }

  /// Gets today's tasks for a specific goal
  Future<List<DailyTask>> getTodayTasks(String goalId) async {
    return await _apiService.getTodayTasks(goalId);
  }

  /// Generates new tasks for a goal
  Future<List<DailyTask>> generateTasks(String goalId) async {
    return await _apiService.generateTasks(goalId);
  }

  /// Updates the status of a task
  Future<DailyTask> updateTaskStatus(String taskId, String status) async {
    return await _apiService.updateTaskStatus(taskId, status);
  }

  /// Gets previous tasks for a goal with optional period filter
  Future<List<DailyTask>> getPreviousTasks(
    String goalId, {
    String period = 'LastWeek',
  }) async {
    return await _apiService.getPreviousTasks(goalId, period: period);
  }
}
