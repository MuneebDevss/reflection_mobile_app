import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../state/task_history_state.dart';

class HistoryStatsCard extends StatelessWidget {
  final TaskHistoryState state;

  const HistoryStatsCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final completionRate = state.totalTasks > 0
        ? (state.completedTasks / state.totalTasks * 100).toInt()
        : 0;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withOpacity(0.3),
            blurRadius: AppSizes.blurL,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSizes.paddingXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Progress',
            style: TextStyle(
              fontSize: AppSizes.fontXL,
              fontWeight: FontWeight.w700,
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: AppSizes.spaceL),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.check_circle_rounded,
                  label: 'Completed',
                  value: '${state.completedTasks}',
                ),
              ),
              Expanded(
                child: _StatItem(
                  icon: Icons.cancel_rounded,
                  label: 'Skipped',
                  value: '${state.skippedTasks}',
                ),
              ),
              Expanded(
                child: _StatItem(
                  icon: Icons.trending_up_rounded,
                  label: 'Rate',
                  value: '$completionRate%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.textWhite, size: AppSizes.iconL),
        const SizedBox(height: AppSizes.spaceS),
        Text(
          value,
          style: const TextStyle(
            fontSize: AppSizes.fontXXL,
            fontWeight: FontWeight.w700,
            color: AppColors.textWhite,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: AppSizes.fontM,
            color: AppColors.textWhite.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
