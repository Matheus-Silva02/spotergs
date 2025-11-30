import 'package:get/get.dart';
import 'package:spotergs/app/modules/login/controllers/login_controller.dart';
import 'package:spotergs/app/repositories/auth_repository.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<AuthRepository>(AuthRepository());
    Get.put<LoginController>(LoginController(repository: Get.find()));
  }
}
