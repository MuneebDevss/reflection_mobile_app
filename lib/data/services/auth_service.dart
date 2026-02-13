import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

/// Exception thrown when authentication fails
class AuthException implements Exception {
  final String message;
  final int? statusCode;

  AuthException(this.message, [this.statusCode]);

  @override
  String toString() =>
      'AuthException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Service for handling authentication operations
class AuthService {
  // Update this to match your backend URL
  static const String baseUrl = 'https://reflection-backend-r7uw.onrender.com';

  // Secure storage for JWT token
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const String _tokenKey = 'jwt_token';
  static const String _userKey = 'user_data';

  /// Register a new user
  Future<AuthResponse> register({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final request = RegisterRequest(
        email: email,
        password: password,
        name: name,
      );

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        final authResponse = AuthResponse.fromJson(jsonData);

        // Store token and user data securely
        await _saveAuthData(authResponse);

        return authResponse;
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Registration failed';
        throw AuthException(errorMessage, response.statusCode);
      }
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw AuthException('Network error: ${e.toString()}');
    }
  }

  /// Login with email and password
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final request = LoginRequest(email: email, password: password);

      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final authResponse = AuthResponse.fromJson(jsonData);

        // Store token and user data securely
        await _saveAuthData(authResponse);

        return authResponse;
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Login failed';
        throw AuthException(errorMessage, response.statusCode);
      }
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw AuthException('Network error: ${e.toString()}');
    }
  }

  /// Logout and clear stored credentials
  Future<void> logout() async {
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _userKey);
  }

  /// Get stored JWT token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  /// Get stored user data
  Future<User?> getStoredUser() async {
    try {
      final userData = await _secureStorage.read(key: _userKey);
      if (userData != null) {
        final jsonData = jsonDecode(userData);
        return User.fromJson(jsonData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Check if user is authenticated (has valid token)
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Save authentication data securely
  Future<void> _saveAuthData(AuthResponse authResponse) async {
    await _secureStorage.write(key: _tokenKey, value: authResponse.accessToken);
    await _secureStorage.write(
      key: _userKey,
      value: jsonEncode(authResponse.user.toJson()),
    );
  }

  /// Get authorization header with Bearer token
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw AuthException('No authentication token found');
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
