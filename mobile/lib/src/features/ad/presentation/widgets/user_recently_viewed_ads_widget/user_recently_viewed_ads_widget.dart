import 'dart:developer';

import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/utils/sliver_delegate.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/get_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/user_recently_viewed_ads_widget/user_recently_viewed_ads_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserRecentlyViewedAdsWidget extends StatefulWidget {
  final double? height;
  final void Function() updateWidget;
  const UserRecentlyViewedAdsWidget(
      {super.key, this.height, required this.updateWidget});

  @override
  State<UserRecentlyViewedAdsWidget> createState() =>
      _UserRecentlyViewedAdsWidgetState();
}

class _UserRecentlyViewedAdsWidgetState
    extends State<UserRecentlyViewedAdsWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserRecentlyViewedAdsController>(
      builder: (context, value, child) {
        if (value.isLoading) {
          return SizedBox(
              height: widget.height ?? 120,
              child: AppCircularProgressIndicator());
        } else {
          if (value.showData.runtimeType == List<AdListRowData>) {
            if (value.showData.isEmpty) {
              return SizedBox();
            }
            return SizedBox(
              height: widget.height ?? MediaQuery.of(context).size.height * 0.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textWidget(),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextButton.icon(
                            onPressed: () {
                              value.deleteList(context).then((value) {
                                widget.updateWidget();
                              });
                            },
                            icon: Icon(Icons.delete),
                            label: Text('Очистить список')),
                      )
                    ],
                  ),
                  Expanded(
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverDelegate().sliverForLitle(),
                      itemCount: value.showData.length,
                      itemBuilder: (context, index) {
                        final item = value.showData[index];
                        return GestureDetector(
                          onTap: () {},
                          child: AdditionalAdWidgetFromMainScreen(
                              adListRowData: item),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('Что то пошло не так'));
          }
        }
      },
    );
  }

  Padding textWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text('Вы недавно смотрели ',
          style: Theme.of(context).textTheme.displaySmall),
    );
  }
}
