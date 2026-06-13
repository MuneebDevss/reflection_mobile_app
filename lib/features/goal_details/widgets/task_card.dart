import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../data/models/daily_task.dart';

class TaskCard extends StatelessWidget {
  final DailyTask task;
  final VoidCallback onToggle;

  const TaskCard({super.key, required this.task, required this.onToggle});

  void _showTaskDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          TaskDetailsBottomSheet(task: task, onToggle: onToggle),
    );
  }

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
          onTap: () => _showTaskDetails(context),
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
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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

class TaskDetailsBottomSheet extends StatelessWidget {
  final DailyTask task;
  final VoidCallback onToggle;

  const TaskDetailsBottomSheet({
    super.key,
    required this.task,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = task.isPending;
    final isCompleted = task.isCompleted;
    final isSkipped = task.isSkipped;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXL),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: AppSizes.paddingM),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.paddingXL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: AppSizes.fontXL,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceM),

                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingM,
                        vertical: AppSizes.paddingS,
                      ),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppColors.successGreen.withOpacity(0.1)
                            : isSkipped
                            ? AppColors.warningOrange.withOpacity(0.1)
                            : AppColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusM),
                        border: Border.all(
                          color: isCompleted
                              ? AppColors.successGreen
                              : isSkipped
                              ? AppColors.warningOrange
                              : AppColors.primaryBlue,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isCompleted
                                ? Icons.check_circle
                                : isSkipped
                                ? Icons.cancel
                                : Icons.pending,
                            size: AppSizes.iconS,
                            color: isCompleted
                                ? AppColors.successGreen
                                : isSkipped
                                ? AppColors.warningOrange
                                : AppColors.primaryBlue,
                          ),
                          const SizedBox(width: AppSizes.spaceXS),
                          Text(
                            isCompleted
                                ? 'Completed'
                                : isSkipped
                                ? 'Skipped'
                                : 'Pending',
                            style: TextStyle(
                              fontSize: AppSizes.fontM,
                              fontWeight: FontWeight.w600,
                              color: isCompleted
                                  ? AppColors.successGreen
                                  : isSkipped
                                  ? AppColors.warningOrange
                                  : AppColors.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceL),

                    // Due Date
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSizes.paddingS),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusM,
                            ),
                          ),
                          child: const Icon(
                            Icons.calendar_today_rounded,
                            size: AppSizes.iconM,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        const SizedBox(width: AppSizes.spaceM),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Due Date',
                              style: TextStyle(
                                fontSize: AppSizes.fontS,
                                color: AppColors.textLight,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              DateFormat(
                                'EEEE, MMMM d, yyyy',
                              ).format(task.dueDate),
                              style: const TextStyle(
                                fontSize: AppSizes.fontM,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Description
                    if (task.description != null &&
                        task.description!.isNotEmpty) ...[
                      const SizedBox(height: AppSizes.spaceL),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: AppSizes.fontL,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: AppSizes.spaceS),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSizes.paddingL),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(AppSizes.radiusM),
                          border: Border.all(
                            color: AppColors.divider,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          task.description!,
                          style: const TextStyle(
                            fontSize: AppSizes.fontM,
                            color: AppColors.textDark,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: AppSizes.spaceXL),

                    // Action button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          onToggle();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isCompleted || isSkipped
                              ? AppColors.primaryBlue
                              : AppColors.successGreen,
                          foregroundColor: AppColors.textWhite,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.paddingL,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusM,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isCompleted || isSkipped
                                  ? Icons.refresh_rounded
                                  : Icons.check_rounded,
                              size: AppSizes.iconM,
                            ),
                            const SizedBox(width: AppSizes.spaceS),
                            Text(
                              isCompleted || isSkipped
                                  ? 'Mark as Pending'
                                  : 'Mark as Complete',
                              style: const TextStyle(
                                fontSize: AppSizes.fontL,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
