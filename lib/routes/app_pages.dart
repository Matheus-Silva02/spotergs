import 'package:get/get.dart';
import 'package:spotergs/app/modules/login/bindings/login_binding.dart';
import 'package:spotergs/app/modules/login/pages/login_page.dart';
import 'package:spotergs/app/modules/register/bindings/register_binding.dart';
import 'package:spotergs/app/modules/register/pages/register_page.dart';
import 'package:spotergs/app/modules/home/bindings/main_binding.dart';
import 'package:spotergs/app/modules/home/pages/main_page.dart';
import 'package:spotergs/app/modules/home/bindings/collection_details_binding.dart';
import 'package:spotergs/app/modules/home/pages/collection_details_page.dart';
import 'package:spotergs/app/modules/player/bindings/player_binding.dart';
import 'package:spotergs/app/modules/player/pages/player_page.dart';
import 'package:spotergs/app/modules/player/pages/music_details_page.dart';
import 'package:spotergs/app/modules/listen_together/bindings/listen_binding.dart';
import 'package:spotergs/app/modules/listen_together/pages/listen_room_page.dart';

import '../app/modules/splash/bindings/splash_binding.dart';
import '../app/modules/splash/pages/splash_page.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreenPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoutes.collectionDetails,
      page: () => const CollectionDetailsPage(),
      binding: CollectionDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.player,
      page: () => const PlayerPage(),
      binding: PlayerBinding(),
    ),
    GetPage(
      name: AppRoutes.musicDetails,
      page: () => const MusicDetailsPage(),
      binding: PlayerBinding(),
    ),
    GetPage(
      name: AppRoutes.listenRoom,
      page: () => const ListenRoomPage(),
      binding: ListenBinding(),
    ),
  ];
}