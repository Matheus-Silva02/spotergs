import 'package:get/get.dart';
import 'package:spotergs/app/modules/register/controllers/register_controller.dart';

class RegisterBinding implements Bindings{
  @override
  void dependencies() {
   Get.put<RegisterController>(RegisterController());
  }
}