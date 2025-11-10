import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotergs/app/core/theme/overrides/app_colors.dart';
import 'package:spotergs/app/core/theme/overrides/app_text_styles';
import 'package:spotergs/app/modules/register/controllers/register_controller.dart';
import 'package:spotergs/app/modules/register/widgets/register_text_field.dart';
import 'package:spotergs/app/widgets/custom_buttom.dart';

class RegisterPage extends GetView<RegisterController>
{
  const RegisterPage({super.key});

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
              Text('Ola! Como vai?',style: AppTextStyles.titleLarge.copyWith(color: AppColors.neutral.shade100),),
              Text('Comece criando sua conta para ouvir suas músicas favoritas!', style: AppTextStyles.secondaryHeadlineSmall.copyWith(color: AppColors.neutral.shade100),),
              RegisterTextField(
                onValueChanged: (value) => 
                {controller.userName.value = value},
                label: 'Nome de usuário',
                prefixIcon: Icon(Icons.person, color: AppColors.neutral.shade100),
              ),
              RegisterTextField(
                label: 'Email',
                onValueChanged: (value) => {
                  controller.email.value = value,
                },
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(Icons.email, color: AppColors.neutral.shade100),
              ),
              RegisterTextField(
                label: 'Senha',
                onValueChanged: (value) => 
                {
                  controller.password.value = value
                },
                textValue: controller.password.value,
                obscureText: true,
                prefixIcon: Icon(Icons.lock, color: AppColors.neutral.shade100),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: CustomButtom(
                  function: controller.registerUser,
                  backgroundColor: AppColors.primary,
                  textStyle: AppTextStyles.titleMedium.copyWith(color: AppColors.neutral.shade200),
                  
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}