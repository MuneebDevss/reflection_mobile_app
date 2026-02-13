import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/services/auth_service.dart';
import '../state/auth_state.dart';

/// Auth ViewModel - manages authentication state
class AuthViewModel extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthViewModel(this._authService) : super(const AuthState.initial()) {
    // Check authentication status on initialization
    _checkAuthStatus();
  }

  /// Check if user is already authenticated on app start
  Future<void> _checkAuthStatus() async {
    try {
      final isAuth = await _authService.isAuthenticated();
      if (isAuth) {
        final user = await _authService.getStoredUser();
        if (user != null) {
          state = AuthState.authenticated(user);
        } else {
          state = const AuthState.unauthenticated();
        }
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = const AuthState.unauthenticated();
    }
  }

  /// Register a new user
  Future<void> register({
    required String email,
    required String password,
    String? name,
  }) async {
    state = const AuthState.loading();

    try {
      final authResponse = await _authService.register(
        email: email,
        password: password,
        name: name,
      );

      state = AuthState.authenticated(authResponse.user);
    } on AuthException catch (e) {
      state = AuthState.unauthenticated(e.message);
    } catch (e) {
      state = AuthState.unauthenticated('Registration failed: ${e.toString()}');
    }
  }

  /// Login with email and password
  Future<void> login({required String email, required String password}) async {
    state = const AuthState.loading();

    try {
      final authResponse = await _authService.login(
        email: email,
        password: password,
      );

      state = AuthState.authenticated(authResponse.user);
    } on AuthException catch (e) {
      state = AuthState.unauthenticated(e.message);
    } catch (e) {
      state = AuthState.unauthenticated('Login failed: ${e.toString()}');
    }
  }

  /// Logout current user
  Future<void> logout() async {
    try {
      await _authService.logout();
      state = const AuthState.unauthenticated();
    } catch (e) {
      // Even if logout fails, clear the state
      state = const AuthState.unauthenticated();
    }
  }

  /// Clear error message
  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(clearError: true);
    }
  }
}
