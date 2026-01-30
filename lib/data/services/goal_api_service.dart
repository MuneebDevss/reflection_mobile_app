import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/goal.dart';
import '../models/goal_session.dart';
import '../models/daily_task.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() =>
      'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class GoalApiService {
  // Update this to match your backend URL
  static const String baseUrl =
      'https://overrigorous-laticia-authigenic.ngrok-free.dev';

  Future<Goal> createGoal(CreateGoalRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/goals'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        return Goal.fromJson(jsonData);
      } else {
        throw ApiException(
          'Failed to create goal: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<List<Goal>> getGoals(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/goals?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => Goal.fromJson(json)).toList();
      } else {
        throw ApiException(
          'Failed to fetch goals: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<Goal> getGoal(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/goals/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return Goal.fromJson(jsonData);
      } else {
        throw ApiException(
          'Failed to fetch goal: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // Goal Session endpoints
  Future<GoalSession> createGoalSession({
    required String userId,
    required String rawGoalText,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/goal-sessions'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId, 'rawGoalText': rawGoalText}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        return GoalSession.fromJson(jsonData);
      } else {
        throw ApiException(
          'Failed to create goal session: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<NextQuestionResponse> getNextQuestion(String sessionId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/goal-sessions/$sessionId/next-question'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return NextQuestionResponse.fromJson(jsonData);
      } else {
        throw ApiException(
          'Failed to get next question: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<void> answerQuestion({
    required String questionId,
    required String answerText,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/goal-questions/$questionId/answer'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'answerText': answerText}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiException(
          'Failed to save answer: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<GoalSession> completeSession(String sessionId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/goal-sessions/$sessionId/complete'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        return GoalSession.fromJson(jsonData);
      } else {
        throw ApiException(
          'Failed to complete session: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // Daily Task endpoints
  Future<List<DailyTask>> getTodayTasks(String goalId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/goals/$goalId/today-tasks'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => DailyTask.fromJson(json)).toList();
      } else {
        throw ApiException(
          'Failed to fetch today tasks: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<List<DailyTask>> generateTasks(String goalId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/goals/$goalId/generate-tasks'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => DailyTask.fromJson(json)).toList();
      } else {
        throw ApiException(
          'Failed to generate tasks: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<DailyTask> updateTaskStatus(String taskId, String status) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/goals/tasks/$taskId/status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': status}),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return DailyTask.fromJson(jsonData);
      } else {
        throw ApiException(
          'Failed to update task status: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<List<DailyTask>> getPreviousTasks(
    String goalId, {
    String period = 'LastWeek',
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/goals/$goalId/previous-tasks?period=$period'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => DailyTask.fromJson(json)).toList();
      } else {
        throw ApiException(
          'Failed to fetch previous tasks: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Network error: ${e.toString()}');
    }
  }
}
