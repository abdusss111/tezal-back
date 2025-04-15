import 'package:cached_network_image/cached_network_image.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/empty_list_widgets/app_empty_list_widget.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/page_wrapper.dart';
import 'package:eqshare_mobile/src/core/res/app_images.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/widgets/app_ad_iamge_place_holder_with_icon.dart';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/presentation/widgets/rating_with_star_widget.dart';

class AppAdListViewWidget extends StatelessWidget {
  final void Function(int) onAdTap;
  final void Function(int)? onShowedAdAtIndex;
  final double? adItemHeight;
  final BoxFit? widgetImageBoxFit;
  final double? itemExtent;

  const AppAdListViewWidget(
      {super.key,
      required this.onAdTap,
      required this.adList,
      required this.isContentEmpty,
      this.onShowedAdAtIndex,
      this.adItemHeight,
      this.itemExtent = 320,
      this.widgetImageBoxFit});

  final List<AdListRowData> adList;
  final bool isContentEmpty;

  int get listViewLength => adList.length;

  @override
  Widget build(BuildContext context) {
    if (!isContentEmpty) {
      return ListView.builder(
        itemExtent: itemExtent,
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 8.0,),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: listViewLength,
        itemBuilder: (context, index) {
          final ad = adList[index];
          if (onShowedAdAtIndex != null) onShowedAdAtIndex!(index);
          return AppAdItem(
            height: adItemHeight,
            onTap: () {
              onAdTap(index);
            },
            imageBoxFit: widgetImageBoxFit,
            adListRowData: ad,
          );
        },
      );
    } else {
      return const AppAdEmptyListWidget();
    }
  }
}

class AppAdItem extends StatefulWidget {
  final VoidCallback onTap;
  final AdListRowData adListRowData;
  final double? height;
  final BoxFit? imageBoxFit;

  const AppAdItem(
      {super.key,
      required this.onTap,
      required this.adListRowData,
      this.height,
      this.imageBoxFit});

  @override
  State<AppAdItem> createState() => _AppAdItemState();
}

class _AppAdItemState extends State<AppAdItem> {
  final PageController controller = PageController();
  String getPrice() {
    if (widget.adListRowData.price == null ||
        widget.adListRowData.price == 0 ||
        widget.adListRowData.price == 2000) {
      return 'Договорная';
    } else {
      return '${(widget.adListRowData.price ?? 0).toInt()} тг/час';
    }
  }

  Widget build(BuildContext context) {
  final images = widget.adListRowData.imageUrls ?? [];
  return 
  PageWrapper(child:
    GestureDetector(
      onTap: widget.onTap,
      child:  Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        decoration: BoxDecoration(
          color: Colors.white, // Фон контейнера
          borderRadius: BorderRadius.circular(16), // Скруглённые углы
          boxShadow: [
            BoxShadow(
              offset: Offset(-1, -1), // Смещение вверх и влево
              blurRadius: 5, // Радиус размытия
              color: Color.fromRGBO(0, 0, 0, 0.04), // Чёрный цвет с 4% прозрачностью
            ),
            BoxShadow(
              offset: Offset(1, 1), // Смещение вниз и вправо
              blurRadius: 5, // Радиус размытия
              color: Color.fromRGBO(0, 0, 0, 0.04), // Чёрный цвет с 4% прозрачностью
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (images.isEmpty)
                AppAdIamgePlaceHolderWithIcon(
                    height:200),
              if (images.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: PageView(
                    controller: controller,
                    children: images
                        .map((e) => cahcedAdListViewImageWidget(e))
                        .toList(),
                  ),
                ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SmoothPageIndicator(
                    controller: controller,
                    count: images.length,
                    effect: WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: images.length == 1
                          ? Colors.grey
                          : Theme.of(context).primaryColor,
                      dotColor: Colors.grey,
                    ),
                    onDotClicked: (index) {},
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.adListRowData.title ?? '',
                    style: Theme.of(context).textTheme.headlineSmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    'Категория: ${widget.adListRowData.category}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    getPrice(),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.black54, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Row(
                    children: [
                      if (widget.adListRowData.city != null)
                        Text(
                          widget.adListRowData.city!,
                                overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.w500)
                              .copyWith(color: Colors.grey),
                        ),
                      if (widget.adListRowData.createdAt != null)
                        Text(
                          ', ${DateTimeUtils.fromStringFormatDateYYMMDD(widget.adListRowData.createdAt!)}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.w500)
                              .copyWith(color: Colors.grey)
                        ),
                      const Spacer(),
                      if (widget.adListRowData.rating != null)
                        RatingWithStarWidget(
                          rating: widget.adListRowData.rating,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
}

  CachedNetworkImage cahcedAdListViewImageWidget(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: widget.imageBoxFit ?? BoxFit.cover,
      progressIndicatorBuilder: (context, text, progress) =>
          AppCircularProgressIndicator(),
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      height: 200,
      width: MediaQuery.sizeOf(context).width,
      errorWidget: (context, url, error) {
        return Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: widget.imageBoxFit ?? BoxFit.fill,
                    image: AssetImage(AppImages.imagePlaceholderWithIcon))));
      },
      // placeholder: (context, url) => shimmerPlaceholder,
    );
  }
}
