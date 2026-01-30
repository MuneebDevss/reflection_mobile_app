import '../models/goal_session.dart';
import '../services/goal_api_service.dart';

/// Repository for goal session operations (chat-based goal creation)
/// Handles all session and question/answer operations
class GoalSessionRepository {
  final GoalApiService _apiService;

  GoalSessionRepository(this._apiService);

  /// Creates a new goal session
  Future<GoalSession> createSession({
    required String userId,
    required String rawGoalText,
  }) async {
    return await _apiService.createGoalSession(
      userId: userId,
      rawGoalText: rawGoalText,
    );
  }

  /// Gets the next question in the session
  Future<NextQuestionResponse> getNextQuestion(String sessionId) async {
    return await _apiService.getNextQuestion(sessionId);
  }

  /// Submits an answer to a question
  Future<void> answerQuestion({
    required String questionId,
    required String answerText,
  }) async {
    return await _apiService.answerQuestion(
      questionId: questionId,
      answerText: answerText,
    );
  }

  /// Completes the session and creates the goal
  Future<GoalSession> completeSession(String sessionId) async {
    return await _apiService.completeSession(sessionId);
  }
}
