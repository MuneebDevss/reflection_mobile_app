import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../data/models/goal.dart';

class GoalHeaderCard extends StatelessWidget {
  final Goal goal;

  const GoalHeaderCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
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
          Text(
            goal.title,
            style: const TextStyle(
              fontSize: AppSizes.fontXXXL,
              fontWeight: FontWeight.w700,
              color: AppColors.textWhite,
              height: 1.2,
            ),
          ),
          if (goal.description != null && goal.description!.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spaceM),
            Text(
              goal.description!,
              style: TextStyle(
                fontSize: AppSizes.fontL,
                color: AppColors.textWhite.withOpacity(0.9),
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
