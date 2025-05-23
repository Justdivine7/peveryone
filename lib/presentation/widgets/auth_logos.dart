import 'package:flutter/material.dart';

class AuthLogos extends StatelessWidget {
  final String image;
  final String label;
  final void Function()? onTap;
  const AuthLogos({
    super.key,
    required this.image,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: Theme.of(context).indicatorColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(label), SizedBox(width: 10), Image.asset(image)],
          ),
        ),
      ),
    );
  }
}
