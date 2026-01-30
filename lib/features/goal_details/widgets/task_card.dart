import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../data/models/daily_task.dart';

class TaskCard extends StatelessWidget {
  final DailyTask task;
  final VoidCallback onToggle;

  const TaskCard({super.key, required this.task, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final isPending = task.isPending;
    final isCompleted = task.isCompleted;
    final isSkipped = task.isSkipped;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(
          color: isCompleted
              ? AppColors.successGreen.withOpacity(0.3)
              : isSkipped
              ? AppColors.warningOrange.withOpacity(0.3)
              : AppColors.divider,
          width: 2,
        ),
        boxShadow: [
          if (isCompleted || isSkipped)
            BoxShadow(
              color:
                  (isCompleted
                          ? AppColors.successGreen
                          : AppColors.warningOrange)
                      .withOpacity(0.1),
              blurRadius: AppSizes.blurM,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
          onTap: isPending ? onToggle : null,
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            child: Row(
              children: [
                // Status checkbox
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.successGreen
                        : isSkipped
                        ? AppColors.warningOrange
                        : AppColors.cardBackground,
                    border: Border.all(
                      color: isCompleted
                          ? AppColors.successGreen
                          : isSkipped
                          ? AppColors.warningOrange
                          : AppColors.divider,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.radiusS),
                  ),
                  child: isCompleted
                      ? const Icon(
                          Icons.check_rounded,
                          color: AppColors.textWhite,
                          size: AppSizes.iconS,
                        )
                      : isSkipped
                      ? const Icon(
                          Icons.close_rounded,
                          color: AppColors.textWhite,
                          size: AppSizes.iconS,
                        )
                      : null,
                ),
                const SizedBox(width: AppSizes.spaceM),
                // Task details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: AppSizes.fontL,
                          fontWeight: FontWeight.w600,
                          color: isCompleted || isSkipped
                              ? AppColors.textLight
                              : AppColors.textDark,
                          decoration: isCompleted || isSkipped
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      if (task.description != null &&
                          task.description!.isNotEmpty) ...[
                        const SizedBox(height: AppSizes.spaceXS),
                        Text(
                          task.description!,
                          style: TextStyle(
                            fontSize: AppSizes.fontM,
                            color: AppColors.textLight,
                            decoration: isCompleted || isSkipped
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSizes.spaceS),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: AppSizes.iconXS,
                            color: AppColors.textLight,
                          ),
                          const SizedBox(width: AppSizes.spaceXS),
                          Text(
                            DateFormat('MMM d, yyyy').format(task.dueDate),
                            style: const TextStyle(
                              fontSize: AppSizes.fontS,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Status badge
                if (isCompleted || isSkipped)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingM,
                      vertical: AppSizes.paddingXS,
                    ),
                    decoration: BoxDecoration(
                      color:
                          (isCompleted
                                  ? AppColors.successGreen
                                  : AppColors.warningOrange)
                              .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    ),
                    child: Text(
                      isCompleted ? 'Done' : 'Skipped',
                      style: TextStyle(
                        fontSize: AppSizes.fontS,
                        fontWeight: FontWeight.w600,
                        color: isCompleted
                            ? AppColors.successGreen
                            : AppColors.warningOrange,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
