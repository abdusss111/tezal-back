import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:flutter/material.dart';

class AdSmallInfoWidget extends StatelessWidget {
  const AdSmallInfoWidget({
    super.key,
    this.titleText,
    this.subCategory,
    this.brand,
    this.price,
    // this.rating,
    this.city,
    required this.hintTextForTitleText,
    this.hintTextForBrandText,
  });
  final String? titleText;
  final String hintTextForTitleText;
  final String? hintTextForBrandText;
  final String? brand;
  final String? subCategory;
  final int? price;
  // final double? rating;
  final String? city;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleText ?? hintTextForTitleText,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          // (rating != null)
          //     ? _DetailRowWidget(
          //         'Рейтинг', '\u2605 ${rating?.toStringAsFixed(1) ?? ''}')
              // : const SizedBox(),
          if (hintTextForBrandText != null)
            _DetailRowWidget('Бренд', brand ?? hintTextForBrandText ?? ''),
          _DetailRowWidget('Категория', subCategory ?? ''),
          price != null
              ? _DetailRowWidget('Цена', getPrice(price.toString()))
              : const SizedBox(),
          city != null ? _DetailRowWidget('Город', '$city') : const SizedBox(),
        ],
      ),
    );
  }
}

class _DetailRowWidget extends StatelessWidget {
  final String title;
  final String value;

  const _DetailRowWidget(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 14,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
