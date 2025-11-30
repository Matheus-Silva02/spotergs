import 'package:get/get.dart';
import 'package:spotergs/app/modules/register/controllers/register_controller.dart';
import 'package:spotergs/app/modules/register/repositories/register_repository.dart';

class RegisterBinding implements Bindings{
  @override
  void dependencies() {
   Get.put<RegisterRepository>(RegisterRepository());
   Get.put<RegisterController>(RegisterController(repository: Get.find()));
  }
}