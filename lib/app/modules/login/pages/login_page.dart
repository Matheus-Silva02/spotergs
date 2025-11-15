import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotergs/app/core/theme/overrides/app_colors.dart';
import 'package:spotergs/app/core/theme/overrides/app_text_styles';
import 'package:spotergs/app/modules/login/controllers/login_controller.dart';
import 'package:spotergs/app/modules/register/widgets/register_text_field.dart';
import 'package:spotergs/app/widgets/custom_buttom.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: AppColors.primary,
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 24,
            children: [
              Text(
                'Bem-vindo de volta!',
                style: AppTextStyles.titleLarge
                    .copyWith(color: AppColors.neutral.shade100),
              ),
              Text(
                'Faça login para continuar ouvindo suas músicas favoritas!',
                style: AppTextStyles.secondaryHeadlineSmall
                    .copyWith(color: AppColors.neutral.shade100),
              ),
              RegisterTextField(
                label: 'Email',
                onValueChanged: (value) => {controller.email.value = value},
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(Icons.email, color: AppColors.neutral.shade100),
              ),
              RegisterTextField(
                label: 'Senha',
                onValueChanged: (value) => {controller.password.value = value},
                textValue: controller.password.value,
                obscureText: true,
                prefixIcon: Icon(Icons.lock, color: AppColors.neutral.shade100),
              ),
              Obx(() {
                return controller.errorMessage.isNotEmpty
                    ? Text(
                        controller.errorMessage.value,
                        style: AppTextStyles.secondaryHeadlineSmall
                            .copyWith(color: Colors.red),
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
                    backgroundColor: AppColors.primary,
                    textStyle: AppTextStyles.titleMedium
                        .copyWith(color: AppColors.neutral.shade200),
                    text: controller.isLoading.value ? 'Carregando...' : 'Login',
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CustomButtom(
                  function: () => Get.toNamed('/register'),
                  backgroundColor: AppColors.secondary,
                  textStyle: AppTextStyles.titleMedium
                      .copyWith(color: AppColors.white),
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
