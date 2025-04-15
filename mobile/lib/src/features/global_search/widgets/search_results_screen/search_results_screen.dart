import 'package:cached_network_image/cached_network_image.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_image_rectangle_network_widget.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/get_core_widgets.dart';
import 'package:eqshare_mobile/src/core/res/app_images.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/app_ad_iamge_place_holder_with_icon.dart';
import 'package:eqshare_mobile/src/features/global_search/widgets/global_search_field_widget.dart';
import 'package:eqshare_mobile/src/features/global_search/widgets/search_results_screen/filter_modal.dart';
import 'package:eqshare_mobile/src/features/global_search/widgets/search_results_screen/search_results_screen_controller.dart';
import 'package:eqshare_mobile/src/features/main/navigation/navigation_controller.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class SortModalService {
  static void showSortModal(
      BuildContext context,
      SortAlgorithmEnum currentSort,
      Function(SortAlgorithmEnum) onChanged,
      ) {
    showBarModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Выберите тип сортировки',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 16.0),
              _SortOption(
                title: 'По возрастанию цены',
                sortType: SortAlgorithmEnum.ascPrice,
                selectedSort: currentSort,
                onChanged: onChanged,
              ),
              _SortOption(
                title: 'По убыванию цены',
                sortType: SortAlgorithmEnum.descPrice,
                selectedSort: currentSort,
                onChanged: onChanged,
              ),
              _SortOption(
                title: 'По дате (новые сначала)',
                sortType: SortAlgorithmEnum.descCreatedAt,
                selectedSort: currentSort,
                onChanged: onChanged,
              ),
              _SortOption(
                title: 'По дате (старые сначала)',
                sortType: SortAlgorithmEnum.ascCreatedAt,
                selectedSort: currentSort,
                onChanged: onChanged,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SortOption extends StatelessWidget {
  final String title;
  final SortAlgorithmEnum sortType;
  final SortAlgorithmEnum selectedSort;
  final Function(SortAlgorithmEnum) onChanged;

  const _SortOption({
    required this.title,
    required this.sortType,
    required this.selectedSort,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<SortAlgorithmEnum>(
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      value: sortType,
      groupValue: selectedSort,
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
          Navigator.pop(context);
        }
      },
    );
  }
}


void showFiltersModal(BuildContext context,
    Function(Map<String, String>) onApply, Map<String, String> activeFilters) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.85,
        child: FilterModal(onApply: onApply, activeFilters: activeFilters),
      );
    },
  );
}

class SearchResultsScreenForTabs extends StatelessWidget {
  const SearchResultsScreenForTabs({super.key});
  AppBar appBar() {
    return AppBar(
      leading: BackButton(),
      title: Consumer<SearchResultsScreenController>(
          builder: (context, value, child) {
            return GlobalSearchFieldWidget(
              searchText: value.searchText,
            );
          }),
      actions: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchResultsScreenController>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return Scaffold(
              appBar: appBar(),
              body: AppCircularProgressIndicator(),
            );
          } else {
            return ChangeNotifierProvider.value(
              value: Provider.of<SearchResultsScreenController>(context),
              child: SearchResultsScreen(
                  tabBarCount: value.uniqueServiceTypes.length,
                  currentTabIndex: value.currentScreenIndex),
            );
          }
        });
  }
}

class SearchResultsScreen extends StatefulWidget {
  final int tabBarCount;
  final int? currentTabIndex;
  const SearchResultsScreen(
      {super.key, required this.tabBarCount, this.currentTabIndex});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool isGridView = true;
  List<AdListRowData> filteredData = [];
  late ScrollController _scrollController;

  Widget tab(String text) {
    return Tab(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: widget.currentTabIndex ?? 0,
      length: widget.tabBarCount,
      vsync: this,
    );
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    _tabController!.addListener(() {
      if (_tabController!.indexIsChanging) {
        final controller =
        Provider.of<SearchResultsScreenController>(context, listen: false);
        final selectedType =
        controller.uniqueServiceTypes.elementAt(_tabController!.index);
        _filterDataByType(controller, selectedType);
      }
    });

    final controller =
    Provider.of<SearchResultsScreenController>(context, listen: false);
    if (controller.uniqueServiceTypes.isNotEmpty) {
      final initialType =
      controller.uniqueServiceTypes.elementAt(widget.currentTabIndex ?? 0);
      _filterDataByType(controller, initialType);
    }
  }

