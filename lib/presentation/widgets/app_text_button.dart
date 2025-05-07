import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  final String label;
  final Color textColor;
  final FontWeight? fontWeight;
  final void Function()? onTap;
  final double? fontSize;
  const AppTextButton({
    super.key,
    required this.label,
    required this.textColor,
    this.onTap,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: fontWeight,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
