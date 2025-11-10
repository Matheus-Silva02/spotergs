import 'package:flutter/material.dart';
import 'package:spotergs/app/core/theme/overrides/app_colors.dart';

class CustomButtom extends StatelessWidget{
  
  final Color? backgroundColor;
  final String? text;
  final TextStyle? textStyle;
  
  const CustomButtom({super.key, this.backgroundColor = AppColors.secondary, this.text = 'Continuar', this.textStyle,});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColors.secondary,
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: backgroundColor
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text(text!, style: textStyle ,)),
          ),
        ),
    );
  }
}