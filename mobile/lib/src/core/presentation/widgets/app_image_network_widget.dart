import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppImageNetworkWidget extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit? boxFit;
  final String imagePlaceholder;

  const AppImageNetworkWidget({
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
      return ClipOval(
        child: SizedBox(
          width: width ?? 80,
          height: height ?? 80,
          child: Image.asset(
            imagePlaceholder,
            fit: boxFit ?? BoxFit.cover,
          ),
        ),
      );
    } else {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          progressIndicatorBuilder: (context, string, progress) {
            return const Center(child: CircularProgressIndicator());
          },
          errorWidget: (context, url, error) {
            return Container(
              width: width ?? 80,
              height: height ?? 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Ensures the fallback is circular
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
