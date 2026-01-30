import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';

class DashboardMetricsCard extends StatelessWidget {
  final Map<String, dynamic> stats;

  const DashboardMetricsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSizes.paddingXL),
      padding: const EdgeInsets.all(AppSizes.paddingXXL),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
                child: const Icon(
                  Icons.dashboard_rounded,
                  color: AppColors.primaryPurple,
                  size: AppSizes.iconM,
                ),
              ),
              const SizedBox(width: AppSizes.spaceM),
              const Text(
                AppStrings.overviewLabel,
                style: TextStyle(
                  fontSize: AppSizes.fontXXXL,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: AppSizes.letterSpacingNormal,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceXXL),
          // Stats Grid
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  icon: Icons.emoji_events_rounded,
                  label: AppStrings.totalGoalsLabel,
                  value: stats['total'].toString(),
                  color: AppColors.primaryPurple,
                ),
              ),
              const SizedBox(width: AppSizes.spaceM),
              Expanded(
                child: _MetricCard(
                  icon: Icons.check_circle_rounded,
                  label: AppStrings.completedLabel,
                  value: stats['completed'].toString(),
                  color: AppColors.successGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceM),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  icon: Icons.trending_up_rounded,
                  label: AppStrings.inProgressLabel,
                  value: stats['inProgress'].toString(),
                  color: AppColors.infoBlue,
                ),
              ),
              const SizedBox(width: AppSizes.spaceM),
              Expanded(
                child: _MetricCard(
                  icon: Icons.warning_rounded,
                  label: AppStrings.overdueLabel,
                  value: stats['overdue'].toString(),
                  color: AppColors.warningRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingXL),
          const Divider(),
          const SizedBox(height: AppSizes.spaceL),
          // Average Progress
          Row(
            children: [
              const Text(
                AppStrings.averageProgressLabel,
                style: TextStyle(
                  fontSize: AppSizes.fontL,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  letterSpacing: AppSizes.letterSpacingTight,
                ),
              ),
              const Spacer(),
              Text(
                '${stats['avgProgress'].toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: AppSizes.fontXXL,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceM),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            child: LinearProgressIndicator(
              value: stats['avgProgress'] / 100,
              minHeight: AppSizes.progressIndicatorHeightL,
              backgroundColor: AppColors.progressBarBackground,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.getProgressColor(stats['avgProgress'].toInt()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: AppSizes.iconL),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            value,
            style: TextStyle(
              fontSize: AppSizes.fontDisplay3,
              fontWeight: FontWeight.w800,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: AppSizes.paddingXS),
          Text(
            label,
            style: TextStyle(
              fontSize: AppSizes.fontS,
              fontWeight: FontWeight.w600,
              color: color.withOpacity(0.8),
              letterSpacing: AppSizes.letterSpacingTight,
            ),
          ),
        ],
      ),
    );
  }
}
