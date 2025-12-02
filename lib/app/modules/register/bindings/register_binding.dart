import 'package:get/get.dart';
import 'package:spotergs/app/modules/register/controllers/register_controller.dart';
import 'package:spotergs/app/repositories/auth_repository.dart';

class RegisterBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<AuthRepository>(AuthRepository());
    Get.put<RegisterController>(RegisterController(repository: Get.find()));
  }
}