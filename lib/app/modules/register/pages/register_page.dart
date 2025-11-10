import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:spotergs/app/core/theme/overrides/app_colors.dart';
import 'package:spotergs/app/core/theme/overrides/app_text_styles';
import 'package:spotergs/app/modules/register/controllers/register_controller.dart';
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
            children: [Text('Comece criando sua conta para ouvir suas músicas favoritas!', style: AppTextStyles.headLineSmall.copyWith(color: AppColors.primary),),
              TextFormField(
                
                decoration:InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondary),
                  borderRadius: BorderRadius.circular(8),

                ),
                  fillColor: AppColors.secondary.shade900,
                  labelText: 'Nome de usuário',
                  labelStyle: TextStyle(color: AppColors.primary)
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                   enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondary),
                  borderRadius: BorderRadius.circular(8),

                ),
                   fillColor: AppColors.secondary.shade900,
                  labelText: 'Email',
                  labelStyle: TextStyle(color: AppColors.primary)
                ),
              ),
              TextFormField(decoration: InputDecoration(
                 enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondary),
                  borderRadius: BorderRadius.circular(8),

                ),
                  labelText: 'Senha',
                  labelStyle: TextStyle(color: AppColors.primary),
                     fillColor: AppColors.secondary.shade900,
                ),),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: CustomButtom(
                  backgroundColor: AppColors.primary,
                  textStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral.shade200),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}