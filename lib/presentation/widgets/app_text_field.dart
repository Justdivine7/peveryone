import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? suffixIconColor;
  final Color? prefixIconColor;
  final TextEditingController textController;
  final bool obscure;
  const AppTextField({
    super.key,
    required this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.suffixIconColor,
    this.prefixIconColor,
    required this.textController,
    required this.obscure,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      style: TextStyle(color: Colors.black),
      obscureText: obscure,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10),
        filled: true,
        fillColor: Theme.of(context).indicatorColor,
        hintText: hintText,
        hintStyle: TextStyle(color: Theme.of(context).focusColor),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        suffixIconColor: suffixIconColor,
        prefixIconColor: prefixIconColor,
        errorBorder: OutlineInputBorder(
          borderSide:
              BorderSide
                  .none, // removes red border when the user tries to proceed without inputting in textfield
        ),
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
