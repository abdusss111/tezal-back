import 'package:eqshare_mobile/src/core/presentation/services/app_bottom_sheet_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/empty_list_widgets/app_empty_list_widget.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm_client/all_ad_sm_client/ad_sm_client_list/ad_sm_client_list_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_list_search_app_bar.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_list_tools_block.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/app_ad_grid_view_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/app_ad_list_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdSMClientListScreen extends StatefulWidget {
  final int? subCategoryId;
  final String? subCategoryName;
  final int? typeId;
  final String? typeName;

  const AdSMClientListScreen({
    super.key,
    required this.typeId,
    required this.typeName,
    required this.subCategoryId,
    required this.subCategoryName,
  });

  @override
  State<AdSMClientListScreen> createState() => _AdSMClientListScreenState();
}

class _AdSMClientListScreenState extends State<AdSMClientListScreen> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<AdSMClientListController>(context, listen: false).setupAds({});
  }

  var uniqueKey = UniqueKey();

  Widget adListToolsBlockForClient(AdSMClientListController controller,
      {required int total}) {
    return AdListToolsBlock(
      title: getAdListToolsBlockTitleFromSelectedServiceType(ServiceTypeEnum.MACHINARY),
      total: total,
      totalLabel: 'объявления',
      onFilterTap: () async {
        final data = await AppBottomSheetService().filterSideSheet(
          context,
          adServiceName: ServiceTypeEnum.MACHINARY,
          selectedCategory: controller.selectedCategory,
          rangeValuesStart: controller.rangeValues.start,
          rangeValuesEnd: controller.rangeValues.end,
          selectedSubCategory: controller.selectedSubCategory,
          onChangedCategory: (value) {
            controller.selectedCategory = value;
            setState(() {});
          },
          onChangedSubCategory: (value) {
            controller.selectedSubCategory = value;
          },
          getCategory: controller.getCategory(),
        );

        if (data.isEmpty || data.isEmpty) {
          return;
        }
        if (data.length == 1) {
          controller.setupAds({});
          setState(() {
            controller.rangeValues = const RangeValues(0, 100000);
            uniqueKey = UniqueKey();
          });
        } else {
          final priceStart = data['start'] as double?;
          final priceEnd = data['end'] as double?;
          final categoryID = data['category'] as int?;
          final subCategoryID = data['sub_category'] as int?;

          if (categoryID != null && categoryID != 0) {
            controller.setCategory(categoryID);
          }
          if (subCategoryID != null && subCategoryID != 0) {
            controller.setSubCategory(subCategoryID);
          }

          controller.setupAds(<String, dynamic>{
            'price': '$priceStart-$priceEnd',
          });
          setState(() {
            controller.rangeValues =
                RangeValues(priceStart ?? 0, priceEnd ?? 100000);

            uniqueKey = UniqueKey();
          });
        }
      },
      onSortTap: () => AppBottomSheetService.showSortModalReturnsSortType(
          context, controller.sortAlgorithm, (value) {
        controller.sortAlgorithm = value;
        uniqueKey = UniqueKey();

        controller.setupAds({
          controller.sortAlgorithm.name
                  .substring(0, controller.sortAlgorithm.name.indexOf('=')):
              controller.sortAlgorithm.name
                  .substring(controller.sortAlgorithm.name.indexOf('=') + 1),
        });
        setState(() {});
      }),
      onViewTap: () {
        controller.isBlockType = !(controller.isBlockType);
        setState(() {});
      },
      isBlockType: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdListSearchAppBar(),
      body: Consumer<AdSMClientListController>(builder: (_, controller, __) {
        if (controller.isLoading) {
          return const AppCircularProgressIndicator();
        } else if (!controller.isContentEmpty) {
          return Column(
            children: [
              adListToolsBlockForClient(controller,
                  total: Provider.of<AdSMClientListController>(context,
                          listen: true)
                      .ads
                      .length),
              const SizedBox(height: 8),
              Expanded(
                child: controller.isBlockType
                    ? AppAdListViewWidget(
                        onAdTap: (index) {
                          controller.onAdTap(context, index);
                        },
                        adList: controller.ads,
                        isContentEmpty: controller.isContentEmpty,
                      )
                    : AppAdGridViewWidget(
                        onAdTap: (index) {
                          controller.onAdTap(context, index);
                        },
                        adList: controller.ads,
                        isContentEmpty: controller.isContentEmpty),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              adListToolsBlockForClient(controller,
                  total: Provider.of<AdSMClientListController>(context,
                          listen: true)
                      .ads
                      .length),
              const Expanded(child: AppAdEmptyListWidget()),
            ],
          );
        }
      }),
    );
  }
}
