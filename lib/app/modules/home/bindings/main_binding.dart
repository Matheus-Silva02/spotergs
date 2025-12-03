import 'package:get/get.dart';
import 'package:spotergs/app/modules/home/controllers/home_controller.dart';
import 'package:spotergs/app/modules/search/controllers/search_controller.dart';
import 'package:spotergs/app/modules/favorites/controllers/favorites_controller.dart';
import 'package:spotergs/app/modules/player/controllers/player_controller.dart';
import 'package:spotergs/app/core/services/audio_service.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Core services
    Get.lazyPut<AudioService>(() => AudioService(), fenix: true);
    
    // Controllers
    Get.lazyPut<PlayerController>(() => PlayerController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<SearchController>(() => SearchController());
    Get.lazyPut<FavoritesController>(() => FavoritesController());
  }
}
