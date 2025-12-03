// file: lib/app/modules/home/bindings/home_binding.dart

import 'package:get/get.dart';
import 'package:spotergs/app/modules/home/controllers/home_controller.dart';
import 'package:spotergs/app/modules/favorites/controllers/favorites_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<FavoritesController>(() => FavoritesController());
  }
}
