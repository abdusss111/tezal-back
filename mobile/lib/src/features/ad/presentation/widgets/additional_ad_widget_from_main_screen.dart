import 'package:eqshare_mobile/src/core/res/app_images.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';

import 'package:flutter/material.dart';

class AdditionalAdWidgetFromMainScreen extends StatelessWidget {
  final AdListRowData adListRowData;
  const AdditionalAdWidgetFromMainScreen(
      {super.key, required this.adListRowData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Opacity(
            opacity: 0.2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: adListRowData.imageUrl != null &&
                          adListRowData.imageUrl!.isNotEmpty
                      ? NetworkImage(
                          adListRowData.imageUrl!) // Загрузка из сети
                      : const AssetImage(AppImages.imagePlaceholderWithIcon)
                          as ImageProvider, // Локальное изображение
                  fit: BoxFit.fill, // Это сделает изображение на весь размер
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  adListRowData.title ?? '',
                  style: Theme.of(context).textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                    adListRowData.price != null && adListRowData.price != 0 && adListRowData.price != 2000
                        ? "Цена ${adListRowData.price} тг/час"
                        : 'Договорная',
                    style: Theme.of(context).textTheme.bodySmall),
                if (adListRowData.category != null &&
                    adListRowData.category!.isNotEmpty)
                  Text(
                    'Категория: ${adListRowData.category ?? ''}',
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    '${adListRowData.city}${adListRowData.address != null ? ",${adListRowData.address}" : ''}',
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
