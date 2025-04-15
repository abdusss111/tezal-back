import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppImageRectangleNetworkWidget extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit? boxFit;
  final String imagePlaceholder;

  const AppImageRectangleNetworkWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.boxFit,
    required this.imagePlaceholder,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: width ?? 80,
          height: height ?? 120,
          child: Image.asset(
            imagePlaceholder,
            fit: boxFit ?? BoxFit.cover,
          ),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          progressIndicatorBuilder: (context, string, progress) {
            return const Center(child: CircularProgressIndicator());
          },
          errorWidget: (context, url, error) {
            return Container(
              width: width ?? 80,
              height: height ?? 120,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle, // Ensures the fallback is circular
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(imagePlaceholder),
                ),
              ),
            );
          },
          imageBuilder: (context, imageProvider) {
            return Image(
              image: imageProvider,
              width: width ?? 75,
              height: height ?? 75,
              fit: boxFit ?? BoxFit.cover,
            );
          },
        ),
      );
    }
  }
}
