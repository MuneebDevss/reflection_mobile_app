import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/goals/view/my_goals_view.dart';
import 'features/auth/view/login_screen.dart';
import 'core/constants/app_strings.dart';
import 'core/constants/app_colors.dart';
import 'providers/providers.dart';
import 'features/auth/state/auth_state.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.scaffoldBackground,
      ),
      home: const AuthWrapper(),
    );
  }
}

/// Wrapper widget that handles authentication state
/// Shows login screen or home screen based on authentication status
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    // Show loading screen while checking authentication status
    if (authState.status == AuthStatus.initial) {
      return const Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryPurple),
        ),
      );
    }

    // Show home screen if authenticated, otherwise show login screen
    if (authState.isAuthenticated && authState.user != null) {
      return MyGoalsView(userId: authState.user!.id);
    }

    return const LoginScreen();
  }
}
