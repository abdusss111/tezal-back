import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';
import 'package:eqshare_mobile/src/core/res/extensions/image_extension.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_dimensions.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/request_photo.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/request_status_text.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/request_title_text.dart';
import 'package:flutter/material.dart';

class AppRequestListItemData {
  final int? id;
  final List<String>? shareLinks;
  final String? title;
  final String? startDate;
  final String? endDate;
  final String? status;
  final UserMode? createdBy;
  final DateTime? createdAt;

  const AppRequestListItemData({
    required this.id,
    this.shareLinks,
    this.title,
    this.startDate,
    this.endDate,
    this.status,
    required this.createdBy,
    required this.createdAt,
  });

  @override
  String toString() {
    return '$shareLinks';
  }
}

class AppRequestListItemWidget extends StatelessWidget {
  final AppRequestListItemData requestItemData;
  final VoidCallback onTap;
  final Future<String> Function()? getImage;

  const AppRequestListItemWidget({
    super.key,
    required this.onTap,
    required this.requestItemData,
    this.getImage,
  });

  @override
  Widget build(BuildContext context) {
    String statusText = '';

    switch (requestItemData.status) {
      case 'CANCELED':
        statusText = 'Отменен';
      case 'CREATED':
        if (requestItemData.createdBy == UserMode.client) {
          statusText = 'На утверждении клиента';
        } else {
          statusText = 'На утверждении водителя';
        }

      default:
        statusText = 'Неизвестный статус';
    }
    log(requestItemData.toString());

    final screenWidth = MediaQuery.sizeOf(context).width;
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: Container(
          padding: AppDimensions.requestExecutionContainerPadding,
          // height: AppDimensions.requestExecutionContainerHeight,
          width: screenWidth,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (getImage == null)
                requestItemData.shareLinks != null &&
                        requestItemData.shareLinks!.isNotEmpty
                    ? RequestPhoto(
                        urlFoto: requestItemData.shareLinks?.first,
                      )
                    : const RequestPhoto(
                        urlFoto:
                            'https://liamotors.com.ua/image/catalogues/products/no-image.png'),
              if (getImage != null)
                FutureBuilder(
                    future: getImage!(),
                    builder: (data, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                            height: 125,
                            width: 125,
                            child: Center(child: CircularProgressIndicator()));
                      }
                      final url = snapshot.data;
                      if (url == null) {
                        const RequestPhoto(
                            urlFoto:
                                'https://liamotors.com.ua/image/catalogues/products/no-image.png');
                      }
                      return CachedNetworkImage(
                        height: 125,
                        width: 125,
                        memCacheHeight:
                            (AppDimensions.requestExecutionContainerHeight - 10)
                                .cacheSize(context),
                        memCacheWidth:
                            (AppDimensions.requestExecutionContainerHeight - 10)
                                .cacheSize(context),
                        fit: BoxFit.fill,
                        imageUrl: url ?? '',
                        progressIndicatorBuilder: (context, url, progress) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      );
                    }),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RequestTitleText(requestTitle: requestItemData.title ?? ''),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (requestItemData.startDate != null&&
                            requestItemData.startDate != 'null')
                          Text.rich(
                            TextSpan(
                              text: 'Начало заказа: ',
                              style: Theme.of(context).textTheme.displayLarge,
                              children: [
                                TextSpan(
                                  text: DateTimeUtils.formatDatetime(
                                      requestItemData.startDate),
                                  style: Theme.of(context).textTheme.displayLarge!
                                      .copyWith(fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        if (requestItemData.endDate != null &&
                            (requestItemData.endDate ?? '').isNotEmpty &&
                            (requestItemData.endDate ?? '') != 'null')
                          Text.rich(
                            TextSpan(
                              text: 'Завершение заказа: ',
                              style: Theme.of(context).textTheme.displayLarge,
                              children: [
                                TextSpan(
                                  text: DateTimeUtils.formatDatetime(
                                      requestItemData.endDate.toString()),
                                  style: Theme.of(context).textTheme.displayLarge!
                                      .copyWith(fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        if (requestItemData.createdAt != null)
                          Text.rich(
                            TextSpan(
                              text: 'Заказ создан: ',
                              style: Theme.of(context).textTheme.displayLarge,
                              children: [
                                TextSpan(
                                  text: DateTimeUtils.formatDatetime(
                                      requestItemData.createdAt.toString()),
                                  style: Theme.of(context).textTheme.displayLarge!
                                      .copyWith(fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    RequestStatusText(statusText: statusText)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
