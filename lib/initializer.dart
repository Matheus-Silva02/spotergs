// file: lib/initializer.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotergs/app/core/services/storage_service.dart';
import 'package:spotergs/app/core/services/api_service.dart';
import 'package:spotergs/app/core/services/audio_service.dart';
import 'package:spotergs/app/core/services/websocket_service.dart';
import 'package:spotergs/app/modules/player/controllers/player_controller.dart';
import 'package:spotergs/app/repositories/auth_repository.dart';
import 'package:spotergs/app/repositories/music_repository.dart';

/// Initializer for application dependencies
class Initializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize core services
    await Get.putAsync(() => StorageService().init());
    await Get.putAsync(() => ApiService().init());
    await Get.putAsync(() => AudioService().init());
    Get.put(WebSocketService());

    // Initialize repositories
    Get.put(AuthRepository());
    Get.put(MusicRepository());

    // Initialize global controllers
    Get.put(PlayerController(), permanent: true);

    print('✅ App initialized successfully');
  }
}
