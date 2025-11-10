import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:spotergs/app/modules/register/repositories/register_repository.dart';

class Initializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Inicializar repositórios
    Get.put<RegisterRepository>(RegisterRepository());

    // Aqui você pode adicionar suas inicializações de dependências
    // Exemplo usando Get.put():
    // Get.put<MinhaClasse>(MinhaClasse());
    // Get.lazyPut(() => MeuServico());

    // Carregar informações do pacote
    try {
      await Get.putAsync(() async => PackageInfo.fromPlatform());
    } catch (e) {
      print('Error loading package info: $e');
    }
  }
}
