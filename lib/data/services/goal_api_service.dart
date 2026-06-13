import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/goal.dart';
import '../models/goal_session.dart';
import '../models/daily_task.dart';
import 'auth_service.dart';

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
  static const String baseUrl = 'https://reflection-backend-r7uw.onrender.com';

  final AuthService? authService;

  GoalApiService({this.authService});

  /// Get headers with optional JWT token for authenticated requests
  Future<Map<String, String>> _getHeaders({bool requiresAuth = false}) async {
    final headers = {'Content-Type': 'application/json'};

    if (requiresAuth && authService != null) {
      try {
        final token = await authService!.getToken();
        if (token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }
      } catch (e) {
        // If token retrieval fails, continue without auth header
        // The API will return 401 if authorization is required
      }
    }

    return headers;
  }

  Future<Goal> createGoal(CreateGoalRequest request) async {
    try {
      final headers = await _getHeaders(requiresAuth: true);
      final response = await http.post(
        Uri.parse('$baseUrl/goals'),
        headers: headers,
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
      final headers = await _getHeaders(requiresAuth: true);
      final response = await http.get(
        Uri.parse('$baseUrl/goals?userId=$userId'),
        headers: headers,
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
      final headers = await _getHeaders(requiresAuth: true);
      final response = await http.get(
        Uri.parse('$baseUrl/goals/$id'),
        headers: headers,
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
      final headers = await _getHeaders(requiresAuth: true);
      final response = await http.post(
        Uri.parse('$baseUrl/goal-sessions'),
        headers: headers,
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
      final headers = await _getHeaders(requiresAuth: true);
      final response = await http.get(
        Uri.parse('$baseUrl/goal-sessions/$sessionId/next-question'),
        headers: headers,
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
      final headers = await _getHeaders(requiresAuth: true);
      final response = await http.post(
        Uri.parse('$baseUrl/goal-questions/$questionId/answer'),
        headers: headers,
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
      final headers = await _getHeaders(requiresAuth: true);
      final response = await http.post(
        Uri.parse('$baseUrl/goal-sessions/$sessionId/complete'),
        headers: headers,
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
      final headers = await _getHeaders(requiresAuth: true);
      final response = await http.get(
        Uri.parse('$baseUrl/goals/$goalId/today-tasks'),
        headers: headers,
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
      final headers = await _getHeaders(requiresAuth: true);
      final response = await http.post(
        Uri.parse('$baseUrl/goals/$goalId/generate-tasks'),
        headers: headers,
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
      final headers = await _getHeaders(requiresAuth: true);
      final response = await http.patch(
        Uri.parse('$baseUrl/goals/tasks/$taskId/status'),
        headers: headers,
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
