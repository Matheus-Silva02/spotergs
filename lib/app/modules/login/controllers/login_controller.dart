import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotergs/app/core/services/storage_service.dart';
import 'package:spotergs/app/repositories/auth_repository.dart';

RxString userToken = ''.obs;

class LoginController extends GetxController {
  AuthRepository repository;
  final StorageService _storageService = Get.find<StorageService>();

  LoginController({required this.repository});

  RxString name = ''.obs;
  RxString password = ''.obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  

  Future<void> loginUser() async {
    if (name.value.isEmpty || password.value.isEmpty) {
      errorMessage.value = 'Nome e senha são obrigatórios';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      var response = await repository.login(
        name: name.value,
        password: password.value,
      );

      if (response != null && response['status'] == 'success') {
        errorMessage.value = '';
        // Save token and username
        final token = response['token'];
        final username = response['nome'];
        
        if (token != null && username != null) {
          await _storageService.saveToken(token);
          await _storageService.saveUsername(username);
          userToken.value = token;
          Get.offNamed('/home');
        } else {
          errorMessage.value = 'Token ou nome não recebido do servidor';
        }
      } else {
        errorMessage.value = response?['message'] ?? 'Falha no login';
      }
    } catch (e) {
      errorMessage.value = 'Erro na conexão: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginAsGuest() async {
    TextEditingController nicknameController = TextEditingController();

    var result = await Get.dialog<String>(
      AlertDialog(
        title: const Text('Entrar como convidado'),
        content: TextField(
          controller: nicknameController,
          decoration: const InputDecoration(hintText: 'Digite seu nickname'),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Get.back(result: nicknameController.text),
            child: const Text('Entrar'),
          ),
        ],
      ),
    );

    if (result != null && result.trim().isNotEmpty) {
      isLoading.value = true;
      errorMessage.value = '';

      try {
        var response = await repository.guestLogin(nickname: result.trim());
        if (response != null) {
          Get.offNamed('/home');
        } else {
          errorMessage.value = 'Erro ao entrar como convidado';
        }
      } catch (e) {
        errorMessage.value = 'Erro ao entrar como convidado: ${e.toString()}';
      } finally {
        isLoading.value = false;
      }
    }
  }
}
