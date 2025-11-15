import 'package:get/get.dart';
import 'package:spotergs/app/modules/login/controllers/login_controller.dart';
import 'package:spotergs/app/modules/login/repositories/login_repository.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<LoginRepository>(LoginRepository());
    Get.put<LoginController>(LoginController(repository: Get.find()));
  }
}
