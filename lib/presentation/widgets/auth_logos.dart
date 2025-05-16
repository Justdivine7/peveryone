import 'package:flutter/material.dart';
import 'package:peveryone/core/helpers/ui_helpers.dart';

class AuthLogos extends StatelessWidget {
  final String image;
  const AuthLogos({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width(context, 0.2),
      
      decoration: BoxDecoration(
        color: Theme.of(context).indicatorColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Image.asset(image),
    );
  }
}
