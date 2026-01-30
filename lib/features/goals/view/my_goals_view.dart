import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../data/models/goal.dart';
import '../../../providers/providers.dart';
import '../../goal_creation/view/goal_creation_view.dart';
import '../widgets/goal_card.dart';
import '../widgets/dashboard_metrics_card.dart';

class MyGoalsView extends ConsumerWidget {
  final String userId;

  const MyGoalsView({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myGoalsViewModelProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.myGoalsTitle,
          style: TextStyle(
            fontSize: AppSizes.fontDisplay1,
            fontWeight: FontWeight.w700,
            color: AppColors.textWhite,
            letterSpacing: AppSizes.letterSpacingNormal,
          ),
        ),
        backgroundColor: AppColors.primaryPurple,
        elevation: AppSizes.appBarElevation,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.textWhite),
            onPressed: () {
              ref
                  .read(myGoalsViewModelProvider(userId).notifier)
                  .refreshGoals();
            },
          ),
          const SizedBox(width: AppSizes.spaceS),
        ],
      ),
      backgroundColor: AppColors.scaffoldBackground,
      body: CustomScrollView(
        slivers: [
          if (state.isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryPurple,
                  ),
                ),
              ),
            )
          else if (state.hasError)
            SliverFillRemaining(
              child: _ErrorState(
                errorMessage: state.errorMessage!,
                onRetry: () {
                  ref
                      .read(myGoalsViewModelProvider(userId).notifier)
                      .loadGoals();
                },
              ),
            )
          else if (!state.hasGoals)
            SliverFillRemaining(child: _EmptyState(userId: userId))
          else
            SliverList(
              delegate: SliverChildListDelegate([
                DashboardMetricsCard(stats: state.getDashboardStats()),
                _GoalsList(goals: state.goals!),
              ]),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GoalCreationView(userId: userId),
            ),
          );
          ref.read(myGoalsViewModelProvider(userId).notifier).refreshGoals();
        },
        icon: const Icon(Icons.add_rounded, size: AppSizes.iconM),
        label: const Text(
          AppStrings.newGoalButton,
          style: TextStyle(
            fontSize: AppSizes.fontXL,
            fontWeight: FontWeight.w600,
            letterSpacing: AppSizes.letterSpacingWide,
          ),
        ),
        backgroundColor: AppColors.primaryPurple,
        elevation: AppSizes.cardElevation,
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const _ErrorState({required this.errorMessage, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXXXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingXXL),
              decoration: BoxDecoration(
                color: AppColors.warningRed.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: AppSizes.iconXXL * 1.5,
                color: AppColors.warningRed,
              ),
            ),
            const SizedBox(height: AppSizes.spaceXXL),
            const Text(
              AppStrings.errorLoadingGoals,
              style: TextStyle(
                fontSize: AppSizes.fontDisplay1,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.spaceM),
            Text(
              errorMessage,
              style: const TextStyle(
                fontSize: AppSizes.fontL,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingXXXL),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(
                AppStrings.tryAgainButton,
                style: TextStyle(
                  fontSize: AppSizes.fontXL,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: AppColors.textWhite,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingXXXL,
                  vertical: AppSizes.paddingL,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusL),
                ),
                elevation: AppSizes.cardElevation / 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String userId;

  const _EmptyState({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXXXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingXL * 2),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowPurple,
                    blurRadius: AppSizes.blurL,
                    offset: const Offset(0, AppSizes.paddingM),
                  ),
                ],
              ),
              child: const Icon(
                Icons.track_changes_rounded,
                size: AppSizes.iconXXL * 2,
                color: AppColors.textWhite,
              ),
            ),
            const SizedBox(height: AppSizes.paddingXXXL),
            const Text(
              AppStrings.noGoalsMessage,
              style: TextStyle(
                fontSize: AppSizes.fontDisplay3,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: AppSizes.letterSpacingWide,
              ),
            ),
            const SizedBox(height: AppSizes.spaceM),
            const Text(
              AppStrings.noGoalsSubMessage,
              style: TextStyle(
                fontSize: AppSizes.fontXL,
                color: AppColors.textSecondary,
                height: AppSizes.lineHeightLoose,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingXL * 2),
            ElevatedButton.icon(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => GoalCreationView(userId: userId),
                  ),
                );
              },
              icon: const Icon(
                Icons.add_circle_outline_rounded,
                size: AppSizes.iconL,
              ),
              label: const Text(
                AppStrings.newGoalButton,
                style: TextStyle(
                  fontSize: AppSizes.fontXXL,
                  fontWeight: FontWeight.w700,
                  letterSpacing: AppSizes.letterSpacingWide,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: AppColors.textWhite,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingXXL * 1.5,
                  vertical: AppSizes.paddingXL,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusL),
                ),
                elevation: AppSizes.cardElevation,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalsList extends StatelessWidget {
  final List<Goal> goals;

  const _GoalsList({required this.goals});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.paddingXL,
        0,
        AppSizes.paddingXL,
        100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.goalsListTitle,
            style: TextStyle(
              fontSize: AppSizes.fontXXXL,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: AppSizes.letterSpacingNormal,
            ),
          ),
          const SizedBox(height: AppSizes.spaceL),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: goals.length,
            itemBuilder: (context, index) {
              return GoalCard(goal: goals[index]);
            },
          ),
        ],
      ),
    );
  }
}
