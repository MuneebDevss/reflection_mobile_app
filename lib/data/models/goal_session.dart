import 'goal.dart';

class GoalSession {
  final String id;
  final String userId;
  final String rawGoalText;
  final String status;
  final String? goalId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<GoalQuestion>? questions;
  final Goal? goal;

  GoalSession({
    required this.id,
    required this.userId,
    required this.rawGoalText,
    required this.status,
    this.goalId,
    required this.createdAt,
    required this.updatedAt,
    this.questions,
    this.goal,
  });

  factory GoalSession.fromJson(Map<String, dynamic> json) {
    return GoalSession(
      id: json['id'],
      userId: json['userId'],
      rawGoalText: json['rawGoalText'],
      status: json['status'],
      goalId: json['goalId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      questions: json['questions'] != null
          ? (json['questions'] as List)
                .map((q) => GoalQuestion.fromJson(q))
                .toList()
          : null,
      goal: json['goal'] != null ? Goal.fromJson(json['goal']) : null,
    );
  }
}

class GoalQuestion {
  final String id;
  final String sessionId;
  final String question;
  final List<String> options;
  final int order;
  final DateTime createdAt;
  final List<GoalAnswer>? answers;

  GoalQuestion({
    required this.id,
    required this.sessionId,
    required this.question,
    required this.options,
    required this.order,
    required this.createdAt,
    this.answers,
  });

  factory GoalQuestion.fromJson(Map<String, dynamic> json) {
    return GoalQuestion(
      id: json['id'],
      sessionId: json['sessionId'],
      question: json['question'],
      options: List<String>.from(json['options']),
      order: json['order'],
      createdAt: DateTime.parse(json['createdAt']),
      answers: json['answers'] != null
          ? (json['answers'] as List)
                .map((a) => GoalAnswer.fromJson(a))
                .toList()
          : null,
    );
  }
}

class GoalAnswer {
  final String id;
  final String questionId;
  final String answer;
  final DateTime createdAt;

  GoalAnswer({
    required this.id,
    required this.questionId,
    required this.answer,
    required this.createdAt,
  });

  factory GoalAnswer.fromJson(Map<String, dynamic> json) {
    return GoalAnswer(
      id: json['id'],
      questionId: json['questionId'],
      answer: json['answer'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class NextQuestionResponse {
  final bool completed;
  final QuestionDetail? question;
  final int totalQuestions;
  final int answeredQuestions;

  NextQuestionResponse({
    required this.completed,
    this.question,
    required this.totalQuestions,
    required this.answeredQuestions,
  });

  factory NextQuestionResponse.fromJson(Map<String, dynamic> json) {
    return NextQuestionResponse(
      completed: json['completed'],
      question: json['question'] != null
          ? QuestionDetail.fromJson(json['question'])
          : null,
      totalQuestions: json['totalQuestions'],
      answeredQuestions: json['answeredQuestions'],
    );
  }
}

class QuestionDetail {
  final String id;
  final String question;
  final List<String> options;
  final int order;

  QuestionDetail({
    required this.id,
    required this.question,
    required this.options,
    required this.order,
  });

  factory QuestionDetail.fromJson(Map<String, dynamic> json) {
    return QuestionDetail(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      order: json['order'],
    );
  }
}
