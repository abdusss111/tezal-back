import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/utils/sliver_delegate.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/get_widget.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:flutter/material.dart';

List<Widget> recommendationAds(BuildContext context,
    {required final Future<List<AdListRowData>> getRecommendationAds,
    required final Future<List<AdListRowData>> retryAds,
    required final int adID}) {
  Widget textWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4,4,12),
      child: Text(
        'Рекомендации для вас',
        style: Theme.of(context).textTheme.displaySmall,
      ),
    );
  }

  FutureBuilder<List<AdListRowData>> futureBuilder(
      Future<List<AdListRowData>> getRecommendationAds,
      Future<List<AdListRowData>> retryAds,
      int adID) {
    return FutureBuilder<List<AdListRowData>>(
      future: getRecommendationAds, // Ожидаемая Future
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: AppCircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return isanamiItachi(retryAds, adID);
        } else {
          final list = snapshot.data ?? [];

          list.removeWhere((e) => e.id == adID);
          if (list.isEmpty) {
            return isanamiItachi(retryAds, adID);
          }

          return GridView(
            gridDelegate:
                SliverDelegate().sliverGridDelegateWithFixedCrossAxisCount(),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: list.map((e) {
              return AppGridViewAdItem(
                onTap: () {
                  onAdTapAdListRowData(
                      e.allServiceTypeEnum!, context, (e.id ?? 0).toString());
                },
                adListRowData: e,
              );
            }).toList(),
          );
        }
      },
    );
  }

  return [
    textWidget(context),
    futureBuilder(getRecommendationAds, retryAds, adID),
  ];
}

FutureBuilder<List<AdListRowData>> isanamiItachi(
    Future<List<AdListRowData>> retryAds, int adID) {
  return FutureBuilder(
      future: retryAds,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: AppCircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox();
        } else {
          final list = snapshot.data ?? [];

          list.removeWhere((e) => e.id == adID);

          return GridView(
            gridDelegate:
                SliverDelegate().sliverGridDelegateWithFixedCrossAxisCount(),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: list.map((e) {
              return AppGridViewAdItem(
                onTap: () {
                  onAdTapAdListRowData(
                      e.allServiceTypeEnum!, context, (e.id ?? 0).toString());
                },
                adListRowData: e,
              );
            }).toList(),
          );
        }
      });
}
