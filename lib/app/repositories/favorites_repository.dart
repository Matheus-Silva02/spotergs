import 'package:get/get.dart';
import 'package:spotergs/app/core/services/api_service.dart';
import 'package:spotergs/app/core/services/storage_service.dart';

/// Repository for favorites operations
/// Endpoints:
/// - POST /music/add_favorite (toggle: add if not exists, remove if exists)
/// - GET /music/get_favorites (list all favorites for user)
class FavoritesRepository {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  /// Add/Remove music to/from favorites (toggle)
  /// POST /music/add_favorite with token and music_identifier
  /// If music is already favorite, it removes; otherwise adds
  /// Returns: { "status": "success", "message": "..." }
  Future<dynamic> addFavorite({
    required String musicIdentifier,
    Map<String, dynamic>? musicData,
  }) async {
    try {
      final token = await _storageService.getToken();
      final response = await _apiService.post(
        '/music/add_favorite',
        params: {
          'token': token,
          'music_identifier': musicIdentifier,
        },
      );
      print(response);
      return response;
    } catch (e) {
      print('Add favorite error: $e');
      return null;
    }
  }

 
  Future<dynamic> getFavorites() async {
    try {
      final token = await _storageService.getToken();
      if (token == null) {
        return null;
      }
      final response = await _apiService.get(
        '/user/$token/get_favorites',
      );
      print(response);

      if (response is Map && response['status'] == 'success') {
        final favorites = response['favorites'];
        if (favorites is List) {
         
          final result = <Map<String, dynamic>>[];
          for (var detail in favorites) {
            if (detail is List) {
              // Each detail is a list of music items from IAService.get_details
              for (var item in detail) {
                if (item is Map) {
                  result.add(Map<String, dynamic>.from(item));
                }
              }
            } else if (detail is Map) {
              result.add(Map<String, dynamic>.from(detail));
            }
          }
          return result;
        }
        return favorites;
      }
      return response;
    } catch (e) {
      print('Get favorites error: $e');
      return null;
    }
  }

  /// Check if music is favorite
  /// Checks by reloading favorites list from server
  /// Returns: true if favorite, false otherwise
  Future<bool> isFavorite({required String musicIdentifier}) async {
    try {
      final token = await _storageService.getToken();
      if (token == null) return false;

      final favorites = await getFavorites();
      if (favorites is List) {
        return favorites.any((fav) =>
            (fav['identifier'] == musicIdentifier ||
                fav['music_identifier'] == musicIdentifier ||
                fav['id'] == musicIdentifier));
      }
      return false;
    } catch (e) {
      print('Check favorite error: $e');
      return false;
    }
  }
}
