import 'package:cached_network_image/cached_network_image.dart';
import 'package:eqshare_mobile/src/core/res/extensions/image_extension.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class RequestPhoto extends StatelessWidget {
  const RequestPhoto({
    super.key,
    required this.urlFoto,
  });

  final String? urlFoto;

  @override
  Widget build(BuildContext context) {
    final imagePlaceholder =
        Container(width: double.maxFinite, color: Colors.grey.shade100);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: urlFoto?.isNotEmpty == true
          ? CachedNetworkImage(
              height: 125,
              width: 125,
              memCacheHeight:
                  (AppDimensions.requestExecutionContainerHeight - 10)
                      .cacheSize(context),
              memCacheWidth:
                  (AppDimensions.requestExecutionContainerHeight - 10)
                      .cacheSize(context),
              fit: BoxFit.fill, 
              imageUrl: urlFoto ?? '',
              placeholder: (context, url) => imagePlaceholder,
              errorWidget: (context, url, error) => const Icon(Icons.error),
            )
          : const SizedBox(),
    );
  }
}
