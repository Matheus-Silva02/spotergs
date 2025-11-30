// file: lib/app/core/services/websocket_service.dart

import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Service for WebSocket communication
/// Used for real-time synchronization in "Listen Together" feature
/// 
/// Expected JSON protocol:
/// - Join: { "type": "join", "room": "roomId", "user": { "id": "...", "nickname": "..." } }
/// - Play: { "type": "play", "position": 12345, "timestamp": "..." }
/// - Pause: { "type": "pause", "timestamp": "..." }
/// - Seek: { "type": "seek", "position": 54321, "timestamp": "..." }
/// - State: { "type": "state", "trackId": "...", "position": 12345, "isPlaying": true }
class WebSocketService extends GetxService {
  WebSocketChannel? _channel;
  final _eventController = StreamController<dynamic>.broadcast();
  
  final isConnected = false.obs;
  final currentRoom = Rxn<String>();

  /// Get stream of events from WebSocket
  Stream<dynamic> get onEvent => _eventController.stream;

  /// Connect to WebSocket server
  Future<void> connect(String url) async {
    try {
      // Close existing connection if any
      if (_channel != null) {
        await disconnect();
      }

      _channel = WebSocketChannel.connect(Uri.parse(url));
      isConnected.value = true;

      // Listen to incoming messages
      _channel!.stream.listen(
        (message) {
          try {
            final data = jsonDecode(message);
            _eventController.add(data);
          } catch (e) {
            print('Error parsing WebSocket message: $e');
          }
        },
        onError: (error) {
          print('WebSocket error: $error');
          isConnected.value = false;
          Get.snackbar(
            'Erro de conexão',
            'Falha na conexão WebSocket',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        onDone: () {
          print('WebSocket connection closed');
          isConnected.value = false;
        },
      );

      Get.snackbar(
        'Conectado',
        'Conexão WebSocket estabelecida',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error connecting to WebSocket: $e');
      isConnected.value = false;
      Get.snackbar(
        'Erro',
        'Não foi possível conectar ao servidor',
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  /// Join a room for listening together
  /// payload: { "id": userId, "nickname": userNickname }
  void joinRoom(String roomId, Map<String, dynamic> user) {
    if (!isConnected.value) {
      throw Exception('WebSocket not connected');
    }

    currentRoom.value = roomId;
    
    final message = {
      'type': 'join',
      'room': roomId,
      'user': user,
      'timestamp': DateTime.now().toIso8601String(),
    };

    sendEvent(message);
  }

  /// Leave current room
  void leaveRoom() {
    if (!isConnected.value || currentRoom.value == null) {
      return;
    }

    final message = {
      'type': 'leave',
      'room': currentRoom.value,
      'timestamp': DateTime.now().toIso8601String(),
    };

    sendEvent(message);
    currentRoom.value = null;
  }

  /// Send play event
  /// position: current playback position in milliseconds
  void sendPlay(int position) {
    final message = {
      'type': 'play',
      'position': position,
      'timestamp': DateTime.now().toIso8601String(),
    };

    sendEvent(message);
  }

  /// Send pause event
  void sendPause() {
    final message = {
      'type': 'pause',
      'timestamp': DateTime.now().toIso8601String(),
    };

    sendEvent(message);
  }

  /// Send seek event
  /// position: new playback position in milliseconds
  void sendSeek(int position) {
    final message = {
      'type': 'seek',
      'position': position,
      'timestamp': DateTime.now().toIso8601String(),
    };

    sendEvent(message);
  }

  /// Send track change event
  void sendTrackChange(String trackId, String trackUrl) {
    final message = {
      'type': 'track_change',
      'trackId': trackId,
      'trackUrl': trackUrl,
      'timestamp': DateTime.now().toIso8601String(),
    };

    sendEvent(message);
  }

  /// Request current state from server
  void requestState() {
    final message = {
      'type': 'request_state',
      'timestamp': DateTime.now().toIso8601String(),
    };

    sendEvent(message);
  }

  /// Send generic event
  void sendEvent(Map<String, dynamic> event) {
    if (!isConnected.value) {
      throw Exception('WebSocket not connected');
    }

    try {
      final message = jsonEncode(event);
      _channel!.sink.add(message);
    } catch (e) {
      print('Error sending WebSocket message: $e');
      Get.snackbar(
        'Erro',
        'Falha ao enviar mensagem',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Disconnect from WebSocket
  Future<void> disconnect() async {
    if (currentRoom.value != null) {
      leaveRoom();
    }

    await _channel?.sink.close();
    _channel = null;
    isConnected.value = false;
    currentRoom.value = null;
  }

  @override
  void onClose() {
    disconnect();
    _eventController.close();
    super.onClose();
  }
}
