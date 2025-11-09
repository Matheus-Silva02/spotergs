import 'package:get/get.dart';
import 'package:spotergs/app/modules/register/pages/register_page.dart';

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
   GetPage(name: AppRoutes.register,page: () => const RegisterPage(),
      binding: SplashBinding(),)
  ];
}

