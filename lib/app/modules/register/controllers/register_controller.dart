import 'package:get/get.dart';
import 'package:spotergs/app/modules/register/repositories/register_repository.dart';

class RegisterController extends GetxController{
  RegisterRepository repository;

  RegisterController({required this.repository});

  RxString userName = ''.obs;
  RxString email = ''.obs; 
  RxString password = ''.obs;
 Future<void> registerUser() async{
 
  var response = await repository.registerUser(userName.value, password.value, email.value);
  print(response);
 }




}