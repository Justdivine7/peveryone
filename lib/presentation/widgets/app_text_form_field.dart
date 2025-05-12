import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final String hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? suffixIconColor;
  final Color? prefixIconColor;
  final TextEditingController textController;
  final bool obscure;
  final String? Function(String?)? validator;
  const AppTextFormField({
    super.key,
    required this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.suffixIconColor,
    this.prefixIconColor,
    required this.textController,
    required this.obscure,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: textController,
      style: TextStyle(color: Colors.black),
      obscureText: obscure,
      decoration: InputDecoration(
        errorStyle: TextStyle(color: Theme.of(context).dividerColor),
        contentPadding: EdgeInsets.all(10),
        filled: true,
        fillColor: Theme.of(context).indicatorColor,
        hintText: hintText,
        hintStyle: TextStyle(color: Theme.of(context).focusColor),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        suffixIconColor: suffixIconColor,
        prefixIconColor: prefixIconColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).focusColor),
        ),
      ),
    );
  }
}
