import 'package:flutter/foundation.dart';
import '../../../data/models/chat_message.dart';
import '../../../data/models/goal_session.dart';

@immutable
class GoalCreationState {
  final List<ChatMessage> messages;
  final bool isTyping;
  final bool inputEnabled;
  final bool isProcessing;
  final String? errorMessage;
  final String? sessionId;
  final QuestionDetail? currentQuestion;
  final int totalQuestions;
  final int answeredQuestions;
  final bool isCompleted;

  const GoalCreationState({
    this.messages = const [],
    this.isTyping = false,
    this.inputEnabled = false,
    this.isProcessing = false,
    this.errorMessage,
    this.sessionId,
    this.currentQuestion,
    this.totalQuestions = 0,
    this.answeredQuestions = 0,
    this.isCompleted = false,
  });

  factory GoalCreationState.initial() {
    return const GoalCreationState();
  }

  GoalCreationState copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
    bool? inputEnabled,
    bool? isProcessing,
    String? errorMessage,
    String? sessionId,
    QuestionDetail? currentQuestion,
    int? totalQuestions,
    int? answeredQuestions,
    bool? isCompleted,
    bool clearError = false,
  }) {
    return GoalCreationState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      inputEnabled: inputEnabled ?? this.inputEnabled,
      isProcessing: isProcessing ?? this.isProcessing,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      sessionId: sessionId ?? this.sessionId,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      answeredQuestions: answeredQuestions ?? this.answeredQuestions,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
