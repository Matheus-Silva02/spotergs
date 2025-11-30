// file: lib/app/modules/listen_together/controllers/listen_controller.dart

import 'dart:async';
import 'package:get/get.dart';
import 'package:spotergs/app/core/services/websocket_service.dart';
import 'package:spotergs/app/core/services/storage_service.dart';
import 'package:spotergs/app/modules/player/controllers/player_controller.dart';
import 'package:spotergs/app/repositories/music_repository.dart';
import 'package:spotergs/app/utils/constants.dart';
import 'package:spotergs/app/utils/helpers.dart';

/// Controller for Listen Together module
/// Manages WebSocket connection and synchronization
class ListenController extends GetxController {
  final WebSocketService _wsService = Get.find<WebSocketService>();
  final StorageService _storageService = Get.find<StorageService>();
  final PlayerController _playerController = Get.find<PlayerController>();
  final MusicRepository _musicRepository = MusicRepository();

  // Observable state
  final isConnected = false.obs;
  final isHost = false.obs;
  final roomId = Rxn<String>();
  final participants = <dynamic>[].obs;
  final currentRoomTrack = Rxn<dynamic>();

  StreamSubscription? _wsSubscription;

  @override
  void onInit() {
    super.onInit();
    _setupWebSocketListener();
  }

  @override
  void onClose() {
    _wsSubscription?.cancel();
    disconnect();
    super.onClose();
  }

  /// Setup WebSocket event listener
  void _setupWebSocketListener() {
    _wsSubscription = _wsService.onEvent.listen((event) {
      _handleWebSocketEvent(event);
    });
  }

  /// Handle WebSocket events
  void _handleWebSocketEvent(dynamic event) {
    final String type = event['type'] ?? '';

    switch (type) {
      case 'state':
        _handleStateEvent(event);
        break;
      case 'play':
        _handlePlayEvent(event);
        break;
      case 'pause':
        _handlePauseEvent();
        break;
      case 'seek':
        _handleSeekEvent(event);
        break;
      case 'track_change':
        _handleTrackChangeEvent(event);
        break;
      case 'user_joined':
        _handleUserJoinedEvent(event);
        break;
      case 'user_left':
        _handleUserLeftEvent(event);
        break;
      case 'participants':
        _handleParticipantsEvent(event);
        break;
    }
  }

  /// Create a room
  Future<void> createRoom(dynamic track) async {
    try {
      final String? trackId = track['id'];
      if (trackId == null) return;

      final response = await _musicRepository.createRoom(
        trackId: trackId,
      );

      if (response != null) {
        final String? newRoomId = response['roomId'];
        if (newRoomId != null) {
          isHost.value = true;
          await connectToRoom(newRoomId, track);
        }
      }
    } catch (e) {
      print('Create room error: $e');
      Get.snackbar(
        'Erro',
        'Falha ao criar sala',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Join a room
  Future<void> joinRoom(String roomIdToJoin, {dynamic track}) async {
    try {
      final response = await _musicRepository.joinRoom(roomIdToJoin);

      if (response != null) {
        isHost.value = false;
        final dynamic currentTrack = response['currentTrack'] ?? track;
        await connectToRoom(roomIdToJoin, currentTrack);

        // Request current state from server
        _wsService.requestState();
      }
    } catch (e) {
      print('Join room error: $e');
      Get.snackbar(
        'Erro',
        'Falha ao entrar na sala',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Connect to WebSocket and join room
  Future<void> connectToRoom(String roomIdValue, dynamic track) async {
    try {
      // Connect to WebSocket if not connected
      if (!_wsService.isConnected.value) {
        await _wsService.connect(Constants.wsUrl);
      }

      roomId.value = roomIdValue;
      currentRoomTrack.value = track;

      // Get user info
      final userId = await _storageService.getUserId() ?? '';
      final nickname = await _storageService.getNickname() ?? 'Guest';

      // Join room via WebSocket
      _wsService.joinRoom(roomIdValue, {
        'id': userId,
        'nickname': nickname,
      });

      isConnected.value = true;

      // Play track if host
      if (isHost.value && track != null) {
        await _playerController.playTrack(track);
      }

      Get.snackbar(
        'Conectado',
        'Você entrou na sala',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Connect to room error: $e');
      Get.snackbar(
        'Erro',
        'Falha ao conectar à sala',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Leave room
  Future<void> leaveRoom() async {
    try {
      if (roomId.value != null) {
        await _musicRepository.leaveRoom(roomId.value!);
      }

      _wsService.leaveRoom();
      disconnect();

      Get.back();
      Get.snackbar(
        'Desconectado',
        'Você saiu da sala',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Leave room error: $e');
    }
  }

  /// Disconnect from WebSocket
  void disconnect() {
    isConnected.value = false;
    isHost.value = false;
    roomId.value = null;
    participants.clear();
    currentRoomTrack.value = null;
  }

  /// Send play event (host only)
  void sendPlay() {
    if (!isHost.value) return;
    _wsService.sendPlay(_playerController.currentPosition.inMilliseconds);
  }

  /// Send pause event (host only)
  void sendPause() {
    if (!isHost.value) return;
    _wsService.sendPause();
  }

  /// Send seek event (host only)
  void sendSeek(int position) {
    if (!isHost.value) return;
    _wsService.sendSeek(position);
  }

  /// Handle state event from server
  void _handleStateEvent(dynamic event) {
    final String? trackId = event['trackId'];
    final int position = event['position'] ?? 0;
    final bool playing = event['isPlaying'] ?? false;

    if (trackId != null && currentRoomTrack.value?['id'] == trackId) {
      _playerController.seekTo(position);
      if (playing && !_playerController.isPlaying) {
        _playerController.resume();
      } else if (!playing && _playerController.isPlaying) {
        _playerController.pause();
      }
    }
  }

  /// Handle play event
  void _handlePlayEvent(dynamic event) {
    final int position = event['position'] ?? 0;
    final String? timestamp = event['timestamp'];

    // Calculate latency compensation
    final int latencyMs = Helpers.calculateLatencyMs(timestamp);
    final int adjustedPosition = position + latencyMs;

    _playerController.seekTo(adjustedPosition);
    _playerController.resume();
  }

  /// Handle pause event
  void _handlePauseEvent() {
    _playerController.pause();
  }

  /// Handle seek event
  void _handleSeekEvent(dynamic event) {
    final int position = event['position'] ?? 0;
    _playerController.seekTo(position);
  }

  /// Handle track change event
  void _handleTrackChangeEvent(dynamic event) {
    final String? trackId = event['trackId'];
    // Could fetch track details and play it
    print('Track changed to: $trackId');
  }

  /// Handle user joined event
  void _handleUserJoinedEvent(dynamic event) {
    final dynamic user = event['user'];
    if (user != null) {
      participants.add(user);
      Get.snackbar(
        'Usuário entrou',
        '${user['nickname']} entrou na sala',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Handle user left event
  void _handleUserLeftEvent(dynamic event) {
    final dynamic user = event['user'];
    if (user != null) {
      participants.removeWhere((p) => p['id'] == user['id']);
      Get.snackbar(
        'Usuário saiu',
        '${user['nickname']} saiu da sala',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Handle participants list event
  void _handleParticipantsEvent(dynamic event) {
    final List<dynamic> users = event['participants'] ?? [];
    participants.value = users;
  }
}
