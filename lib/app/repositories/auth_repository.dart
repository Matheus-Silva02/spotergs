// file: lib/app/repositories/auth_repository.dart

import 'package:get/get.dart';
import 'package:spotergs/app/core/services/api_service.dart';
import 'package:spotergs/app/utils/constants.dart';

/// Repository for authentication operations
/// All methods return dynamic data (Map<String, dynamic> or null)
/// Expected response format (no auth header required):
/// Login/Register: { "user": { "id": "...", "name": "...", "email": "..." } }
/// Guest: { "guestId": "...", "nickname": "..." } (LOCAL ONLY)
class AuthRepository {
  final ApiService _apiService = Get.find<ApiService>();

  /// Login with username and password
  /// Returns: { "status": "success", "message": "User logged in successfully" }
  Future<dynamic> login({
    required String name,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        Constants.loginEndpoint,
        params: {
          'name': name,
          'password': password,
        },
      );
      return response;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  /// Register new user
  /// Returns: { "status": "success", "message": "User registered successfully" }
  Future<dynamic> register({
    required String name,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        Constants.registerEndpoint,
        params: {
          'name': name,
          'password': password,
          'password_confirm': password,
        },
      );
      return response;
    } catch (e) {
      print('Register error: $e');
      return null;
    }
  }

  /// Login as guest with nickname (LOCAL ONLY - no backend request)
  /// Returns: { "guestId": "...", "nickname": "..." }
  Future<dynamic> guestLogin({
    required String nickname,
  }) async {
    // Validate nickname locally
    if (nickname.trim().isEmpty) {
      throw Exception('Nickname cannot be empty');
    }
    
    if (nickname.length < 3) {
      throw Exception('Nickname must be at least 3 characters');
    }
    
    if (nickname.length > 50) {
      throw Exception('Nickname must not exceed 50 characters');
    }
    
    // Generate a local guest ID
    final guestId = 'guest_${DateTime.now().millisecondsSinceEpoch}';
    
    // Return guest data without making any API request
    return {
      'guestId': guestId,
      'nickname': nickname,
    };
  }

  /// Logout current user
  /// Returns: { "success": true }
  Future<dynamic> logout() async {
    try {
      final response = await _apiService.post(Constants.logoutEndpoint);
      return response;
    } catch (e) {
      print('Logout error: $e');
      return null;
    }
  }

  /// Get current user profile
  /// Returns: { "id": "...", "name": "...", "email": "..." }
  Future<dynamic> getProfile() async {
    try {
      final response = await _apiService.get('/auth/profile');
      return response;
    } catch (e) {
      print('Get profile error: $e');
      return null;
    }
  }

  /// Update user profile
  /// Returns: { "id": "...", "name": "...", "email": "..." }
  Future<dynamic> updateProfile({
    String? name,
    String? email,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (email != null) data['email'] = email;

      final response = await _apiService.put(
        '/auth/profile',
        data: data,
      );
      return response;
    } catch (e) {
      print('Update profile error: $e');
      return null;
    }
  }

  /// Change password
  /// Returns: { "success": true }
  Future<dynamic> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/change-password',
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
      return response;
    } catch (e) {
      print('Change password error: $e');
      return null;
    }
  }
}
