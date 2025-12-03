// file: lib/app/modules/home/controllers/home_controller.dart

import 'package:get/get.dart';
import 'package:spotergs/app/repositories/music_repository.dart';
import 'package:spotergs/app/modules/player/controllers/player_controller.dart';
import 'package:spotergs/app/modules/favorites/controllers/favorites_controller.dart';

/// Controller for Home module
/// Manages track listing, favorites, and pagination
class HomeController extends GetxController {
  final MusicRepository _musicRepository = MusicRepository();
  final PlayerController _playerController = Get.find<PlayerController>();

  // Observable state
  final tracks = <dynamic>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final currentPage = 1.obs;
  final hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadTracks();
  }

  /// Load tracks from API
  Future<void> loadTracks({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      hasMore.value = true;
    }

    if (isLoading.value || isLoadingMore.value) return;

    if (currentPage.value == 1) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await _musicRepository.getTracksByTheme('Bruno-Mars');

      if (response != null) {
        List<dynamic> rawTracks;
        if (response is List) {
          rawTracks = response;
        } else if (response is Map && response['tracks'] != null) {
          rawTracks = response['tracks'];
        } else {
          rawTracks = [];
        }
        final List<dynamic> newTracks = rawTracks.map((track) {
          return {
            'id': track['identifier'] ?? '',
            'title': track['title'] ?? 'Sem título',
            'artist': track['artist'] is List ? (track['artist'] as List).join(', ') : track['artist'] ?? 'Desconhecido',
            'imageUrl': track['banner'] ?? '',
            'url': '',
          };
        }).toList();
        // Assuming no pagination for theme, set hasMore to false
        hasMore.value = false;

        tracks.value = newTracks;
        print(tracks.value);
      }
    } catch (e) {
      print('Load tracks error: $e');
      Get.snackbar(
        'Erro',
        'Falha ao carregar músicas',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  /// Load more tracks (pagination)
  Future<void> loadMore() async {
    if (hasMore.value && !isLoadingMore.value) {
      await loadTracks();
    }
  }

  /// Refresh tracks
  @override
  Future<void> refresh() async {
    await loadTracks(refresh: true);
  }

  /// Play track
  void playTrack(dynamic track) async {
    final String? trackId = track['id'];

    if (trackId == null || trackId.isEmpty) {
      Get.snackbar(
        'Erro',
        'ID da música não disponível',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final urlResponse = await _musicRepository.getAudioUrl(trackId);
      if (urlResponse != null) {
        String url = '';
        
        if (urlResponse is Map && urlResponse['url'] != null) {
          url = urlResponse['url'];
        } else if (urlResponse is List && urlResponse.isNotEmpty) {
          url = urlResponse[0];
        } else if (urlResponse is String) {
          url = urlResponse;
        }

        if (url.isNotEmpty) {
          _playerController.playTrack(track, url: url);
        } else {
          Get.snackbar(
            'Erro',
            'URL de áudio não disponível',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar(
          'Erro',
          'URL de áudio não disponível',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error getting audio URL: $e');
      Get.snackbar(
        'Erro',
        'Falha ao obter URL de áudio',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Toggle favorite
  Future<void> toggleFavorite(dynamic track, int index) async {
    try {
      final favController = Get.find<FavoritesController>();
      final trackId = track['id'] ?? '';
      final musicData = {
        'identifier': trackId,
        'title': track['title'] ?? '',
        'artist': track['artist'] ?? '',
        'banner': track['imageUrl'] ?? '',
      };
      await favController.toggleFavorite(
        musicIdentifier: trackId,
        musicData: musicData,
      );
      tracks.refresh();

      Get.snackbar(
        'Sucesso',
        favController.isFavorite(trackId) ? 'Adicionado aos favoritos' : 'Removido dos favoritos',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Toggle favorite error: $e');
      Get.snackbar(
        'Erro',
        'Falha ao atualizar favorito',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Navigate to track details
  void goToTrackDetails(dynamic track) {
    Get.toNamed('/music/${track['id']}', arguments: track);
  }

  /// Navigate to search
  void goToSearch() {
    Get.toNamed('/search');
  }
}
