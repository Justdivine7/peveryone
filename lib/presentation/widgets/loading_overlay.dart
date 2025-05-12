import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String animationPath;
  final double size;
  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.animationPath = 'assets/animations/loading.json',
    this.size = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            decoration: BoxDecoration(color: Color.fromARGB(150, 0, 0, 0)),
            child: Center(
              child: Container(
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: Lottie.asset(animationPath, width: size, height: size),
              ),
            ),
          ),
      ],
    );
  }
}
