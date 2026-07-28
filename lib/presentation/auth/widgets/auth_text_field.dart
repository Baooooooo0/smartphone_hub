import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';

/// AuthTextField — Input field dùng chung cho các màn hình auth
class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      style: AppTypography.bodyLarge,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.textSecondary, size: AppSizes.iconMD)
            : null,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: AppSizes.md,
        ),
      ),
    );
  }
}
