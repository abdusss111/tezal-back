import 'dart:math';

import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/features/main/location/bloc/sm_list_map_bloc.dart';
import 'package:eqshare_mobile/src/features/main/location/google_map/google_map_screen_controller.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

// class SampleMap extends StatelessWidget {
//   const SampleMap({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SmListMapBloc>(builder: (context, state) {

//       return ChangeNotifierProvider(
//           create: (context) => GoogleMapScreenController(data: data),
//           child: Container());
//     });
//   }
// }

class GoogleMapClustering extends StatefulWidget {
  const GoogleMapClustering({super.key});

  @override
  State<StatefulWidget> createState() => GoogleMapClusteringState();
}

class GoogleMapClusteringState extends State<GoogleMapClustering> {
  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    context.read<SmListMapBloc>().add(FetchData(
      serviceTypeEnum: context.read<SmListMapBloc>().state.pickedServiceType,
      forceReload: true,
    )); // Сброс фильтров при выходе из карты
  }

  final TextEditingController _searchController = TextEditingController();

  String getMainCategoryDropDownButtonName() => 'Категории';
  String getSubCategoryDropDownButtonName() => 'Подкатегории';

  Widget changeSearchAdsType() {
    return BlocBuilder<SmListMapBloc, SmListMapState>(
      builder: (context, state) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.055,
          decoration: BoxDecoration(
            color: Colors.white, // Фон контейнера
            borderRadius: BorderRadius.circular(8), // Скруглённые углы
            boxShadow: [
              BoxShadow(
                offset: Offset(-1, -1), // Смещение вверх и влево
                blurRadius: 5, // Радиус размытия
                color: Color.fromRGBO(
                    0, 0, 0, 0.04), // Чёрный цвет с 4% прозрачностью
              ),
              BoxShadow(
                offset: Offset(1, 1), // Смещение вниз и вправо
                blurRadius: 5, // Радиус размытия
                color: Color.fromRGBO(
                    0, 0, 0, 0.04), // Чёрный цвет с 4% прозрачностью
              ),
            ],
          ),
          child: Center(
            child: DropdownButton<ServiceTypeEnum>(
              isExpanded: false,
              // icon: Icon(Icons.),
              underline: const SizedBox(),
              borderRadius: BorderRadius.circular(10),
              style: Theme.of(context).textTheme.bodyMedium,
              dropdownColor: Theme.of(context).scaffoldBackgroundColor,
              value: state.pickedServiceType,
              items: [
                ServiceTypeEnum.MACHINARY,
                ServiceTypeEnum.EQUIPMENT,
                ServiceTypeEnum.CM,
                ServiceTypeEnum.SVM
              ].map<DropdownMenuItem<ServiceTypeEnum>>((value) {
                return DropdownMenuItem<ServiceTypeEnum>(
                  value: value,
                  child: Center(
                    child: Text(
                      getAdListToolsBlockTitleFromSelectedServiceType(value),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) async {
                if (value != null) {
                  context
                      .read<SmListMapBloc>()
                      .add(FetchData(serviceTypeEnum: value));
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget rowWithExtensionsAndFiltresAndTypeShowAd() {
    return BlocBuilder<SmListMapBloc, SmListMapState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 6),
                  child: changeSearchAdsType(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // mainAxisSize: MainAxisSize.max,
                  children: [
                      dropDownButton(state),
                      dropDownCategories(),
                  ],
                ),
                const SizedBox(height: 4)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget dropDownCategories() {
    return BlocBuilder<SmListMapBloc, SmListMapState>(
      builder: (context, state) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.45,
          height: MediaQuery.of(context).size.height * 0.055,
          decoration: BoxDecoration(
            color: Colors.white, // Фон контейнера
            borderRadius: BorderRadius.circular(8), // Скруглённые углы
            boxShadow: [
              BoxShadow(
                offset: Offset(-1, -1), // Смещение вверх и влево
                blurRadius: 5, // Радиус размытия
                color: Color.fromRGBO(
                    0, 0, 0, 0.04), // Чёрный цвет с 4% прозрачностью
              ),
              BoxShadow(
                offset: Offset(1, 1), // Смещение вниз и вправо
                blurRadius: 5, // Радиус размытия
                color: Color.fromRGBO(
                    0, 0, 0, 0.04), // Чёрный цвет с 4% прозрачностью
              ),
            ],
          ),
          child: DropdownButton<SubCategory>(
            isExpanded: true,
            icon: const SizedBox(),
            underline: const SizedBox(),
            borderRadius: BorderRadius.circular(10),
            style: Theme.of(context).textTheme.bodyMedium,
            dropdownColor: Theme.of(context).scaffoldBackgroundColor,
            value: state.subCategories.firstWhere(
                (subCategory) => subCategory.id == state.idPickedSubCategory),
            items: state.subCategories
                .map<DropdownMenuItem<SubCategory>>((SubCategory value) {
              return DropdownMenuItem<SubCategory>(
                value: value,
                child: Center(
                  child: Text(
                    value.id == 0
                        ? getSubCategoryDropDownButtonName()
                        : value.name!,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                final stateId =
                    context.read<SmListMapBloc>().state.idPickedMainCategory;
                final serviceTypeEnum =
                    context.read<SmListMapBloc>().state.pickedServiceType;
                context.read<SmListMapBloc>().add(FetchData(
                    serviceTypeEnum: serviceTypeEnum,
                    subCategoryId: value.id,
                    categoryId: stateId));
              }
            },
          ),
        );
      },
    );
  }

  Container dropDownButton(SmListMapState state) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      height: MediaQuery.of(context).size.height * 0.055,
      decoration: BoxDecoration(
        color: Colors.white, // Фон контейнера
        borderRadius: BorderRadius.circular(8), // Скруглённые углы
        boxShadow: [
          BoxShadow(
            offset: Offset(-1, -1), // Смещение вверх и влево
            blurRadius: 5, // Радиус размытия
            color:
                Color.fromRGBO(0, 0, 0, 0.04), // Чёрный цвет с 4% прозрачностью
          ),
          BoxShadow(
            offset: Offset(1, 1), // Смещение вниз и вправо
            blurRadius: 5, // Радиус размытия
            color:
                Color.fromRGBO(0, 0, 0, 0.04), // Чёрный цвет с 4% прозрачностью
          ),
        ],
      ),
      child: DropdownButton<Category>(
        underline: const SizedBox(),
        borderRadius: BorderRadius.circular(10),
        style: Theme.of(context).textTheme.bodyMedium,
        icon: const SizedBox(),
        isExpanded: true,
        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
        value: state.categories.firstWhere(
            (category) => category.id == state.idPickedMainCategory),
        items:
            state.categories.map<DropdownMenuItem<Category>>((Category value) {
          return DropdownMenuItem<Category>(
            value: value,
            child: Center(
              child: Text(
                value.id == 0
                    ? getMainCategoryDropDownButtonName()
                    : value.name!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }).toList(),
        onChanged: (value) async {
          if (value != null) {
            context.read<SmListMapBloc>().add(FetchData(
                serviceTypeEnum: state.pickedServiceType,
                categoryId: value.id));
            // context.read<SmListMapBloc>().add(
            // UseMainCategoryFilterForShowAds(mainCategoryId: value.id!));
          }
        },
      ),
    );
  }

  Align myGeoLocationFABButton() {
    return Align(
      alignment: Alignment(1.0, 0.43),
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, bottom: 8),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.12,
          height: MediaQuery.of(context).size.width * 0.12,
          child: FloatingActionButton(
            heroTag: 'SmList3',
            mini: true,
            onPressed: () {
              Provider.of<GoogleMapScreenController>(context, listen: false)
                  .moveMyGeo();
            },
            child: Transform.rotate(
              angle: 45 * pi / 180,
              child: const Icon(
                Icons.navigation_sharp,
                size: 25,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<GoogleMapScreenController>(
        builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Выберите спецтехнику'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // 👇 Очистка поиска
              _searchController.clear();
              FocusScope.of(context).unfocus();

              // 👇 Сброс фильтров и поиск
              context.read<SmListMapBloc>().add(FetchData(
                serviceTypeEnum: context.read<SmListMapBloc>().state.pickedServiceType,
                forceReload: true,
              ));

              // 👇 Переход назад
              Navigator.of(context).pop();
            },
          ),
        ),

        body: SafeArea(
          child: Consumer<GoogleMapScreenController>(
              builder: (context, value, child) {
            final height = MediaQuery.of(context).size.height * 0.8;
            // final heightForRow = MediaQuery.of(context).size.height * 0.15;

            if (value.isLoading) {
              return AppCircularProgressIndicator();
            }

            return BlocListener<SmListMapBloc, SmListMapState>(
                listener: (context, state) {
              // final progress = ProgressHUD.of(
              //     router.configuration.navigatorKey.currentContext!);
              // progress?.show();
              if (state is SMADMapListState) {
                value.updateMarkersTypeInCluster(
                    serviceTypeEnum: ServiceTypeEnum.MACHINARY,
                    data: state.adSpecializedMachinery);

                return;
              } else if (state is EQADMapListState) {
                value.updateMarkersTypeInCluster(
                    serviceTypeEnum: ServiceTypeEnum.EQUIPMENT,
                    data: state.equipments);

                return;
              } else if (state is CMADMapListState) {
                value.updateMarkersTypeInCluster(
                    serviceTypeEnum: ServiceTypeEnum.CM,
                    data: state.adContructions);

                return;
              } else if (state is SVMADMapListState) {
                value.updateMarkersTypeInCluster(
                    serviceTypeEnum: ServiceTypeEnum.SVM,
                    data: state.adServices);

                return;
              }
            }, child: BlocBuilder<SmListMapBloc, SmListMapState>(
                    builder: (context, state) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: (searchQuery) {
                        context
                            .read<SmListMapBloc>()
                            .add(FetchDataWithSearch(searchQuery: searchQuery));
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(
                            255, 238, 238, 238), // Background color
                        hintText: 'Поиск по названию',
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(
                              255, 131, 131, 135), // Hint text color
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              12), // Border radius for enabled state
                          borderSide: BorderSide.none, // No border
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              12), // Border radius for focused state
                          borderSide: BorderSide.none, // No border
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              12), // Default border radius
                          borderSide: BorderSide.none, // No border
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color:
                              Color.fromARGB(255, 131, 131, 135), // Icon color
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          color: Color.fromARGB(255, 131, 131, 135),
                          onPressed: () {
                            _searchController.clear(); // Очистка текстового поля
                            FocusScope.of(context).unfocus(); // Скрытие клавиатуры
                            context.read<SmListMapBloc>().add(FetchData(
                              serviceTypeEnum: state.pickedServiceType,
                              forceReload: true,
                            )); // Перезагрузка данных
                          },
                        ),
                      ),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), // Text color
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: height,
                          child: GoogleMap(
                            myLocationButtonEnabled: true,
                            myLocationEnabled: true,
                            onMapCreated: value.onMapCreated,
                            initialCameraPosition: CameraPosition(
                                target: value.currentLocation ??
                                    value.currentAlmatyLocation,
                                zoom: 12),
                            markers: value.markers,
                            clusterManagers: {value.clusterManagers!},
                          ),
                        ),
                        myGeoLocationFABButton(),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: rowWithExtensionsAndFiltresAndTypeShowAd())
                      ],
                    ),
                  ),
                ],
              );
            }));
          }),
        ),
      );
    });
  }
}
