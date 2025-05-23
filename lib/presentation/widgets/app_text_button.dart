import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  final String? label;
  final TextSpan? richLabel;
  final Color textColor;
  final FontWeight? fontWeight;
  final void Function()? onTap;
  final double? fontSize;
  const AppTextButton({
    super.key,
    this.label,
    required this.textColor,
    this.onTap,
    this.fontSize,
    this.fontWeight,
    this.richLabel,
  }) : assert(
         label != null || richLabel != null,
         'Either label or richLabel must be provided',
       );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:
          richLabel != null
              ? RichText(text: richLabel!)
              : Text(
                label!,
                style: TextStyle(
                  color: textColor,
                  fontWeight: fontWeight,
                  fontSize: fontSize,
                ),
              ),
    );
  }
}
