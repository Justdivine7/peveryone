import 'package:flutter/material.dart';

class BuildRichText extends StatelessWidget {
  final String title;
  final String subtitle;
  const BuildRichText({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          TextSpan(
            text: title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          TextSpan(text: "   $subtitle", style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
