// file: lib/app/core/services/storage_service.dart

// file: lib/app/core/services/storage_service.dart

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
}
