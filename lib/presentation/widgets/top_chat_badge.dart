import 'package:flutter/material.dart';
import 'package:peveryone/core/helpers/ui_helpers.dart';

class TopChatBadge extends StatelessWidget {
  final ImageProvider<Object> image;
  final String userName;
  final void Function()? onTap;
  const TopChatBadge({
    super.key,
    required this.image,
    required this.userName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: width(context, 0.15),
          height:  height(context, 0.08),
            decoration: BoxDecoration(
              shape: BoxShape.circle,

              gradient: LinearGradient(
                colors: [
                  Theme.of(context).highlightColor,
                  Theme.of(context).hoverColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  // border: Border.all(color: Colors.white, width: 2),
                  image: DecorationImage(image: image),
                ),
              ),
            ),
          ),
          Text(userName),
        ],
      ),
    );
  }
}
