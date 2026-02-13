import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../data/models/goal.dart';

class GoalHeaderCard extends StatefulWidget {
  final Goal goal;

  const GoalHeaderCard({super.key, required this.goal});

  @override
  State<GoalHeaderCard> createState() => _GoalHeaderCardState();
}

class _GoalHeaderCardState extends State<GoalHeaderCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final goal = widget.goal;

    // Limit to 3 lines initially
    final descriptionText = goal.description ?? '';
    final shouldShowSeeMore = descriptionText.length > 100; // arbitrary cutoff

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
          if (descriptionText.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spaceM),
            Text(
              _isExpanded || !shouldShowSeeMore
                  ? descriptionText
                  : descriptionText.substring(0, 100) + '...', // preview text
              style: TextStyle(
                fontSize: AppSizes.fontL,
                color: AppColors.textWhite.withOpacity(0.9),
                height: 1.4,
              ),
            ),
            if (shouldShowSeeMore)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    setState(() => _isExpanded = !_isExpanded);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 20),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    _isExpanded ? 'See Less' : 'See More',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentYellow, // make it pop
                      fontSize: AppSizes.fontL,
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
