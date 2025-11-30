import 'package:flutter/material.dart';
import 'package:spotergs/app/core/theme/app_theme.dart';

class CustomButtom extends StatelessWidget{
  
  final Color? backgroundColor;
  final String? text;
  final TextStyle? textStyle;
  final VoidCallback? function;

  
  const CustomButtom({super.key, this.backgroundColor = AppTheme.surfaceColor, this.text = 'Continuar', this.textStyle, this.function,});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      splashColor: AppTheme.surfaceColor,
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