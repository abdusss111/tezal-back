import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_bottom_sheet_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_location_f_a_b.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/empty_list_widgets/app_empty_list_widget.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/features/ad/data/global_fuctions.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_client_model.dart/ad_construction_client_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_model/ad_constrution_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_construction_materials_repository.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_list_search_app_bar.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_list_tools_block.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/app_ad_grid_view_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/app_ad_list_view_widget.dart';
import 'package:eqshare_mobile/src/global_widgets/global_future_builder_with_payload.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';

class AdConstructionScreen extends StatefulWidget {
  const AdConstructionScreen({super.key});

  @override
  State<AdConstructionScreen> createState() => _AdConstructionScreenState();
}

class _AdConstructionScreenState extends State<AdConstructionScreen> {
  var uniqueKey = UniqueKey();
  final adConstructionMaterialsRepository = AdConstructionMaterialsRepository();

  Future<List<AdConstrutionModel>?>? getFutureForClient;

  Future<List<AdConstructionClientModel>?>? getFutureForDriverOrOwner;

  SortAlgorithmEnum sortType = SortAlgorithmEnum.ascCreatedAt;

  bool isBlockType = true;

  @override
  void initState() {
    getFutureForClient = adConstructionMaterialsRepository
        .getAdConstructionMaterialListForClient();
    getFutureForDriverOrOwner = adConstructionMaterialsRepository
        .getAdConstructionMaterialListForDriverOrOwner(
            queryParametersFromPage: {
          "status": RequestStatus.CREATED.name,
        });
    super.initState();
  }

  var values = const RangeValues(0, 100000);
  Category? selectedCategory;
  SubCategory? selectedSubCategory;

  Widget adListToolsBlockForClient({required int total}) {
    return AdListToolsBlock(
      title: 'Строй материалы',
      total: total,
      totalLabel: 'материалов',
      onFilterTap: () async {
        final data = await AppBottomSheetService().filterSideSheet(
          context,
          adServiceName: ServiceTypeEnum.CM,
          selectedCategory: selectedCategory,
          rangeValuesStart: values.start,
          rangeValuesEnd: values.end,
          selectedSubCategory: selectedSubCategory,
          onChangedCategory: (value) {
            selectedCategory = value;
            setState(() {});
          },
          onChangedSubCategory: (value) {
            selectedSubCategory = value;
          },
          getCategory:
              adConstructionMaterialsRepository.getAdConstrutionListCategory(),
        );

        if (data.isEmpty) {
          return;
        }
        if (data.length == 1) {
          getFutureForClient = adConstructionMaterialsRepository
              .getAdConstructionMaterialListForClient();
          setState(() {
            values = const RangeValues(0, 100000);
            uniqueKey = UniqueKey();
          });
        } else {
          final priceStart = data['start'] as double;
          final priceEnd = data['end'] as double;
          final categoryID = data['category'] as int?;
          final subCategoryID = data['sub_category'] as int?;

          getFutureForClient = adConstructionMaterialsRepository
              .getAdConstructionMaterialListForClient(queryParametersFromPage: {
            'price': '$priceStart-$priceEnd',
            if (subCategoryID != null && subCategoryID != 0)
              'construction_material_subcategory_id': subCategoryID,
            if (categoryID != null && categoryID != 0)
              'construction_material_category_id': categoryID
          });
          setState(() {
            values = RangeValues(priceStart, priceEnd);

            uniqueKey = UniqueKey();
          });
        }
      },
      onSortTap: () => AppBottomSheetService.showSortModalReturnsSortType(
          context, sortType, (value) {
        setState(() {
          sortType = value;
          uniqueKey = UniqueKey();
        });
      }),
      onViewTap: () {
        isBlockType = !isBlockType;
        setState(() {});
      },
      isBlockType: isBlockType,
    );
  }

