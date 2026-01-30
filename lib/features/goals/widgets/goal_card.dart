import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/goal.dart';
import '../../goal_details/view/goal_details_view.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;

  const GoalCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final daysUntilDeadline = goal.deadline.difference(DateTime.now()).inDays;
    final isOverdue = daysUntilDeadline < 0;
    final isCompleted = goal.progress == 100;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceL),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: AppSizes.blurM,
            offset: const Offset(0, AppSizes.paddingXS),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => GoalDetailsView(goal: goal),
              ),
            );
          },
          borderRadius: BorderRadius.circular(AppSizes.radiusXL),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingXL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Icon
                    Container(
                      padding: const EdgeInsets.all(AppSizes.paddingM),
                      decoration: BoxDecoration(
                        color: AppColors.getProgressColor(
                          goal.progress,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusM),
                      ),
                      child: Icon(
                        isCompleted
                            ? Icons.check_circle_rounded
                            : Icons.pending_rounded,
                        color: AppColors.getProgressColor(goal.progress),
                        size: AppSizes.iconM,
                      ),
                    ),
                    const SizedBox(width: AppSizes.spaceM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            goal.title,
                            style: const TextStyle(
                              fontSize: AppSizes.fontXXL,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              letterSpacing: AppSizes.letterSpacingTight,
                            ),
                          ),
                          if (goal.description != null &&
                              goal.description!.isNotEmpty) ...[
                            const SizedBox(height: AppSizes.spaceS / 2),
                            Text(
                              goal.description!,
                              style: const TextStyle(
                                fontSize: AppSizes.fontM,
                                color: AppColors.textSecondary,
                                height: AppSizes.lineHeightLoose,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSizes.spaceS),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingM + 2,
                        vertical: AppSizes.spaceS,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.getProgressColor(goal.progress),
                            AppColors.getProgressColor(
                              goal.progress,
                            ).withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(AppSizes.radiusM),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.getProgressColor(
                              goal.progress,
                            ).withOpacity(0.3),
                            blurRadius: AppSizes.spaceS,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '${goal.progress}%',
                        style: const TextStyle(
                          fontSize: AppSizes.fontL,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textWhite,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.paddingXL),
                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  child: LinearProgressIndicator(
                    value: goal.progress / 100,
                    minHeight: AppSizes.progressIndicatorHeightL,
                    backgroundColor: AppColors.progressBarBackground,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.getProgressColor(goal.progress),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.spaceL),
                // Footer Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.spaceM,
                        vertical: AppSizes.spaceS / 2,
                      ),
                      decoration: BoxDecoration(
                        color: isOverdue
                            ? AppColors.warningRed.withOpacity(0.1)
                            : AppColors.textLight.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(AppSizes.radiusS),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: AppSizes.iconS,
                            color: isOverdue
                                ? AppColors.warningRed
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: AppSizes.spaceS / 2),
                          Text(
                            _formatDeadline(goal.deadline),
                            style: TextStyle(
                              fontSize: AppSizes.fontS,
                              fontWeight: FontWeight.w600,
                              color: isOverdue
                                  ? AppColors.warningRed
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (isCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.spaceM,
                          vertical: AppSizes.spaceS / 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.successGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppSizes.radiusS),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              size: AppSizes.iconS,
                              color: AppColors.successGreen,
                            ),
                            const SizedBox(width: AppSizes.paddingXS),
                            const Text(
                              AppStrings.completedLabel,
                              style: TextStyle(
                                fontSize: AppSizes.fontS,
                                fontWeight: FontWeight.w700,
                                color: AppColors.successGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDeadline(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now).inDays;

    if (difference < 0) {
      return '${AppStrings.overdueByLabel} ${-difference} ${-difference == 1 ? AppStrings.dayLabel : AppStrings.daysLabel}';
    } else if (difference == 0) {
      return AppStrings.todayLabel;
    } else if (difference == 1) {
      return 'Due tomorrow';
    } else if (difference <= 7) {
      return '${AppStrings.dueInLabel} $difference ${AppStrings.daysLabel}';
    } else {
      return 'Due ${DateFormat('MMM dd').format(deadline)}';
    }
  }
}
