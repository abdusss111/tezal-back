import 'package:eqshare_mobile/src/core/data/repositories/user_recently_viewed_ads_repo.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_list_search_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/presentation/widgets/app_location_f_a_b.dart';
import '../../../../../../home/home_controller.dart';
import 'ad_sm_list_controller.dart';
import 'ad_sm_list_widget.dart';

class AdSMListScreen extends StatelessWidget {
  final int? subCategoryId;
  final String? subCategoryName;
  final int? typeId;
  final String? typeName;
  final String? selectedServiceType;
  final bool showAdditionalAdWidget;

  const AdSMListScreen({
    super.key,
    required this.typeId,
    required this.typeName,
    required this.subCategoryId,
    required this.subCategoryName,
    required this.selectedServiceType,
    required this.showAdditionalAdWidget,
  });

  @override
  Widget build(BuildContext context) {
    final homeController = Provider.of<HomeController>(context, listen: false);
    final cityId = homeController.selectedCity?.id ?? 0;
    return Stack(
      children: [
        Scaffold(
          floatingActionButton: const AppLocationFAB(),
          appBar: const AdListSearchAppBar(),
          body: ChangeNotifierProvider(
            create: (_) => AdSMListController(
              userRecentlyViewedAdsRepo: Provider.of<UserRecentlyViewedAdsRepo>(
                  context,
                  listen: false),
              selectedServiceType:
                  getServiceTypeEnumFromString(selectedServiceType),
            )..setupAds(
              cityId: cityId,
                serviceTypeEnum:
                    getServiceTypeEnumFromString(selectedServiceType)),
            child: AdSMListWidget(
                subCategoryId: subCategoryId,
                subCategoryName: subCategoryName,
                typeId: typeId,
                typeName: typeName,
                cityId: cityId,
                showAdditionalAdWidget: showAdditionalAdWidget,
                selectedServiceType: selectedServiceType),
          ),
        ),
      ],
    );
  }
}
