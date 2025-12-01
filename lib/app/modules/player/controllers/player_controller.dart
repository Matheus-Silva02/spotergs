// file: lib/app/modules/player/controllers/player_controller.dart

import 'package:get/get.dart';
import 'package:spotergs/app/core/services/audio_service.dart';
import 'package:spotergs/app/repositories/music_repository.dart';

/// Controller for Player module
/// Manages audio playback, track queue, and player state
class PlayerController extends GetxController {
  final AudioService _audioService = Get.find<AudioService>();
  final MusicRepository _musicRepository = MusicRepository();

  // Current track
  final currentTrack = Rxn<dynamic>();
  final trackQueue = <dynamic>[].obs;
  final currentIndex = 0.obs;

  // Player state (from AudioService)
  bool get isPlaying => _audioService.isPlaying.value;
  Duration get currentPosition => _audioService.currentPosition.value;
  Duration get totalDuration => _audioService.totalDuration.value;
  double get progress => _audioService.progress;

  // Observable for favorite state
  final isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to player state changes
    ever(_audioService.isPlaying, (_) => update());
    ever(_audioService.currentPosition, (_) => update());
  }

  /// Play a track
  Future<void> playTrack(dynamic track, {List<dynamic>? queue, int? index, String? audioUrl}) async {
    currentTrack.value = track;
    isFavorite.value = track['isFavorite'] ?? false;

    if (queue != null) {
      trackQueue.value = queue;
      currentIndex.value = index ?? 0;
    }

    final String? finalAudioUrl = audioUrl ?? track['audioUrl'];
    final String? trackId = track['id'];

    if (finalAudioUrl != null) {
      try {
        await _audioService.play(finalAudioUrl, trackId: trackId);
      } catch (e) {
        print('Play track error: $e');
        Get.snackbar(
          'Erro',
          'Falha ao reproduzir música',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  /// Pause playback
  Future<void> pause() async {
    await _audioService.pause();
  }

  /// Resume playback
  Future<void> resume() async {
    await _audioService.resume();
  }

  /// Toggle play/pause
  Future<void> togglePlayPause() async {
    await _audioService.togglePlayPause();
  }

  /// Seek to position
  Future<void> seek(Duration position) async {
    await _audioService.seekTo(position);
  }

  /// Seek to milliseconds
  Future<void> seekTo(int milliseconds) async {
    await _audioService.seek(milliseconds);
  }

  /// Play next track in queue
  Future<void> playNext() async {
    if (trackQueue.isEmpty) return;

    if (currentIndex.value < trackQueue.length - 1) {
      currentIndex.value++;
      await playTrack(
        trackQueue[currentIndex.value],
        queue: trackQueue,
        index: currentIndex.value,
      );
    }
  }

  /// Play previous track in queue
  Future<void> playPrevious() async {
    if (trackQueue.isEmpty) return;

    if (currentIndex.value > 0) {
      currentIndex.value--;
      await playTrack(
        trackQueue[currentIndex.value],
        queue: trackQueue,
        index: currentIndex.value,
      );
    }
  }

  /// Toggle favorite
  Future<void> toggleFavorite() async {
    if (currentTrack.value == null) return;

    final String? trackId = currentTrack.value['id'];
    if (trackId == null) return;

    try {
      final response = await _musicRepository.toggleFavorite(trackId);

      if (response != null) {
        final bool favorite = response['isFavorite'] ?? false;
        isFavorite.value = favorite;
        currentTrack.value['isFavorite'] = favorite;

        Get.snackbar(
          'Sucesso',
          favorite ? 'Adicionado aos favoritos' : 'Removido dos favoritos',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Toggle favorite error: $e');
      Get.snackbar(
        'Erro',
        'Falha ao atualizar favorito',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Stop playback
  Future<void> stop() async {
    await _audioService.stop();
    currentTrack.value = null;
  }

  /// Set volume
  Future<void> setVolume(double volume) async {
    await _audioService.setVolume(volume);
  }

  /// Check if there is a next track
  bool get hasNext => trackQueue.isNotEmpty && currentIndex.value < trackQueue.length - 1;

  /// Check if there is a previous track
  bool get hasPrevious => trackQueue.isNotEmpty && currentIndex.value > 0;

  /// Get current track title
  String get currentTrackTitle => currentTrack.value?['title'] ?? 'Unknown';

  /// Get current track artist
  String get currentTrackArtist => currentTrack.value?['artist'] ?? 'Unknown';

  /// Get current track artwork URL
  String? get currentTrackArtwork => currentTrack.value?['artworkUrl'];

  /// Check if player has a track loaded
  bool get hasTrack => currentTrack.value != null;
}