  Widget adListToolsBlockForDriver({required int total}) {
    return AdListToolsBlock(
      title:
          getAdListToolsBlockTitleFromSelectedServiceType(ServiceTypeEnum.CM),
      total: total,
      totalLabel: 'материалов',
      onFilterTap: () async {
        final data = await AppBottomSheetService().filterSideSheet(
          context,
          adServiceName: ServiceTypeEnum.CM,
          selectedCategory: selectedCategory,
          rangeValuesStart: values.start,
          rangeValuesEnd: values.end,
          selectedSubCategory: selectedSubCategory,
          onChangedCategory: (value) {
            selectedCategory = value;
            setState(() {});
          },
          onChangedSubCategory: (value) {
            selectedSubCategory = value;
          },
          getCategory:
              adConstructionMaterialsRepository.getAdConstrutionListCategory(),
        );

        if (data.isEmpty || data.isEmpty) {
          return;
        }
        if (data.length == 1) {
          getFutureForDriverOrOwner = adConstructionMaterialsRepository
              .getAdConstructionMaterialListForDriverOrOwner();
          setState(() {
            values = const RangeValues(0, 100000);
            uniqueKey = UniqueKey();
          });
        } else {
          final priceStart = data['start'] as double;
          final priceEnd = data['end'] as double;
          final categoryID = data['category'] as int?;
          final subCategoryID = data['sub_category'] as int?;

          getFutureForDriverOrOwner = adConstructionMaterialsRepository
              .getAdConstructionMaterialListForDriverOrOwner(
                  queryParametersFromPage: {
                'price': '$priceStart-$priceEnd',
                if (subCategoryID != null && subCategoryID != 0)
                  'construction_material_subcategory_id':
                      subCategoryID.toString(),
                if (categoryID != null && categoryID != 0)
                  'construction_material_category_id': categoryID.toString()
              });
          setState(() {
            values = RangeValues(priceStart, priceEnd);

            uniqueKey = UniqueKey();
          });
        }
      },
      onSortTap: () => AppBottomSheetService.showSortModalReturnsSortType(
          context, sortType, (value) {
        setState(() {
          sortType = value;
          uniqueKey = UniqueKey();
        });
      }),
      onViewTap: () {
        isBlockType = !isBlockType;
        setState(() {});
      },
      isBlockType: isBlockType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        floatingActionButton: const AppLocationFAB(),
        appBar: const AdListSearchAppBar(),
        body: GlobalFutureBuilderWithPayload(
            key: uniqueKey,
            futureForClient: getFutureForClient!,
            futureForDriverOrOwner: getFutureForDriverOrOwner!,
            buildWidgetForClient: (data, payload) {
              if (data == null || data.isEmpty) {
                return Column(
                  children: [
                    adListToolsBlockForClient(total: 0),
                    const Expanded(child: AppAdEmptyListWidget())
                  ],
                );
              }
              final List<AdListRowData> result = data
                  .map((value) =>
                      AdConstrutionModel.getAdListRowDataFromSM(value))
                  .toList();

              final adListRowData = getSortData(result, sortType: sortType);
              return Column(
                children: [
                  adListToolsBlockForClient(total: adListRowData.length),
                  Expanded(
                      child: isBlockType
                          ? AppAdGridViewWidget(
                              onAdTap: (index) {
                                context.pushNamed(
                                    AppRouteNames.adConstructionDetail,
                                    extra: {
                                      'id': adListRowData[index].id.toString()
                                    });
                              },
                              adList: adListRowData,
                              isContentEmpty: adListRowData.isEmpty)
                          : AppAdListViewWidget(
                              onAdTap: (index) {
                                context.pushNamed(
                                    AppRouteNames.adConstructionDetail,
                                    extra: {
                                      'id': adListRowData[index].id.toString()
                                    });
                              },
                              adList: adListRowData,
                              isContentEmpty: adListRowData.isEmpty)),
                ],
              );
            },
            buildWidgetForDriverOrOwner: (data, payload) {
              if (data == null || data.isEmpty) {
                return Column(
                  children: [
                    adListToolsBlockForDriver(total: 0),
                    const Expanded(child: AppAdEmptyListWidget())
                  ],
                );
              }
              final List<AdListRowData> result = data
                  .map((value) =>
                      AdConstructionClientModel.getAdListRowDataFromSM(value))
                  .toList();

              final adListRowData = getSortData(result, sortType: sortType);
              return Column(
                children: [
                  adListToolsBlockForDriver(total: adListRowData.length),
                  Expanded(
                    child: isBlockType
                        ? AppAdGridViewWidget(
                            onAdTap: (index) {
                              context.pushNamed(
                                  AppRouteNames.adConstructionDetail,
                                  extra: {
                                    'id': adListRowData[index].id.toString()
                                  });
                            },
                            adList: adListRowData,
                            isContentEmpty: adListRowData.isEmpty)
                        : AppAdListViewWidget(
                            onAdTap: (index) {
                              context.pushNamed(
                                  AppRouteNames.adConstructionDetail,
                                  extra: {
                                    'id': adListRowData[index].id.toString()
                                  });
                            },
                            adList: adListRowData,
                            isContentEmpty: adListRowData.isEmpty),
                  ),
                ],
              );
            }),
      )
    ]);
  }
}
