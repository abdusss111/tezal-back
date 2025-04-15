import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_bottom_sheet_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_location_f_a_b.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/empty_list_widgets/app_empty_list_widget.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/features/ad/data/global_fuctions.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_client_model/ad_service_client_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_model/ad_service_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_service_repository.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_list_search_app_bar.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_list_tools_block.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/app_ad_grid_view_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/app_ad_list_view_widget.dart';
import 'package:eqshare_mobile/src/global_widgets/global_future_builder_with_payload.dart';
import 'package:flutter/material.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import 'package:go_router/go_router.dart';

class AdServiceMainScreen extends StatefulWidget {
  const AdServiceMainScreen({super.key});

  @override
  State<AdServiceMainScreen> createState() => _AdServiceMainScreen();
}

class _AdServiceMainScreen extends State<AdServiceMainScreen> {
  final adServiceRepo = AdServiceRepository();

  List<AdServiceModel> listAdServices = [];

  Future<List<AdServiceModel>?>? futureForClient;
  Future<List<AdServiceClientModel>?>? getFaviruteForDriver;

  SortAlgorithmEnum sortType = SortAlgorithmEnum.ascPrice;
  var uniqueKey = UniqueKey();

  Category? selectedCategory;
  SubCategory? selectedSubCategory;
  bool isBlockType = false;
  RangeValues values = const RangeValues(0, 100000);

  @override
  void initState() {
    futureForClient = adServiceRepo.getAdServiceListForClient();
    getFaviruteForDriver = adServiceRepo.getAdServiceListForDriverOrOwner(
        qmap: {"status": RequestStatus.CREATED.name});
    super.initState();
  }

  Widget adListToolsBlockForClient({required int total}) {
    return AdListToolsBlock(
      title: 'Услуги',
      total: total,
      totalLabel: 'объявлений',
      onFilterTap: () async {
        final data = await AppBottomSheetService().filterSideSheet(
          context,
          adServiceName: ServiceTypeEnum.SVM,
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
          getCategory: adServiceRepo.getAdServiceListCategory(),
        );

        if (data.isEmpty) {
          return;
        }
        if (data.length == 1) {
          futureForClient = adServiceRepo.getAdServiceListForClient();

          setState(() {
            selectedCategory = null;
            selectedSubCategory = null;
            values = const RangeValues(0, 100000);
            uniqueKey = UniqueKey();
          });
        } else {
          final priceStart = data['start'] as double;
          final priceEnd = data['end'] as double;
          final categoryID = data['category'] as int?;
          final subCategoryID = data['sub_category'] as int?;

          futureForClient =
              adServiceRepo.getAdServiceListForClient(queryParametersFromPage: {
            'price': '$priceStart-$priceEnd',
            if (subCategoryID != null && subCategoryID != 0)
              'service_subcategory_id': subCategoryID,
            if (categoryID != null && categoryID != 0)
              'service_category_id': categoryID,
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
      isBlockType: false,
    );
  }

  Widget adListToolsBlockForDriver({required int total}) {
    return AdListToolsBlock(
      title:
          getAdListToolsBlockTitleFromSelectedServiceType(ServiceTypeEnum.SVM),
      total: total,
      totalLabel: 'услуг',
      onFilterTap: () async {
        final data = await AppBottomSheetService().filterSideSheet(
          context,
          adServiceName: ServiceTypeEnum.SVM,
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
          getCategory: adServiceRepo.getAdServiceListCategory(),
        );

        if (data.isEmpty || data.isEmpty) {
          return;
        }
        if (data.length == 1) {
          getFaviruteForDriver =
              adServiceRepo.getAdServiceListForDriverOrOwner();
          setState(() {
            values = const RangeValues(0, 100000);
            uniqueKey = UniqueKey();
          });
        } else {
          final priceStart = data['start'] as double;
          final priceEnd = data['end'] as double;
          final categoryID = data['category'] as int?;
          final subCategoryID = data['sub_category'] as int?;

          getFaviruteForDriver =
              adServiceRepo.getAdServiceListForDriverOrOwner(qmap: {
            'price': '$priceStart-$priceEnd',
            if (subCategoryID != null && subCategoryID != 0)
              'service_subcategory_id': subCategoryID,
            if (categoryID != null && categoryID != 0)
              'service_category_id': categoryID,
          });
          setState(() {
            uniqueKey = UniqueKey();
            values = RangeValues(priceStart, priceEnd);
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
            futureForClient: futureForClient!,
            futureForDriverOrOwner: getFaviruteForDriver!,
            buildWidgetForClient: (data, payload) {
              if (data == null || data.isEmpty) {
                return Column(
                  children: [
                    adListToolsBlockForClient(total: 0),
                    const Expanded(child: AppAdEmptyListWidget()),
                  ],
                );
              }
              List<AdListRowData> result = data
                  .map((value) => AdServiceModel.getAdListRowDataFromSM(value))
                  .toList();

              final adListRowData = getSortData(result, sortType: sortType);

              return Column(
                children: [
                  adListToolsBlockForClient(total: adListRowData.length),
                  Expanded(
                      child: !isBlockType
                          ? AppAdGridViewWidget(
                              onAdTap: (index) {
                                context.pushNamed(
                                    AppRouteNames.adServiceDetailScreen,
                                    extra: {'id': result[index].id.toString()});
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => AdServiceDetailScreen(
                                //             id: data[index].id.toString())));
                              },
                              adList: adListRowData,
                              isContentEmpty: adListRowData.isEmpty)
                          : AppAdListViewWidget(
                              onAdTap: (index) {
                                context.pushNamed(
                                    AppRouteNames.adServiceDetailScreen,
                                    extra: {'id': result[index].id.toString()});
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => AdServiceDetailScreen(
                                //             id: data[index].id.toString())));
                              },
                              adList: adListRowData,
                              isContentEmpty: adListRowData.isEmpty)),
                ],
              );
            },
            buildWidgetForDriverOrOwner: (data, payload) {
              if (data == null || data.isEmpty) {
                return Column(children: [
                  adListToolsBlockForDriver(total: 0),
                  const Expanded(child: AppAdEmptyListWidget())
                ]);
              }
              final List<AdListRowData> result = data
                  .map((value) =>
                      AdServiceClientModel.getAdListRowDataFromSM(value))
                  .toList();

              final adListRowData = getSortData(result, sortType: sortType);

              return Column(children: [
                adListToolsBlockForDriver(total: adListRowData.length),
                Expanded(
                    child: !isBlockType
                        ? AppAdGridViewWidget(
                            onAdTap: (index) {
                              context.pushNamed(
                                  AppRouteNames.adServiceDetailScreen,
                                  extra: {'id': result[index].id.toString()});
                            },
                            adList: adListRowData,
                            isContentEmpty: adListRowData.isEmpty)
                        : AppAdListViewWidget(
                            onAdTap: (index) {
                              context.pushNamed(
                                  AppRouteNames.adServiceDetailScreen,
                                  extra: {'id': result[index].id.toString()});
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => AdServiceDetailScreen(
                              //             id: data[index].id.toString())));
                            },
                            adList: adListRowData,
                            isContentEmpty: adListRowData.isEmpty))
              ]);
            }),
      )
    ]);
  }
}
