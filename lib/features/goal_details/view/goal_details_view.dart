import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_durations.dart';
import '../../../data/models/goal.dart';
import '../../../providers/providers.dart';
import '../widgets/goal_header_card.dart';
import '../widgets/progress_card.dart';
import '../widgets/metadata_cards.dart';
import '../widgets/task_card.dart';
import '../../task_history/view/task_history_view.dart';

class GoalDetailsView extends ConsumerStatefulWidget {
  final Goal goal;

  const GoalDetailsView({super.key, required this.goal});

  @override
  ConsumerState<GoalDetailsView> createState() => _GoalDetailsViewState();
}

class _GoalDetailsViewState extends ConsumerState<GoalDetailsView> {
  bool _isGenerating = false;

  Future<void> _generateTasks() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      await ref
          .read(goalDetailsViewModelProvider(widget.goal).notifier)
          .generateTasks();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.tasksGeneratedSuccess),
            backgroundColor: AppColors.successGreen,
            duration: AppDurations.snackbarShort,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppStrings.tasksGeneratedError}: $e'),
            backgroundColor: AppColors.errorRed,
            duration: AppDurations.snackbarLong,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  Future<void> _toggleTaskStatus(String taskId) async {
    try {
      await ref
          .read(goalDetailsViewModelProvider(widget.goal).notifier)
          .toggleTaskStatus(taskId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppStrings.taskToggleError}: $e'),
            backgroundColor: AppColors.errorRed,
            duration: AppDurations.snackbarShort,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(goalDetailsViewModelProvider(widget.goal));

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
          onPressed: () => Navigator.of(context).pop(true),
        ),
        title: const Text(
          AppStrings.goalDetailsTitle,
          style: TextStyle(
            color: AppColors.textWhite,
            fontSize: AppSizes.fontXXL,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: AppColors.textWhite),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TaskHistoryView(goal: widget.goal),
                ),
              );
            },
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryPurple),
            )
          : state.error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingXL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: AppSizes.iconXXL,
                      color: AppColors.errorRed,
                    ),
                    const SizedBox(height: AppSizes.spaceL),
                    Text(
                      state.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: AppSizes.fontL,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceXL),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref
                            .read(
                              goalDetailsViewModelProvider(
                                widget.goal,
                              ).notifier,
                            )
                            .loadTasks();
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text(AppStrings.retry),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: AppColors.textWhite,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingXL,
                          vertical: AppSizes.paddingM,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : RefreshIndicator(
              color: AppColors.primaryPurple,
              onRefresh: () async {
                await ref
                    .read(goalDetailsViewModelProvider(widget.goal).notifier)
                    .loadTasks();
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.paddingL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          GoalHeaderCard(goal: widget.goal),
                          const SizedBox(height: AppSizes.spaceL),

                          // Progress
                          ProgressCard(goal: widget.goal),
                          const SizedBox(height: AppSizes.spaceL),

                          // Metadata
                          MetadataCards(goal: widget.goal),
                          const SizedBox(height: AppSizes.spaceXL),

                          // Tasks header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                AppStrings.todaysTasks,
                                style: TextStyle(
                                  fontSize: AppSizes.fontXXL,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                ),
                              ),
                              if (state.tasks.isEmpty && !_isGenerating)
                                TextButton.icon(
                                  onPressed: _generateTasks,
                                  icon: const Icon(Icons.auto_awesome_rounded),
                                  label: const Text(AppStrings.generateTasks),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.primaryPurple,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: AppSizes.spaceM),
                        ],
                      ),
                    ),
                  ),

                  // Tasks list
                  if (_isGenerating)
                    const SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: AppColors.primaryPurple,
                            ),
                            SizedBox(height: AppSizes.spaceL),
                            Text(
                              AppStrings.generatingTasks,
                              style: TextStyle(
                                fontSize: AppSizes.fontL,
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (state.tasks.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSizes.paddingXL),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.task_alt_rounded,
                                size: AppSizes.iconXXL,
                                color: AppColors.textLight.withOpacity(0.5),
                              ),
                              const SizedBox(height: AppSizes.spaceL),
                              Text(
                                AppStrings.noTasksYet,
                                style: TextStyle(
                                  fontSize: AppSizes.fontXL,
                                  color: AppColors.textLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: AppSizes.spaceM),
                              Text(
                                AppStrings.generateTasksHint,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: AppSizes.fontL,
                                  color: AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSizes.paddingL,
                        0,
                        AppSizes.paddingL,
                        AppSizes.paddingXL,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final task = state.tasks[index];
                          return TaskCard(
                            task: task,
                            onToggle: () => _toggleTaskStatus(task.id),
                          );
                        }, childCount: state.tasks.length),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
