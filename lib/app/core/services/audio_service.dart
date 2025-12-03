// file: lib/app/core/services/audio_service.dart

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

/// Service for audio playback using just_audio
/// Provides methods to control audio playback and expose streams for state changes
class AudioService extends GetxService {
  late AudioPlayer _player;

  // Reactive state
  final isPlaying = false.obs;
  final currentPosition = Duration.zero.obs;
  final totalDuration = Duration.zero.obs;
  final bufferedPosition = Duration.zero.obs;
  final volume = 1.0.obs;
  final speed = 1.0.obs;

  // Current track info
  final currentTrackUrl = Rxn<String>();
  final currentTrackId = Rxn<String>();
  OverlayEntry? currentOverlayEntry;

  Future<AudioService> init() async {
    _player = AudioPlayer();

    // Listen to player state changes
    _player.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });

    // Listen to position changes
    _player.positionStream.listen((position) {
      currentPosition.value = position;
    });

    // Listen to duration changes
    _player.durationStream.listen((duration) {
      if (duration != null) {
        totalDuration.value = duration;
      }
    });

    // Listen to buffered position
    _player.bufferedPositionStream.listen((position) {
      bufferedPosition.value = position;
    });

    // Listen to volume changes
    _player.volumeStream.listen((vol) {
      volume.value = vol;
    });

    // Listen to speed changes
    _player.speedStream.listen((spd) {
      speed.value = spd;
    });

    return this;
  }

  /// Play audio from URL
  Future<void> play(String url, {String? trackId}) async {
    try {
      currentTrackUrl.value = url;
      currentTrackId.value = trackId;
      print(currentTrackUrl);
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      print(e);
      Get.snackbar(
        'Erro de reprodução',
        'Não foi possível reproduzir a música',
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  /// Pause playback
  Future<void> pause() async {
    await _player.pause();
  }

  /// Resume playback
  Future<void> resume() async {
    await _player.play();
  }

  /// Stop playback
  Future<void> stop() async {
    await _player.stop();
    currentTrackUrl.value = null;
    currentTrackId.value = null;
  }

  /// Seek to position in milliseconds
  Future<void> seek(int milliseconds) async {
    final duration = Duration(milliseconds: milliseconds);
    await _player.seek(duration);
  }

  /// Seek to Duration
  Future<void> seekTo(Duration duration) async {
    await _player.seek(duration);
  }

  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double vol) async {
    await _player.setVolume(vol.clamp(0.0, 1.0));
  }

  /// Set playback speed
  Future<void> setSpeed(double spd) async {
    await _player.setSpeed(spd);
  }

  /// Toggle play/pause
  Future<void> togglePlayPause() async {
    if (isPlaying.value) {
      await pause();
    } else {
      await resume();
    }
  }

  /// Get current position in milliseconds
  int get currentPositionMs => currentPosition.value.inMilliseconds;

  /// Get total duration in milliseconds
  int get totalDurationMs => totalDuration.value.inMilliseconds;

  /// Get progress (0.0 to 1.0)
  double get progress {
    if (totalDurationMs == 0) return 0.0;
    return (currentPositionMs / totalDurationMs).clamp(0.0, 1.0);
  }

  /// Check if audio is loaded
  bool get hasAudio => currentTrackUrl.value != null;

  /// Stream for position changes
  Stream<Duration> get positionStream => _player.positionStream;

  /// Stream for player state changes
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  /// Stream for duration changes
  Stream<Duration?> get durationStream => _player.durationStream;

  @override
  void onClose() {
    _player.dispose();
    super.onClose();
  }
}
