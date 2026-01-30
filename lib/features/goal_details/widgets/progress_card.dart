import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../data/models/goal.dart';

class ProgressCard extends StatelessWidget {
  final Goal goal;

  const ProgressCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: AppSizes.blurM,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSizes.paddingXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progress',
                style: TextStyle(
                  fontSize: AppSizes.fontXL,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingM,
                  vertical: AppSizes.paddingXS,
                ),
                decoration: BoxDecoration(
                  color: AppColors.getProgressColor(
                    goal.progress,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
                child: Text(
                  '${goal.progress}%',
                  style: TextStyle(
                    fontSize: AppSizes.fontL,
                    fontWeight: FontWeight.w700,
                    color: AppColors.getProgressColor(goal.progress),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceL),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            child: LinearProgressIndicator(
              value: goal.progress / 100,
              backgroundColor: AppColors.progressBarBackground,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.getProgressColor(goal.progress),
              ),
              minHeight: AppSizes.progressBarHeight,
            ),
          ),
        ],
      ),
    );
  }
}
