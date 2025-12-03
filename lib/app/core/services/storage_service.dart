// file: lib/app/core/services/storage_service.dart

// file: lib/app/core/services/storage_service.dart

import 'dart:convert';

import 'package:get/get.dart';

/// Service for simple storage
/// Stores data in memory (for development/demonstration)
/// In production, use flutter_secure_storage or hive
class StorageService extends GetxService {
  // In-memory storage
  final Map<String, String> _storage = {};

  // Storage keys
  static const String _keyUserId = 'user_id';
  static const String _keyNickname = 'nickname';
  static const String _keyIsGuest = 'is_guest';
  static const String _keyToken = 'auth_token';
  static const String _keyUsername = 'username';
  static const String _keyFavorites = 'favorites';

  Future<StorageService> init() async {
    return this;
  }

  // User ID operations
  Future<void> saveUserId(String userId) async {
    _storage[_keyUserId] = userId;
  }

  Future<String?> getUserId() async {
    return _storage[_keyUserId];
  }

  Future<void> deleteUserId() async {
    _storage.remove(_keyUserId);
  }

  // Nickname operations (for guest users)
  Future<void> saveNickname(String nickname) async {
    _storage[_keyNickname] = nickname;
  }

  Future<String?> getNickname() async {
    return _storage[_keyNickname];
  }

  Future<void> deleteNickname() async {
    _storage.remove(_keyNickname);
  }

  // Guest mode flag
  Future<void> setIsGuest(bool isGuest) async {
    _storage[_keyIsGuest] = isGuest.toString();
  }

  Future<bool> getIsGuest() async {
    final value = _storage[_keyIsGuest];
    return value == 'true';
  }

  Future<void> deleteIsGuest() async {
    _storage.remove(_keyIsGuest);
  }

  // Check if user is authenticated (either logged in or guest)
  Future<bool> isAuthenticated() async {
    final userId = await getUserId();
    final nickname = await getNickname();
    return userId != null || nickname != null;
  }

  // Clear all stored data (logout)
  Future<void> clearAll() async {
    _storage.clear();
  }

  // Token operations
  Future<void> saveToken(String token) async {
    _storage[_keyToken] = token;
  }

  Future<String?> getToken() async {
    return _storage[_keyToken];
  }

  Future<void> deleteToken() async {
    _storage.remove(_keyToken);
  }

  // Username operations
  Future<void> saveUsername(String username) async {
    _storage[_keyUsername] = username;
  }

  Future<String?> getUsername() async {
    return _storage[_keyUsername];
  }

  Future<void> deleteUsername() async {
    _storage.remove(_keyUsername);
  }

  // Favorites (stored as JSON string)
  Future<void> saveFavoritesList(List<Map<String, dynamic>> list) async {
    try {
      _storage[_keyFavorites] = jsonEncode(list);
    } catch (_) {}
  }

  Future<List<Map<String, dynamic>>> getFavoritesList() async {
    final raw = _storage[_keyFavorites];
    if (raw == null) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return List<Map<String, dynamic>>.from(
          decoded.map((e) => Map<String, dynamic>.from(e)),
        );
      }
    } catch (_) {}
    return [];
  }

  Future<void> deleteFavoritesList() async {
    _storage.remove(_keyFavorites);
  }
}
