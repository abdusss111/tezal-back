import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:eqshare_mobile/src/core/res/app_images.dart';
import 'package:flutter/material.dart';

class AdDetailPhotosWidget extends StatefulWidget {
  final String? imagePlaceholder;
  const AdDetailPhotosWidget({
    super.key,
    required this.imageUrls,
    this.height,
    this.imagePlaceholder = AppImages.imagePlaceholder,
  });

  final double? height;
  final List<String?> imageUrls;

  @override
  State<AdDetailPhotosWidget> createState() => _AdDetailPhotosWidgetState();
}

class _AdDetailPhotosWidgetState extends State<AdDetailPhotosWidget> {
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
            image: AssetImage(widget.imagePlaceholder ?? AppImages.imagePlaceholderWithIcon),
          ),
        ),
      );
    }
    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FullScreenImage(imageUrl: widget.imageUrls[index]!),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrls[index] ?? '',
                    fit: BoxFit.cover, // Оставляем без искажений
                    progressIndicatorBuilder: (context, string, progress) {
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorWidget: (context, url, error) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.16,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(widget.imagePlaceholder ?? AppImages.imagePlaceholder),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
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
            : const SizedBox(),
      ],
    );
  }
}

// Экран для полноразмерного просмотра без зума
class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Черный фон для лучшего просмотра
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain, // Оставляем оригинальный размер
          progressIndicatorBuilder: (context, url, progress) =>
          const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Image.asset(
            AppImages.imagePlaceholderWithIcon,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
