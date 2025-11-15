import 'package:get/get.dart';
import 'package:spotergs/app/modules/login/repositories/login_repository.dart';

class LoginController extends GetxController {
  LoginRepository repository;

  LoginController({required this.repository});

  RxString email = ''.obs;
  RxString password = ''.obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  Future<void> loginUser() async {
    if (email.value.isEmpty || password.value.isEmpty) {
      errorMessage.value = 'Email e senha são obrigatórios';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      var response = await repository.loginUser(email.value, password.value);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        errorMessage.value = '';
        Get.offNamed('/home');
      } else {
        errorMessage.value = 'Falha no login';
      }
    } catch (e) {
      errorMessage.value = 'Erro na conexão: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
}
