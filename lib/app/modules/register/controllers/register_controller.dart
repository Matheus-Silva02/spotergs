import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotergs/app/repositories/auth_repository.dart';

class RegisterController extends GetxController {
  AuthRepository repository;

  RegisterController({required this.repository});

  RxString name = ''.obs;
  RxString password = ''.obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  Future<void> registerUser() async {
    if (name.value.isEmpty || password.value.isEmpty) {
      errorMessage.value = 'Nome e senha são obrigatórios';
      return;
    }

    if (password.value.length < 4) {
      errorMessage.value = 'Senha deve ter pelo menos 4 caracteres';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      var response = await repository.register(
        name: name.value,
        password: password.value,
      );

      if (response != null && response['status'] == 'success') {
        errorMessage.value = '';
        
        // Show success message first
      
        // Show loading dialog for 2 seconds
        Get.dialog(
          WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          barrierDismissible: false,
        );
        
        // Wait 2 seconds then navigate
        await Future.delayed(const Duration(seconds: 2));
        Get.back(); // Close loading dialog
          Get.snackbar(
          'Sucesso',
          'Conta criada com sucesso! Faça login para aproveitar suas muúsicas!',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
        
        Get.offNamed('/login');
      } else {
        errorMessage.value = response?['message'] ?? 'Falha no registro';
      }
    } catch (e) {
      errorMessage.value = 'Erro na conexão: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
}
