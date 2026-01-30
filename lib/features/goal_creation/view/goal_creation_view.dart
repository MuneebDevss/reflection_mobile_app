import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_durations.dart';
import '../../../providers/providers.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/typing_indicator.dart';

class GoalCreationView extends ConsumerStatefulWidget {
  final String userId;

  const GoalCreationView({super.key, required this.userId});

  @override
  ConsumerState<GoalCreationView> createState() => _GoalCreationViewState();
}

class _GoalCreationViewState extends ConsumerState<GoalCreationView> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(AppDurations.veryFast, () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: AppDurations.scrollAnimation,
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSubmit() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    ref
        .read(goalCreationViewModelProvider(widget.userId).notifier)
        .handleSubmit(text);
    _textController.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(goalCreationViewModelProvider(widget.userId));

    // Listen for completion
    ref.listen(goalCreationViewModelProvider(widget.userId), (previous, next) {
      if (next.isCompleted && !next.isProcessing) {
        Future.delayed(AppDurations.slow, () {
          if (mounted) {
            Navigator.of(context).pop(true);
          }
        });
      }
      _scrollToBottom();
    });

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryPurple,
        elevation: AppSizes.appBarElevation,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textWhite,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.newGoalTitle,
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: AppSizes.fontXXL,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (state.totalQuestions > 0)
              Text(
                'Question ${state.answeredQuestions + 1} of ${state.totalQuestions}',
                style: TextStyle(
                  color: AppColors.textWhite.withOpacity(0.8),
                  fontSize: AppSizes.fontS,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Progress indicator
          if (state.totalQuestions > 0)
            LinearProgressIndicator(
              value: state.answeredQuestions / state.totalQuestions,
              backgroundColor: AppColors.progressBarBackground,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.successGreen,
              ),
              minHeight: AppSizes.paddingXS,
            ),
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingL),
              itemCount: state.messages.length + (state.isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.messages.length) {
                  return const TypingIndicator();
                }
                return ChatMessageBubble(
                  message: state.messages[index],
                  index: index,
                );
              },
            ),
          ),
          // Input area
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: AppSizes.blurM,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      enabled: state.inputEnabled && !state.isProcessing,
                      decoration: InputDecoration(
                        hintText: AppStrings.typeMessagePlaceholder,
                        hintStyle: const TextStyle(
                          color: AppColors.textLight,
                          fontSize: AppSizes.fontL,
                        ),
                        filled: true,
                        fillColor: AppColors.scaffoldBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusXL,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingXL,
                          vertical: AppSizes.paddingM,
                        ),
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) => _handleSubmit(),
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceM),
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: AppColors.primaryGradient,
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                    ),
                    child: IconButton(
                      onPressed: (state.inputEnabled && !state.isProcessing)
                          ? _handleSubmit
                          : null,
                      icon: const Icon(
                        Icons.send_rounded,
                        color: AppColors.textWhite,
                      ),
                      iconSize: AppSizes.iconM,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
