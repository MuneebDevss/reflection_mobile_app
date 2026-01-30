import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../data/models/goal.dart';

class MetadataCards extends StatelessWidget {
  final Goal goal;

  const MetadataCards({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final daysRemaining = goal.deadline.difference(DateTime.now()).inDays;

    return Row(
      children: [
        Expanded(
          child: _MetadataCard(
            icon: Icons.calendar_today_rounded,
            iconColor: AppColors.primaryBlue,
            title: 'Deadline',
            value: DateFormat('MMM d, yyyy').format(goal.deadline),
          ),
        ),
        const SizedBox(width: AppSizes.spaceM),
        Expanded(
          child: _MetadataCard(
            icon: Icons.schedule_rounded,
            iconColor: daysRemaining < 7
                ? AppColors.errorRed
                : AppColors.successGreen,
            title: 'Days Left',
            value: daysRemaining > 0 ? '$daysRemaining days' : 'Overdue',
          ),
        ),
      ],
    );
  }
}

class _MetadataCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  const _MetadataCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

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
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingS),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
            child: Icon(icon, color: iconColor, size: AppSizes.iconM),
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            title,
            style: const TextStyle(
              fontSize: AppSizes.fontM,
              color: AppColors.textLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSizes.spaceXS),
          Text(
            value,
            style: const TextStyle(
              fontSize: AppSizes.fontL,
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
