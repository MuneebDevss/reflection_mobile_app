import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/goal.dart';
import '../../../providers/providers.dart';
import '../widgets/date_section_header.dart';
import '../widgets/history_task_item.dart';
import '../widgets/history_stats_card.dart';

class TaskHistoryView extends ConsumerWidget {
  final Goal goal;

  const TaskHistoryView({super.key, required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taskHistoryViewModelProvider(goal));

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
        title: const Text(
          AppStrings.taskHistoryTitle,
          style: TextStyle(
            color: AppColors.textWhite,
            fontSize: AppSizes.fontXXL,
            fontWeight: FontWeight.w700,
          ),
        ),
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
                            .read(taskHistoryViewModelProvider(goal).notifier)
                            .loadHistory();
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
                    .read(taskHistoryViewModelProvider(goal).notifier)
                    .loadHistory();
              },
              child: CustomScrollView(
                slivers: [
                  // Stats card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.paddingL),
                      child: HistoryStatsCard(state: state),
                    ),
                  ),

                  // History sections
                  if (state.groupedTasks.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSizes.paddingXL),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.history_rounded,
                                size: AppSizes.iconXXL,
                                color: AppColors.textLight.withOpacity(0.5),
                              ),
                              const SizedBox(height: AppSizes.spaceL),
                              Text(
                                AppStrings.noHistoryYet,
                                style: TextStyle(
                                  fontSize: AppSizes.fontXL,
                                  color: AppColors.textLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: AppSizes.spaceM),
                              Text(
                                AppStrings.completeTasksHint,
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
                    ...state.groupedTasks.entries.map((entry) {
                      final date = entry.key;
                      final tasks = entry.value;

                      return SliverMainAxisGroup(
                        slivers: [
                          SliverToBoxAdapter(
                            child: DateSectionHeader(date: date),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.paddingL,
                            ),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                return HistoryTaskItem(task: tasks[index]);
                              }, childCount: tasks.length),
                            ),
                          ),
                        ],
                      );
                    }).toList(),

                  // Bottom padding
                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppSizes.paddingXL),
                  ),
                ],
              ),
            ),
    );
  }
}
