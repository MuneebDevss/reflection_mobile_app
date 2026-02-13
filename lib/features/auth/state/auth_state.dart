import 'package:reflection_frontend/data/models/user.dart';

/// Authentication state
enum AuthStatus { initial, authenticated, unauthenticated, loading }

/// Auth state class
class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AuthState({required this.status, this.user, this.errorMessage});

  const AuthState.initial()
    : status = AuthStatus.initial,
      user = null,
      errorMessage = null;

  const AuthState.loading()
    : status = AuthStatus.loading,
      user = null,
      errorMessage = null;

  const AuthState.authenticated(User user)
    : status = AuthStatus.authenticated,
      user = user,
      errorMessage = null;

  const AuthState.unauthenticated([String? errorMessage])
    : status = AuthStatus.unauthenticated,
      user = null,
      errorMessage = errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
}
