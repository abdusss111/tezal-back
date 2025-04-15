import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/help_widgets/detail_row_widget.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:flutter/material.dart';

class AdSmallRequestInfoWidget extends StatelessWidget {
  const AdSmallRequestInfoWidget({
    super.key,
    this.subCategory,
    this.price,
    this.city,
    this.title,
    this.dateTime,
    required this.titleText,
    required this.brand,
  });
  final String titleText;

  final String? brand;
  final String? subCategory;
  final int? price;
  final String? city;
  final String? title;
  final String? dateTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleText,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          title != null
              ? DetailRowWidget('Название', title ?? 'Не указан')
              : const SizedBox(),
          city != null
              ? DetailRowWidget('Город', city ?? 'Не указан')
              : const SizedBox(),
          brand != null
              ? DetailRowWidget('Бренд', brand ?? 'Не указан')
              : const SizedBox(),
          subCategory != null
              ? DetailRowWidget(
                  'Категория',
                  subCategory ?? 'Не указан',
                )
              : const SizedBox(),
          price != null
              ? DetailRowWidget('Цена',  getPrice(price.toString()))
              : const SizedBox(),
          dateTime != null
              ? DetailRowWidget(
                  AppChangeNotifier().userMode == UserMode.client
                      ? 'Объявление создано'
                      : 'Объявление создано',
                  DateTimeUtils.formatDateTimeFromYYYYmmDD(DateTimeUtils()
                          .formatDateFromyyyyMMddTHHmmssSSSSSSSS(
                              dateTime ?? 'Не указан') ??
                      DateTime.now()))
              : const SizedBox(),
        ],
      ),
    );
  }
}
