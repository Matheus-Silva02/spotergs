import 'package:get/get.dart';
import 'package:spotergs/app/modules/home/controllers/collection_details_controller.dart';
import 'package:spotergs/app/modules/favorites/controllers/favorites_controller.dart';
import 'package:spotergs/app/modules/player/controllers/player_controller.dart';

class CollectionDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CollectionDetailsController>(
        () => CollectionDetailsController());
    Get.lazyPut<FavoritesController>(() => FavoritesController());
    Get.lazyPut<PlayerController>(() => PlayerController());
  }
}
