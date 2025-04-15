import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/empty_list_widgets/app_empty_list_widget.dart';
import 'package:eqshare_mobile/src/core/res/app_images.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/app_ad_iamge_place_holder_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/presentation/widgets/rating_with_star_widget.dart';

class AppAdGridViewWidget extends StatelessWidget {
  final void Function(int) onAdTap;
  final void Function(int)? onShowedAdAtIndex;
  final List<AdListRowData> adList;
  final bool isContentEmpty;

  const AppAdGridViewWidget({
    super.key,
    required this.onAdTap,
    required this.adList,
    required this.isContentEmpty,
    this.onShowedAdAtIndex,
  });

  @override
  Widget build(BuildContext context) {
    if (!isContentEmpty) {
      return GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: adList.length,
        itemBuilder: (context, index) {
          final ad = adList[index];
          if (onShowedAdAtIndex != null) onShowedAdAtIndex!(index);
          return AppGridViewAdItem(
            onTap: () {
              onAdTap(index);
            },
            adListRowData: ad,
          );
        },
      );
    } else {
      return const AppAdEmptyListWidget();
    }
  }
}

class AppGridViewAdItem extends StatefulWidget {
  final VoidCallback onTap;
  final AdListRowData adListRowData;
  final double? elevation;

  const AppGridViewAdItem(
      {super.key,
      required this.onTap,
      required this.adListRowData,
      this.elevation});

  @override
  State<AppGridViewAdItem> createState() => _AppGridViewAdItemState();
}

class _AppGridViewAdItemState extends State<AppGridViewAdItem> {
  final PageController controller = PageController();
  Widget textWithPadding({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: child,
    );
  }

  String getPrice() {
    if (widget.adListRowData.price == null ||
        widget.adListRowData.price == 0 ||
        widget.adListRowData.price == 2000) {
      return 'Договорная';
    } else {
      return '${(widget.adListRowData.price ?? 0).toInt()} тг/час';
    }
  }

  CachedNetworkImage cahcedAdGridViewImageWidget(String imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      progressIndicatorBuilder: (context, text, progress) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.16,
          child: AppCircularProgressIndicator()),
      imageBuilder: (context, imageProvider) => Container(
        height: MediaQuery.of(context).size.height * 0.16,
        width: double.maxFinite,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10)),
      ),
      errorWidget: (context, url, error) {
        log(DateTime.now().toString());
        return Container(
          height: MediaQuery.of(context).size.height * 0.16,
          width: double.maxFinite,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                AppImages.imagePlaceholderWithIcon,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.adListRowData.imageUrls ?? [];
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              offset: const Offset(-1, -1),
              blurRadius: 5,
              color: const Color.fromRGBO(0, 0, 0, 0.04),
            ),
            BoxShadow(
              offset: const Offset(1, 1),
              blurRadius: 5,
              color: const Color.fromRGBO(0, 0, 0, 0.04),
            ),
          ],
        ),
        child: Card(
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        elevation: widget.elevation ?? 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child:
        images.isEmpty
        ? AppAdIamgePlaceHolderWithIcon(height: 120)
              : SizedBox(
          width: double.infinity,
          height: 120,
          child: PageView(
            controller: controller,
            children: images
                .map((e) => cahcedAdGridViewImageWidget(e))
                .toList(),
          ),
        )),
            // if (images.isNotEmpty && images.length != 1)
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                child: SmoothPageIndicator(
                    controller: controller,
                    count: images.length,
                    effect: WormEffect(
                        dotHeight: 6,
                        dotWidth: 6,
                        activeDotColor: images.length == 1
                            ? Colors.grey
                            : Theme.of(context).primaryColor,
                        dotColor: Colors.grey),
                    onDotClicked: (index) {}),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  textWithPadding(
                    child: Text(
                      widget.adListRowData.title ?? '',
                      style: Theme.of(context).textTheme.headlineSmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  textWithPadding(
                    child: Text(
                      getPrice(),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.black54, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textWithPadding(
                            child: Text(
                                '${(widget.adListRowData.city ?? '').isEmpty ? 'Не указан' : '${widget.adListRowData.city},'} ${widget.adListRowData.createdAt != null ? DateTimeUtils.fromStringFormatDateYYMMDD(widget.adListRowData.createdAt!.substring(0, 11)) : ''}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1)),
                        RatingWithStarWidget(
                            rating: widget.adListRowData.rating,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontWeight: FontWeight.w400))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
