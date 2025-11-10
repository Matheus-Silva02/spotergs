import 'package:flutter/material.dart';
import 'package:spotergs/app/core/theme/overrides/app_colors.dart';

class RegisterTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enableVisibilityToggle;
  final Color? textColor;
  final Color? cursorColor;
  final String? textValue;
  final ValueChanged<String>? onValueChanged;

  const RegisterTextField({
    super.key,
    this.controller,
    required this.label,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.enableVisibilityToggle = true,
    this.textColor,
    this.cursorColor,
    this.textValue,
    this.onValueChanged,
  });

  @override
  State<RegisterTextField> createState() => _RegisterTextFieldState();
}

class _RegisterTextFieldState extends State<RegisterTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  void _toggleObscure() {
    setState(() => _obscure = !_obscure);
  }

  @override
  Widget build(BuildContext context) {
    final effectiveSuffix = widget.suffixIcon ??
        (widget.obscureText && widget.enableVisibilityToggle
            ? IconButton(
                onPressed: _toggleObscure,
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility,
                    color: widget.textColor ?? AppColors.neutral.shade100),
              )
            : null);

    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      onChanged: (value) {
        widget.onValueChanged?.call(value);
      },
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      style: TextStyle(color: widget.textColor ?? AppColors.neutral.shade100),
      cursorColor: widget.cursorColor ?? AppColors.primary,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.secondary),
          borderRadius: BorderRadius.circular(8),
        ),
        fillColor: AppColors.secondary.shade900,
        labelText: widget.label,
        labelStyle: TextStyle(color: AppColors.neutral.shade100),
        prefixIcon: widget.prefixIcon,
        suffixIcon: effectiveSuffix,
      ),
    );
  }
}
