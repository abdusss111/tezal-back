import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class AppLikeButtonWrapper extends StatelessWidget {
  const AppLikeButtonWrapper(
      {super.key, required this.isLiked, required this.onTap});

  final bool? isLiked;
  final Function(bool) onTap;

  @override
  Widget build(BuildContext context) {
    return LikeButton(
      bubblesSize: 0,
      circleSize: 0,
      animationDuration: const Duration(milliseconds: 300),
      isLiked: isLiked,
      bubblesColor: const BubblesColor(
        dotPrimaryColor: Colors.red,
        dotSecondaryColor: Colors.red,
        dotThirdColor: Colors.red,
        dotLastColor: Colors.red,
      ),
      circleColor: const CircleColor(start: Colors.red, end: Colors.red),
      likeBuilder: (isTapped) {
        return isLiked == true
            ? const Icon(
                Icons.favorite_rounded,
                size: 30,
                color: Colors.red,
              )
            : const Icon(
                Icons.favorite_border_rounded,
                size: 30,
                color: Colors.red,
              );
      },
      onTap: (isTapped) async {
        onTap(isTapped);
        return !isTapped;
      },
    );
  }
}
