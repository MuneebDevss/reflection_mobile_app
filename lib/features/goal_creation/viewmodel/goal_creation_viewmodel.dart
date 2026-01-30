import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_durations.dart';
import '../../../data/models/chat_message.dart';
import '../../../data/repositories/goal_session_repository.dart';
import '../state/goal_creation_state.dart';

class GoalCreationViewModel extends StateNotifier<GoalCreationState> {
  final GoalSessionRepository _sessionRepository;
  final String userId;

  GoalCreationViewModel(this._sessionRepository, this.userId)
    : super(GoalCreationState.initial()) {
    _startConversation();
  }

  Future<void> _startConversation() async {
    await Future.delayed(AppDurations.messageDelay);
    _addSystemMessage("Hi! 👋 I'm here to help you create a new goal.");

    await Future.delayed(AppDurations.botResponseDelay);
    _addSystemMessage("What goal do you want to work on?");

    state = state.copyWith(inputEnabled: true);
  }

  void _addSystemMessage(String text) {
    state = state.copyWith(isTyping: true);

    Future.delayed(AppDurations.typingDelay, () {
      final newMessage = ChatMessage(text: text, sender: MessageSender.system);
      state = state.copyWith(
        messages: [...state.messages, newMessage],
        isTyping: false,
      );
    });
  }

  void addUserMessage(String text) {
    final newMessage = ChatMessage(text: text, sender: MessageSender.user);
    state = state.copyWith(
      messages: [...state.messages, newMessage],
      inputEnabled: false,
    );
  }

  Future<void> handleSubmit(String text) async {
    addUserMessage(text);

    if (state.sessionId == null) {
      await _createSession(text);
    } else if (state.currentQuestion != null) {
      await _answerQuestion(text);
    }
  }

  Future<void> _createSession(String rawGoalText) async {
    state = state.copyWith(isProcessing: true, clearError: true);

    try {
      final session = await _sessionRepository.createSession(
        userId: userId,
        rawGoalText: rawGoalText,
      );

      state = state.copyWith(sessionId: session.id, isProcessing: false);

      await Future.delayed(AppDurations.typingDelay);
      _addSystemMessage(
        "Great choice! Let me ask you a few questions to help you succeed.",
      );

      await Future.delayed(AppDurations.botResponseDelay);
      await _fetchNextQuestion();
    } catch (e) {
      state = state.copyWith(isProcessing: false, errorMessage: e.toString());
      _addSystemMessage(
        "Oops! Something went wrong: ${e.toString()}. Please try again.",
      );
      state = state.copyWith(inputEnabled: true);
    }
  }

  Future<void> _fetchNextQuestion() async {
    if (state.sessionId == null) return;

    state = state.copyWith(isProcessing: true, clearError: true);

    try {
      final response = await _sessionRepository.getNextQuestion(
        state.sessionId!,
      );

      state = state.copyWith(
        totalQuestions: response.totalQuestions,
        answeredQuestions: response.answeredQuestions,
        isProcessing: false,
      );

      if (response.completed) {
        _addSystemMessage(
          "Perfect! I have everything I need. Creating your goal now... ✨",
        );
        await Future.delayed(AppDurations.botResponseDelay);
        await _completeSession();
      } else {
        state = state.copyWith(currentQuestion: response.question);
        _addSystemMessage(response.question!.question);

        if (response.question!.options.isNotEmpty) {
          await Future.delayed(AppDurations.normal);
          _addSystemMessage(
            "You can type your own answer or choose from these suggestions:",
          );
        }

        state = state.copyWith(inputEnabled: true);
      }
    } catch (e) {
      state = state.copyWith(isProcessing: false, errorMessage: e.toString());
      _addSystemMessage(
        "Oops! Something went wrong: ${e.toString()}. Please try again.",
      );
      state = state.copyWith(inputEnabled: true);
    }
  }

  Future<void> _answerQuestion(String answerText) async {
    if (state.currentQuestion == null) return;

    state = state.copyWith(isProcessing: true, clearError: true);

    try {
      await _sessionRepository.answerQuestion(
        questionId: state.currentQuestion!.id,
        answerText: answerText,
      );

      state = state.copyWith(isProcessing: false);

      _addSystemMessage("Got it! 👍");
      await Future.delayed(AppDurations.normal);
      await _fetchNextQuestion();
    } catch (e) {
      state = state.copyWith(isProcessing: false, errorMessage: e.toString());
      _addSystemMessage(
        "Oops! Something went wrong: ${e.toString()}. Please try again.",
      );
      state = state.copyWith(inputEnabled: true);
    }
  }

  Future<void> _completeSession() async {
    if (state.sessionId == null) return;

    try {
      final session = await _sessionRepository.completeSession(
        state.sessionId!,
      );

      if (session.goal != null) {
        _addSystemMessage(
          "🎉 Success! Your goal '${session.goal!.title}' has been created!",
        );

        await Future.delayed(AppDurations.botResponseDelay);
        state = state.copyWith(isCompleted: true);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      _addSystemMessage(
        "Oops! Failed to create goal: ${e.toString()}. Please try again.",
      );
    }
  }
}
