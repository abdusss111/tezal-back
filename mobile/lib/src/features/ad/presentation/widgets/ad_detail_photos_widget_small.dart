import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:eqshare_mobile/src/core/res/app_images.dart';
import 'package:eqshare_mobile/src/core/res/extensions/image_extension.dart';

import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

class AdDetailPhotosWidgetSmall extends StatefulWidget {
  final String? imagePlaceholder;
  const AdDetailPhotosWidgetSmall(
      {super.key, required this.imageUrls, this.height, this.imagePlaceholder = AppImages.imagePlaceholder});
  final double? height;

  final List<String?> imageUrls;

  @override
  State<AdDetailPhotosWidgetSmall> createState() => _AdDetailPhotosSmallWidgetState();
}

class _AdDetailPhotosSmallWidgetState extends State<AdDetailPhotosWidgetSmall> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: _currentIndex);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return Container(
          height: MediaQuery.of(context).size.height * 0.24,
          width: double.maxFinite,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage(widget.imagePlaceholder ??
                      AppImages.imagePlaceholderWithIcon))));
    }
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  child: InstaImageViewer(
                    child: CachedNetworkImage(
                        imageUrl: widget.imageUrls[index] ?? '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        progressIndicatorBuilder: (context, string, progress) {
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorWidget: (context, url, error) {
                          return Container(
                              height: MediaQuery.of(context).size.height * 0.16,
                              width: double.maxFinite,
                              decoration: BoxDecoration(

                                  image: DecorationImage(
                                      image: AssetImage(widget.imagePlaceholder ??
                                          AppImages.imagePlaceholder))));
                        }),
                  ));
            },
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 10),
        widget.imageUrls.isNotEmpty
            ? DotsIndicator(
          dotsCount: widget.imageUrls.length,
          position: _currentIndex,
          decorator: DotsDecorator(
            size: const Size.square(5.0),
            activeSize: const Size.square(5.0),
            color: Colors.grey,
            activeColor: Theme.of(context).primaryColor,
          ),
          onTap: (position) {
            _pageController.animateToPage(
              position.toInt(),
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          },
        )
            : const SizedBox()
      ],
    );
  }
}
