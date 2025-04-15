import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/help_widgets/detail_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SpecializedMachineryInfoWidget extends StatelessWidget {
  const SpecializedMachineryInfoWidget({
    super.key,
    this.titleText,
    this.title,
    this.userName,
    this.urlFoto,
    this.name,
    this.brand,
    this.subCategory,
    this.price,
    this.city,
    this.forClient = false,
    this.startedTime,
    this.createdTime,
    this.endedTime,
  });

  final String? titleText;
  final String? title;
  final String? userName;
  final String? startedTime;
  final String? endedTime;
  final String? createdTime;
  final List<String>? urlFoto;
  final String? name;
  final String? brand;
  final String? subCategory;
  final int? price;
  final String? city;
  final bool forClient;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleText ?? 'Информация о спецтехнике',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          if (urlFoto != null && urlFoto!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(0),
                    child: (
                  SizedBox(
                    width: 200, // Increased width
                    height: 150, // Increased height
                    child: CachedNetworkImage(
                      imageUrl: urlFoto?.first.toString() ?? '',
                      fit: BoxFit.fitWidth,
                      errorWidget: (context, url, error) {
                        return Center(
                          child: Text(
                            error.toString().substring(0, 50),
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      },
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          width: double.infinity,
                          color: Colors.white,
                        ),
                      ),
                      imageBuilder: (context, imageProvider) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        );
                      },
                    ),
                  ))),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      name ?? '',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          title != null && title!.isNotEmpty
              ? DetailRowWidget('Название', '$title')
              : const SizedBox(),
          !forClient &&
                  userName != null &&
                  userName!.isNotEmpty &&
                  userName!.length > 2 &&
                  !userName!.contains('null')
              ? DetailRowWidget('Автор', '$userName')
              : const SizedBox(),
          city != null && city!.isNotEmpty
              ? DetailRowWidget('Город', '$city')
              : const SizedBox(),
          brand != null && brand!.isNotEmpty
              ? DetailRowWidget('Бренд', brand ?? '')
              : const SizedBox(),
          subCategory != null && subCategory!.isNotEmpty
              ? DetailRowWidget('Категория', subCategory ?? '')
              : const SizedBox(),
          price != null && price != 0
              ? DetailRowWidget('Цена', price!=null ? ' $price тг/час' : 'Договорная')
              : const SizedBox(),
          if (createdTime != null)
            DetailRowWidget(
              'Объявление создано',
              DateTimeUtils.formatDatetime(createdTime!),
            ),
          if (startedTime != null)
            DetailRowWidget(
              'Планируемое начало',
              DateTimeUtils.formatDatetime(startedTime!),
            ),
          if (endedTime != null &&
              endedTime!.isNotEmpty &&
              endedTime != 'null')
            DetailRowWidget(
              'Планируемое завершение',
              DateTimeUtils.formatDatetime(endedTime),
            ),
        ],
      ),
    );
  }
}
