import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotergs/app/core/theme/app_theme.dart';
import 'package:spotergs/app/core/theme/app_text_styles.dart';
import 'package:spotergs/app/modules/register/controllers/register_controller.dart';
import 'package:spotergs/app/modules/register/widgets/register_text_field.dart';
import 'package:spotergs/app/widgets/custom_buttom.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

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
                'Ola! Como vai?',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              Text(
                'Comece criando sua conta para ouvir suas músicas favoritas!',
                style: AppTextStyles.secondaryHeadlineSmall.copyWith(
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              RegisterTextField(
                onValueChanged: (value) => {controller.name.value = value},
                label: 'Nome de usuário',
                prefixIcon: Icon(
                  Icons.person,
                  color: AppTheme.textPrimaryColor,
                ),
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
                      style: AppTextStyles.secondaryHeadlineSmall.copyWith(
                        color: AppTheme.errorColor,
                      ),
                    )
                    : const SizedBox.shrink();
              }),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Obx(() {
                  return CustomButtom(
                    function:
                        controller.isLoading.value
                            ? () {}
                            : controller.registerUser,
                    backgroundColor: AppTheme.primaryColor,
                    textStyle: AppTextStyles.titleMedium.copyWith(
                      color: Colors.black,
                    ),
                    text:
                        controller.isLoading.value
                            ? 'Carregando...'
                            : 'Criar conta',
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
