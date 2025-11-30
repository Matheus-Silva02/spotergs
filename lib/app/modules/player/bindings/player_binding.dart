// file: lib/app/modules/player/bindings/player_binding.dart

import 'package:get/get.dart';
import 'package:spotergs/app/modules/player/controllers/player_controller.dart';

class PlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayerController>(() => PlayerController());
  }
}
