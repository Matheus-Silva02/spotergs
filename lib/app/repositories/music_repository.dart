// file: lib/app/repositories/music_repository.dart

import 'package:get/get.dart';
import 'package:spotergs/app/core/services/api_service.dart';
import 'package:spotergs/app/utils/constants.dart';

/// Repository for music-related operations
/// All methods return dynamic data (Map<String, dynamic>, List<dynamic>, or null)
/// 
/// Expected response formats:
/// Track: {
///   "id": "...",
///   "title": "...",
///   "artist": "...",
///   "album": "...",
///   "duration": 180000,
///   "artworkUrl": "...",
///   "url": "...",
///   "isFavorite": false
/// }
/// 
/// Tracks list: {
///   "tracks": [...],
///   "page": 1,
///   "pageSize": 20,
///   "total": 100,
///   "hasMore": true
/// }
class MusicRepository {
  final ApiService _apiService = Get.find<ApiService>();

  /// Get list of tracks with pagination
  /// Returns: { "tracks": [...], "page": 1, "pageSize": 20, "total": 100, "hasMore": true }
  Future<dynamic> getTracks({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _apiService.get(
        Constants.tracksEndpoint
      );
      return response;
    } catch (e) {
      print('Get tracks error: $e');
      return null;
    }
  }

  /// Get track details by ID
  /// Returns: { "id": "...", "title": "...", "artist": "...", ... }
  Future<dynamic> getTrackDetails(String trackId) async {
    try {
      final endpoint = Constants.trackDetailsEndpoint.replaceAll('{id}', trackId);
      final response = await _apiService.get(endpoint);
      return response;
    } catch (e) {
      print('Get track details error: $e');
      return null;
    }
  }

  /// Search tracks by query
  /// Returns: { "tracks": [...], "total": 50 }
  Future<dynamic> searchTracks({
    required String query,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _apiService.get(
        Constants.searchTracksEndpoint,
        params: {
          'q': query,
          'page': page,
          'pageSize': pageSize,
        },
      );
      return response;
    } catch (e) {
      print('Search tracks error: $e');
      return null;
    }
  }



  /// Create a new room for listening together
  /// Returns: { "roomId": "...", "hostId": "...", "trackId": "..." }
  Future<dynamic> createRoom({
    required String trackId,
    String? roomName,
  }) async {
    try {
      final response = await _apiService.post(
        Constants.createRoomEndpoint,
        data: {
          'trackId': trackId,
          'roomName': roomName,
        },
      );
      return response;
    } catch (e) {
      print('Create room error: $e');
      return null;
    }
  }

  /// Join an existing room
  /// Returns: { "roomId": "...", "currentTrack": {...}, "position": 12345, "isPlaying": true }
  Future<dynamic> joinRoom(String roomId) async {
    try {
      final endpoint = Constants.joinRoomEndpoint.replaceAll('{id}', roomId);
      final response = await _apiService.post(endpoint);
      return response;
    } catch (e) {
      print('Join room error: $e');
      return null;
    }
  }

  /// Leave a room
  /// Returns: { "success": true }
  Future<dynamic> leaveRoom(String roomId) async {
    try {
      final endpoint = Constants.leaveRoomEndpoint.replaceAll('{id}', roomId);
      final response = await _apiService.post(endpoint);
      return response;
    } catch (e) {
      print('Leave room error: $e');
      return null;
    }
  }

  /// Get list of active rooms
  /// Returns: { "rooms": [{ "roomId": "...", "hostName": "...", "trackTitle": "...", "participants": 5 }] }
  Future<dynamic> getRooms() async {
    try {
      final response = await _apiService.get(Constants.roomsEndpoint);
      return response;
    } catch (e) {
      print('Get rooms error: $e');
      return null;
    }
  }

  /// Get room details
  /// Returns: { "roomId": "...", "hostId": "...", "participants": [...], "currentTrack": {...} }
  Future<dynamic> getRoomDetails(String roomId) async {
    try {
      final response = await _apiService.get('${Constants.roomsEndpoint}/$roomId');
      return response;
    } catch (e) {
      print('Get room details error: $e');
      return null;
    }
  }

  /// Get recently played tracks
  /// Returns: { "tracks": [...] }
  Future<dynamic> getRecentlyPlayed({
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.get(
        '/tracks/recent',
        params: {
          'limit': limit,
        },
      );
      return response;
    } catch (e) {
      print('Get recently played error: $e');
      return null;
    }
  }
  Future<dynamic> getTracksByTheme(String theme) async {
    try {
      final response = await _apiService.get('/buscar_musica/$theme');
      print(response);
      return response;
    } catch (e) {
      print('Get tracks by theme error: $e');
      return null;
    }
  }

  /// Get audio URL for a track by identifier
  /// Returns: { "url": "..." }
  Future<dynamic> getAudioUrl(String identifier) async {
    try {
      final response = await _apiService.get('/get_url/$identifier');
      print(response);
      return response;
    } catch (e) {
      print('Get audio URL error: $e');
      return null;
    }
  }

  /// Get popular collections
  /// Returns: [ { "identifier": "...", "title": "...", "banner": "..." }, ... ]
  Future<dynamic> getPopularCollections() async {
    try {
      final response = await _apiService.get('/buscar_tema/anime');
      print(response);
      return response;
    } catch (e) {
      print('Get popular collections error: $e');
      return null;
    }
  }

  /// Get collection details by identifier
  /// Returns: [ { "identifier": "...", "title": "...", "artist": "...", "banner": "..." }, ... ]
  Future<dynamic> getCollectionDetails(String identifier) async {
    try {
      final response = await _apiService.get('/get_details/$identifier');
      print('Collection details response: $response');
      
      if (response == null) {
        print('Response is null');
        return [];
      }
      
      if (response is List) {
        return response;
      }
      
      // Se for um objeto com uma chave contendo a lista
      if (response is Map) {
        // Tente encontrar a lista dentro do mapa
        for (var value in response.values) {
          if (value is List) {
            return value;
          }
        }
      }
      
      print('Response format not recognized: ${response.runtimeType}');
      return [];
    } catch (e) {
      print('Get collection details error: $e');
      return [];
    }
  }
}