  void _onScroll() async {
    final controller = Provider.of<SearchResultsScreenController>(context, listen: false);

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300 &&
        controller.hasMore &&
        !controller.isLoadingPaginator) {
      await controller.loadMoreData();
      final selectedType = controller.uniqueServiceTypes.elementAt(_tabController!.index);
      _filterDataByType(controller, selectedType);
    }
  }




  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = Provider.of<SearchResultsScreenController>(context, listen: true);
    final selectedType = controller.uniqueServiceTypes.elementAt(_tabController!.index);
    _filterDataByType(controller, selectedType);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String getPrice(double? price) {
    final valueInInt = (price ?? 0).toInt();
    if (valueInInt == 2000 || valueInInt == 0) {
      return 'Договорная';
    } else {
      return '${valueInInt.toString()} тг/час';
    }
  }

  AppBar appBar() {
    return AppBar(
      leading: BackButton(
        onPressed: () {
          final index =
              Provider.of<NavigationScreenController>(context, listen: false)
                  .currentPageIndex;
          context.go('/${AppRouteNames.navigation}', extra: {'id': index});
        },
      ),
      title: Consumer<SearchResultsScreenController>(
          builder: (context, value, child) {
            return GlobalSearchFieldWidget(
              searchText: value.searchText,
            );
          }),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(isGridView ? Icons.list : Icons.grid_on),
                onPressed: () {
                  setState(() {
                    isGridView = !isGridView;
                  });
                },
              )
            ],
          ),
        )
      ],
    );
  }

  // Widget filtersForPriceAndDate() {
  //   return Consumer<SearchResultsScreenController>(
  //     builder: (context, controller, child) {
  //       final sortsType = controller.sortsType.toSet().toList();
  //       final categoryValue = sortsType.firstWhere(
  //             (e) => e.name == controller.selectedSortAlgorithmEnum.name,
  //         orElse: () => sortsType.first,
  //       );
  //
  //       return Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 16),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text('Результаты', style: Theme.of(context).textTheme.displaySmall),
  //             Container(
  //               decoration: BoxDecoration(
  //                 border: Border.all(color: Colors.grey),
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: DropdownButton<SortAlgorithmEnum>(
  //                 focusNode: FocusNode(),
  //                 underline: SizedBox(),
  //                 icon: Icon(Icons.sort, color: Colors.black),
  //                 value: controller.selectedSortAlgorithmEnum,
  //                 items: sortsType.map((e) => DropdownMenuItem<SortAlgorithmEnum>(
  //                   value: e,
  //                   child: Text(getNameOfSortAlgorithmEnum(e)),
  //                 )).toList(),
  //                 onChanged: (newValue) async {
  //                   if (newValue != null) {
  //                     await controller.setSelectedSortAlgorithmEnum(newValue);
  //                     _filterDataByType(controller, controller.uniqueServiceTypes.elementAt(_tabController!.index));
  //                   }
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget resultCard(AdListRowData adListRowData,
      {bool isPicked = false, Color? color}) {
    return GestureDetector(
        onTap: () {
          if (adListRowData.id != null &&
              adListRowData.allServiceTypeEnum != null) {
            final controller = Provider.of<SearchResultsScreenController>(
                context,
                listen: false);
            controller.setSelecteAD(adListRowData.id!);
            controller.pushToPage(
                context, adListRowData.id!, adListRowData.allServiceTypeEnum!);
          }
        },
        child: Padding(
          padding: EdgeInsets.only(left: 16, top: 8, right: 16),
          child: Container(
            decoration: BoxDecoration(
              color: isPicked ? color : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  offset: Offset(-1, -1),
                  blurRadius: 5,
                  color: Color.fromRGBO(0, 0, 0, 0.04),
                ),
                BoxShadow(
                  offset: Offset(1, 1),
                  blurRadius: 5,
                  color: Color.fromRGBO(0, 0, 0, 0.04),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: AppImageRectangleNetworkWidget(
                        width: 120,
                        height: 120,
                        imageUrl: adListRowData.imageUrl,
                        imagePlaceholder: AppImages.imagePlaceholderWithIcon),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(adListRowData.title ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium),
                        SizedBox(height: 5),
                        Text("Категория: ${adListRowData.category ?? ''}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(height: 5),
                        Text(getPrice(adListRowData.price),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                color: Colors.black54,
                                fontWeight: FontWeight.w600)),
                        SizedBox(height: 5),
                        Text(
                            '${adListRowData.city ?? ''}, ${adListRowData.createdAt != null ? DateTimeUtils.fromStringFormatDateYYMMDD(adListRowData.createdAt!.substring(0, 11)) : ''}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.grey)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget resultCardGrid(AdListRowData adListRowData,
      {bool isPicked = false, Color? color}) {
    final images = adListRowData.imageUrls ?? [];

    return GestureDetector(
      onTap: () {
        if (adListRowData.id != null &&
            adListRowData.allServiceTypeEnum != null) {
          final controller = Provider.of<SearchResultsScreenController>(context,
              listen: false);
          controller.setSelecteAD(adListRowData.id!);
          controller.pushToPage(
              context, adListRowData.id!, adListRowData.allServiceTypeEnum!);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(left: 0, top: 8, right: 0),
        child: Container(
          decoration: BoxDecoration(
            color: isPicked ? color : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                offset: Offset(-1, -1),
                blurRadius: 5,
                color: Color.fromRGBO(0, 0, 0, 0.04),
              ),
              BoxShadow(
                offset: Offset(1, 1),
                blurRadius: 5,
                color: Color.fromRGBO(0, 0, 0, 0.04),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final height = width * 0.65;
                    return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child:
                        images.isEmpty ? AppAdIamgePlaceHolderWithIcon(height: height):
                        CachedNetworkImage(
                            imageUrl: images[0],
                            fit: BoxFit.cover,
                            progressIndicatorBuilder: (context, url, progress) =>
                                SizedBox(
                                  height: height,
                                  child: AppCircularProgressIndicator(),
                                ),
                            imageBuilder: (context, imageProvider) => Container(
                              height: height,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: height,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(AppImages.imagePlaceholderWithIcon),
                                ),
                              ),
                            )
                        ));}),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 12.0, top: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      adListRowData.title ?? '',
                      style: Theme.of(context).textTheme.headlineSmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      getPrice(adListRowData.price),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.black54, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${(adListRowData.city ?? '').isEmpty ? 'Не указан' : '${adListRowData.city},'} ${adListRowData.createdAt != null ? DateTimeUtils.fromStringFormatDateYYMMDD(adListRowData.createdAt!.substring(0, 11)) : ''}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          RatingWithStarWidget(
                            rating: adListRowData.rating,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      controller: _scrollController, // ← обязательно!
      padding: const EdgeInsets.fromLTRB(16,0,16,16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: filteredData.length + 1,
      itemBuilder: (context, index) {
        if (index < filteredData.length) {
          return resultCardGrid(filteredData[index]);
        } else {
          return Consumer<SearchResultsScreenController>(
            builder: (context, controller, _) {
              return controller.isLoadingPaginator
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              )
                  : SizedBox.shrink();
            },
          );
        }
      },
    );
  }


  Widget _buildListView() {
    return ListView.builder(
      controller: _scrollController, // ← ВАЖНО!
      itemCount: filteredData.length + 1, // ← +1 для индикатора внизу
      itemBuilder: (context, index) {
        if (index < filteredData.length) {
          return resultCard(filteredData[index]);
        } else {
          return Consumer<SearchResultsScreenController>(
            builder: (context, controller, _) {
              return controller.isLoadingPaginator
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: CircularProgressIndicator(),
                ),
              )
                  : SizedBox.shrink();
            },
          );
        }
      },
    );
  }


  void _filterDataByType(
      SearchResultsScreenController controller, AllServiceTypeEnum type) {
    setState(() {
      filteredData = controller.showData
          .where((e) => e.allServiceTypeEnum == type)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchResultsScreenController>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: appBar(),
          body: Column(
            children: [
              // filtersForPriceAndDate(),
              Container(
                height: 16,
                color: Colors.white,
              ),
              Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: TabBar(
                    dividerColor: Colors.grey,
                    controller: _tabController,
                    tabs: value.uniqueServiceTypes.map((type) {
                      switch (type) {
                        case AllServiceTypeEnum.MACHINARY:
                          return tab('Спецтехника');
                        case AllServiceTypeEnum.EQUIPMENT:
                          return tab('Оборудование');
                        case AllServiceTypeEnum.CM:
                          return tab('Строй материалы');
                        case AllServiceTypeEnum.SVM:
                          return tab('Услуги');
                        default:
                          return tab('Другие');
                      }
                    }).toList(),
                  )),
              const SizedBox(
                height: 16,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Consumer<SearchResultsScreenController>(
                    builder: (context, controller, child) {
                      final bool isCitySelected =
                          controller.selectedCity != null;

                      return IntrinsicWidth(
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                            isCitySelected ? Colors.orange : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(-1, -1),
                                blurRadius: 5,
                                color: Color.fromRGBO(0, 0, 0, 0.04),
                              ),
                              BoxShadow(
                                offset: Offset(1, 1),
                                blurRadius: 5,
                                color: Color.fromRGBO(0, 0, 0, 0.04),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  controller.showCityModal(context);
                                },
                                icon: const Icon(
                                  Icons.location_city,
                                  size: 18,
                                ),
                                label: Text(
                                  controller.selectedCity != null
                                      ? controller.selectedCity!.name
                                      : 'Город',
                                  style: TextStyle(
                                    color: isCitySelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  foregroundColor: isCitySelected
                                      ? Colors.white
                                      : Colors.black,
                                  splashFactory: NoSplash
                                      .splashFactory,
                                ),
                              ),
                              if (isCitySelected)
                                IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                  onPressed: () {
                                    controller.clearCity();
                                  },
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Consumer<SearchResultsScreenController>(
                  builder: (context, controller, child) {
                    return GestureDetector(
                      onTap: () {
                        SortModalService.showSortModal(
                          context,
                          controller.selectedSortAlgorithmEnum,
                              (newSort) async {
                            await controller.setSelectedSortAlgorithmEnum(newSort);
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          controller.selectedSortAlgorithmEnum == SortAlgorithmEnum.ascPrice ||
                              controller.selectedSortAlgorithmEnum == SortAlgorithmEnum.ascCreatedAt
                              ? CupertinoIcons.sort_up
                              : CupertinoIcons.sort_down,
                          size: 24.0,
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                ),


                Container(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Consumer<SearchResultsScreenController>(
                      builder: (context, controller, child) {
                        final bool hasFilters =
                            controller.activeFilters.isNotEmpty;

                        return IntrinsicWidth(
                            child: Container(
                                decoration: BoxDecoration(
                                    color: hasFilters
                                        ? Colors.orange
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(
                                            -1, -1),
                                        blurRadius: 5,
                                        color: Color.fromRGBO(0, 0, 0,
                                            0.04),
                                      ),
                                      BoxShadow(
                                        offset: Offset(
                                            1, 1),
                                        blurRadius: 5,
                                        color: Color.fromRGBO(0, 0, 0,
                                            0.04),
                                      ),
                                    ]),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        showFiltersModal(context,
                                                (Map<String, String>
                                            filters) async {
                                              await controller.applyFilters(
                                                  filters);
                                            }, controller.activeFilters);
                                      },
                                      icon: Icon(
                                        Icons.filter_list,
                                        color: hasFilters
                                            ? Colors.white
                                            : Colors.black,
                                        size: 18,
                                      ),
                                      label: Text(
                                        'Фильтры',
                                        style: TextStyle(
                                          color: hasFilters
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        foregroundColor: hasFilters
                                            ? Colors.white
                                            : Colors.black,
                                        splashFactory: NoSplash
                                            .splashFactory,
                                      ),
                                    ),
                                    if (hasFilters)
                                      IconButton(
                                        icon: const Icon(Icons.clear,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255)),
                                        onPressed: () {
                                          controller
                                              .clearFilters();
                                        },
                                      ),
                                  ],
                                )));
                      },
                    ))
              ]),
              Expanded(
                  child: isGridView
                      ? _buildGridView()
                      : _buildListView()
              ),
            ],
          ),
        );
      },
    );
  }
}
