import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../data/models/daily_task.dart';

class HistoryTaskItem extends StatelessWidget {
  final DailyTask task;

  const HistoryTaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(
          color: isCompleted
              ? AppColors.successGreen.withOpacity(0.2)
              : AppColors.warningOrange.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Row(
        children: [
          // Status icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color:
                  (isCompleted
                          ? AppColors.successGreen
                          : AppColors.warningOrange)
                      .withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
            child: Icon(
              isCompleted ? Icons.check_circle_rounded : Icons.cancel_rounded,
              color: isCompleted
                  ? AppColors.successGreen
                  : AppColors.warningOrange,
              size: AppSizes.iconM,
            ),
          ),
          const SizedBox(width: AppSizes.spaceM),

          // Task info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: AppSizes.fontL,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
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
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Status badge
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
    );
  }
}
