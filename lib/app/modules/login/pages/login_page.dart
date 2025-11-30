import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotergs/app/core/theme/app_text_styles.dart';
import 'package:spotergs/app/core/theme/app_theme.dart';
import 'package:spotergs/app/modules/login/controllers/login_controller.dart';
import 'package:spotergs/app/modules/register/widgets/register_text_field.dart';
import 'package:spotergs/app/widgets/custom_buttom.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: AppTheme.primaryColor,
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: AppTheme.surfaceColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 24,
            children: [
              Text(
                'Bem-vindo de volta!',
                style: AppTextStyles.titleLarge
                    .copyWith(color: AppTheme.textPrimaryColor),
              ),
              Text(
                'Faça login para continuar ouvindo suas músicas favoritas!',
                style: AppTextStyles.secondaryHeadlineSmall
                    .copyWith(color: AppTheme.textPrimaryColor),
              ),
              RegisterTextField(
                label: 'Email',
                onValueChanged: (value) => {controller.email.value = value},
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(Icons.email, color: AppTheme.textPrimaryColor),
              ),
              RegisterTextField(
                label: 'Senha',
                onValueChanged: (value) => {controller.password.value = value},
                textValue: controller.password.value,
                obscureText: true,
                prefixIcon: Icon(Icons.lock, color: AppTheme.textPrimaryColor),
              ),
              Obx(() {
                return controller.errorMessage.isNotEmpty
                    ? Text(
                        controller.errorMessage.value,
                        style: AppTextStyles.secondaryHeadlineSmall
                            .copyWith(color: AppTheme.errorColor),
                      )
                    : const SizedBox.shrink();
              }),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Obx(() {
                  return CustomButtom(
                    function: controller.isLoading.value
                        ? () {}
                        : controller.loginUser,
                    backgroundColor: AppTheme.primaryColor,
                    textStyle: AppTextStyles.titleMedium
                        .copyWith(color: Colors.black),
                    text: controller.isLoading.value ? 'Carregando...' : 'Login',
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CustomButtom(
                  function: controller.loginAsGuest,
                  backgroundColor: AppTheme.surfaceColor,
                  textStyle: AppTextStyles.titleMedium
                      .copyWith(color: AppTheme.textPrimaryColor),
                  text: 'Entrar como convidado',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CustomButtom(
                  function: () => Get.toNamed('/register'),
                  backgroundColor: AppTheme.surfaceColor,
                  textStyle: AppTextStyles.titleMedium
                      .copyWith(color: AppTheme.textPrimaryColor),
                  text: 'Criar conta',

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
