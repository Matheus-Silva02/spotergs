// file: lib/app/modules/listen_together/bindings/listen_binding.dart

import 'package:get/get.dart';
import 'package:spotergs/app/modules/listen_together/controllers/listen_controller.dart';

class ListenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListenController>(() => ListenController());
  }
}
