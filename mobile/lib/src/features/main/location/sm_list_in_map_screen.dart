import 'dart:async';
import 'dart:developer';

import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';

import 'package:eqshare_mobile/src/core/presentation/widgets/get_core_widgets.dart';
import 'package:eqshare_mobile/src/core/res/app_images.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_colors.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_model/ad_constrution_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_model/ad_equipment.dart';

import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_model/ad_service_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_model/ad_specialized_machinery.dart';

import 'package:eqshare_mobile/src/features/main/location/bloc/sm_list_map_bloc.dart';
import 'package:eqshare_mobile/src/features/main/location/sm_list_map_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:separated_column/separated_column.dart';

import '../../../core/presentation/routing/app_route.dart';
import '../../home/home_controller.dart';

class SmListInMapScreen extends StatelessWidget {
  const SmListInMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      SmListMapBloc(smListMapRepository: SmListMapRepository(), homeController: HomeController())
        ..add(const FetchInitialData()),
      child: const MapWithPointsWidgets(),
    );
  }
}

class MapWithPointsWidgets extends StatefulWidget {
  const MapWithPointsWidgets({super.key});

  @override
  State<MapWithPointsWidgets> createState() => _MapWithPointsWidgetState();
}

class _MapWithPointsWidgetState extends State<MapWithPointsWidgets>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late final _animatedMapController = AnimatedMapController(vsync: this);
  final location = Location();
  late final StreamController<double?> _alignPositionStreamController;

  bool? serviceEnabled;
  PermissionStatus? permissionGranted;

  @override
  void initState() {
    super.initState();

    _getCurrentLocation();

    _alignPositionStreamController = StreamController<double?>();
  }

  String getMainCategoryDropDownButtonName() => 'Категории';
  String getSubCategoryDropDownButtonName() => 'Подкатегории';

  String getShowTextForSwitchButton(bool showAdSpecializedMachinery) {
    return showAdSpecializedMachinery ? 'Оборудование' : 'Объявление';
  }

  String cutLongTitle(String cutString, {int endOfCutForString = 14}) {
    if (cutString.length > 15) {
      return '${cutString.substring(0, endOfCutForString)}...';
    }
    return cutString;
  }

  Future<void> _checkPermissions() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled!) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled!) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    await _checkPermissions();
    try {
      final LocationData locationData = await location.getLocation();
      _animatedMapController.mapController
          .move(LatLng(locationData.latitude!, locationData.longitude!), 15);
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  void _onMarkerTap(
      {required String name,
        required String id,
        required String address,
        required List<String>? urlFoto,
        required ServiceTypeEnum serviceTypeEnum}) {
    selectedModelBottomSheet(
        serviceTypeEnum: serviceTypeEnum,
        title: name,
        address: address,
        id: id.toString(),
        image: urlFoto);
  }

  Future<dynamic> selectedModelBottomSheet(
      {String? title,
        String? address,
        List<String>? image,
        required ServiceTypeEnum serviceTypeEnum,
        required String id}) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Выбранная точка',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                minVerticalPadding: 0,
                // minLeadingWidth: 150,
                leading: SizedBox(
                  width: 120,
                  height: 200,
                  child: AppImageNetworkWidget(
                    imageUrl:
                    image != null && image.isNotEmpty ? image.first : '',
                    imagePlaceholder: AppImages.imagePlaceholder,
                    boxFit:
                    image != null && image.isNotEmpty ? BoxFit.cover : null,
                    width: 120,
                    height: 200,
                  ),
                ),
                title: Text(title ?? ''),
                subtitle: Text(address ?? ''),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (serviceTypeEnum == ServiceTypeEnum.MACHINARY) {
                    await context.pushNamed(
                      AppRouteNames.adSMDetail,
                      extra: {'id': id.toString()},
                    );
                  } else if (serviceTypeEnum == ServiceTypeEnum.EQUIPMENT) {
                    await context.pushNamed(AppRouteNames.adEquipmentDetail,
                        extra: {"id": id.toString()});
                  } else if (serviceTypeEnum == ServiceTypeEnum.CM) {
                    context.pushNamed(AppRouteNames.adConstructionDetail,
                        extra: {'id': id.toString()});
                  } else if (serviceTypeEnum == ServiceTypeEnum.SVM) {
                    context.pushNamed(AppRouteNames.adServiceDetailScreen,
                        extra: {'id': id.toString()});
                  }

                  // if (showAdSpecializedMachinery) {

                  // } else {
                  //   await context.pushNamed(AppRouteNames.adEquipmentDetail,
                  //       extra: {"id": id.toString()});
                  // }
                },
                child: const Text('Посмотреть объявление'),
              ),
            ],
          ),
        );
      },
    );
  }

  Align myGeoLocationFABButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, bottom: 8),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.1125,
          height: MediaQuery.of(context).size.width * 0.1125,
          child: FloatingActionButton(
            heroTag: 'SmList3',
            mini: true,
            onPressed: () {
              _alignPositionStreamController.add(14);
            },
            child: Transform.rotate(
              angle: 45 * pi / 180,
              child: const Icon(
                Icons.navigation_sharp,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getAdListToolsBlockTitleFromSelectedServiceType(
      ServiceTypeEnum? serviceTypeEnum) {
    switch (serviceTypeEnum) {
      case ServiceTypeEnum.CM:
        return 'Заказы стр материалов';
      case ServiceTypeEnum.MACHINARY:
        return 'Заказы спецтехник';
      case ServiceTypeEnum.EQUIPMENT:
        return 'Заказы оборудования';
      case ServiceTypeEnum.SVM:
        return 'Заказы услуг';
    // case ServiceTypeEnum.MACHINARY_RUS : return 'Заказы спецтехник';
    // case ServiceTypeEnum.EQUIPMENT_RUS : return 'Заказы оборудования';
      default:
        return 'Заказы ';
    }
  }

  Widget changeSearchAdsType() {
    return BlocBuilder<SmListMapBloc, SmListMapState>(
      builder: (context, state) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.045,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100),
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

  Align zoomsFABButtons() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: SeparatedColumn(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 8);
          },
          children: [
            FloatingActionButton(
              heroTag: 'SmList1',
              mini: true,
              onPressed: () => _animatedMapController.animatedZoomIn(),
              tooltip: 'Zoom in',
              child: const Icon(
                Icons.add,
                size: 20,
                color: Colors.white,
              ),
            ),
            FloatingActionButton(
              heroTag: 'SmList2',
              mini: true,
              onPressed: () => _animatedMapController.animatedZoomOut(),
              tooltip: 'Zoom out',
              child: const Icon(
                Icons.remove,
                size: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  MarkerClusterLayerWidget adEquipmentMarkersWidget(
      List<AdEquipment> adEquipment) {
    return MarkerClusterLayerWidget(
        options: MarkerClusterLayerOptions(
          maxClusterRadius: 100,
          builder: (context, markers) {
            return Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.appPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(3),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Center(
                      child: Text(
                        '${markers.length}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      )),
                ),
              ),
            );
          },
          markers: adEquipment.map((point) {
            return marker(
              latitude: point.latitude,
              longitude: point.longitude,
              name: point.title,
              price: point.price.toString(),
              onTap: () => _onMarkerTap(
                  name: point.title,
                  id: point.id.toString(),
                  address: point.address,
                  urlFoto: point.urlFoto,
                  serviceTypeEnum: ServiceTypeEnum.EQUIPMENT),
            );
          }).toList(),
        ));
  }

  Container markerWidget({required String? title, required String price}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            cutLongTitle(title ?? 'Без название'),
            maxLines: 2,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            getPriceWithHint(price),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  MarkerClusterLayerWidget adSpecializedMachineryMarkersWidget(
      List<AdSpecializedMachinery> adSpecializedMachinery) {
    return MarkerClusterLayerWidget(
        options: MarkerClusterLayerOptions(
          maxClusterRadius: 100,
          builder: (context, markers) {
            return Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.appPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(3),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Center(
                      child: Text(
                        '${markers.length}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      )),
                ),
              ),
            );
          },
          markers: adSpecializedMachinery.map((point) {
            return marker(
                latitude: point.latitude,
                longitude: point.longitude,
                name: point.name,
                price: point.price.toString(),
                onTap: () => _onMarkerTap(
                    name: point.name ?? '',
                    id: point.id.toString(),
                    address: point.address ?? '',
                    urlFoto: point.urlFoto,
                    serviceTypeEnum: ServiceTypeEnum.MACHINARY));
          }).toList(),
        ));
  }

  Marker marker(
      {required double? latitude,
        required double? longitude,
        required String? name,
        required String? price,
        required void Function() onTap}) {
    return Marker(
      height: MediaQuery.of(context).size.height * 0.08,
      width: MediaQuery.of(context).size.width * 0.3,
      point: LatLng(latitude ?? 0.0, longitude ?? 0.0),
      child: GestureDetector(
        onTap: () => onTap,
        child: markerWidget(title: name, price: price.toString()),
      ),
    );
  }

  Widget adCMMarkersWidget(List<AdConstrutionModel> adCM) {
    return MarkerClusterLayerWidget(
        options: MarkerClusterLayerOptions(
          maxClusterRadius: 100,
          builder: (context, markers) {
            return Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.appPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(3),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Center(
                      child: Text(
                        '${markers.length}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      )),
                ),
              ),
            );
          },
          markers: adCM.map((point) {
            return marker(
                latitude: point.latitude,
                longitude: point.longitude,
                name: point.title,
                price: point.price.toString(),
                onTap: () => _onMarkerTap(
                    name: point.title ?? '',
                    id: point.id.toString(),
                    address: point.address ?? '',
                    urlFoto: point.urlFoto,
                    serviceTypeEnum: ServiceTypeEnum.CM));
          }).toList(),
        ));
  }

  Widget adSVMMarkersWidget(List<AdServiceModel> adSVM) {
    return MarkerClusterLayerWidget(
        options: MarkerClusterLayerOptions(
          maxClusterRadius: 100,
          builder: (context, markers) {
            return Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.appPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(3),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Center(
                      child: Text(
                        '${markers.length}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      )),
                ),
              ),
            );
          },
          markers: adSVM.map((point) {
            return marker(
              latitude: point.latitude,
              longitude: point.longitude,
              name: point.title,
              price: point.price.toString(),
              onTap: () => _onMarkerTap(
                  name: point.title ?? '',
                  id: point.id.toString(),
                  address: point.address ?? '',
                  urlFoto: point.urlFoto,
                  serviceTypeEnum: ServiceTypeEnum.SVM),
            );
          }).toList(),
        ));
  }

  Widget rowWithExtensionsAndFiltresAndTypeShowAd() {
    return BlocBuilder<SmListMapBloc, SmListMapState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: changeSearchAdsType(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    dropDownButton(state),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: dropDownCategories(),
                    ),
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
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.045,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100),
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
                log(stateId.toString(), name: 'State ID :');
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
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.045,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey.shade100),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выберите спецтехнику'),
        actions: [
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                FocusScope.of(context).unfocus();
                if (_searchController.text.isNotEmpty) {
                  context.read<SmListMapBloc>().add(
                      FetchDataWithSearch(searchQuery: _searchController.text));
                }
              }),
        ],
      ),
      body: BlocListener<SmListMapBloc, SmListMapState>(
        listener: (context, state) {
          LatLng? latLng;
          if (state.runtimeType == SMADMapListState ||
              state.runtimeType == SmListInMapScreen) {
            final lat = (state as SMADMapListState)
                .adSpecializedMachinery
                .firstOrNull
                ?.latitude;
            final lon = (state).adSpecializedMachinery.firstOrNull?.longitude;
            if (lat != null && lon != null) {
              latLng = LatLng(lat, lon);
            }
          } else if (state.runtimeType == EQADMapListState) {
            final lat =
                (state as EQADMapListState).equipments.firstOrNull?.latitude;
            final lon = (state).equipments.firstOrNull?.longitude;
            if (lat != null && lon != null) {
              latLng = LatLng(lat, lon);
            }
          } else if (state.runtimeType == CMADMapListState) {
            final lat = (state as CMADMapListState)
                .adContructions
                .firstOrNull
                ?.latitude;
            final lon = (state).adContructions.firstOrNull?.longitude;
            if (lat != null && lon != null) {
              latLng = LatLng(lat, lon);
            }
          } else {
            final lat = (state as SVMADMapListState).adServices.first.latitude;
            final lon = (state).adServices.first.longitude;
            if (lat != null && lon != null) {
              latLng = LatLng(lat, lon);
            }
          }

          if (latLng != null) {
            _animatedMapController.mapController
                .move(latLng, _animatedMapController.mapController.camera.zoom);
          }

          if (latLng == null) {
            ScaffoldMessenger.of(context).showSnackBar(
                AppSnackBar.showErrorSnackBar('Объявление не найдено'));
          }
        },
        child: BlocBuilder<SmListMapBloc, SmListMapState>(
          builder: (context, state) {
            if (state.pageStatus == PageStatus.loading ||
                state.pageStatus == PageStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.pageStatus == PageStatus.failure) {
              return const Center(child: Text('Update, error'));
            } else {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: (searchQuery) {
                        context
                            .read<SmListMapBloc>()
                            .add(FetchDataWithSearch(searchQuery: searchQuery));
                      },
                      decoration: InputDecoration(
                        hintText: 'Поиск по названию',
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
                    ),
                  ),
                  Expanded(
                    child: FlutterMap(
                      mapController: _animatedMapController.mapController,
                      options: const MapOptions(
                        // initialCenter: getMapPoint(state) ?? const LatLng(0, 0),
                        initialZoom: 13,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                        ),
                        CurrentLocationLayer(
                          alignPositionStream:
                          _alignPositionStreamController.stream,
                          alignPositionOnUpdate: AlignOnUpdate.once,
                          style: LocationMarkerStyle(
                            marker: const DefaultLocationMarker(
                              color: AppColors.appPrimaryColor,
                              child: Icon(
                                size: 15,
                                Icons.circle,
                                color: Colors.white,
                              ),
                            ),
                            markerSize: const Size.square(30),
                            accuracyCircleColor:
                            AppColors.appPrimaryColor.withOpacity(0.5),
                            headingSectorRadius: 0,
                            showAccuracyCircle: true,
                            showHeadingSector: true,
                          ),
                        ),
                        if (state.runtimeType == SMADMapListState ||
                            state.runtimeType == SmListInMapScreen)
                          adSpecializedMachineryMarkersWidget(
                              (state as SMADMapListState)
                                  .adSpecializedMachinery),
                        if (state.runtimeType == EQADMapListState)
                          adEquipmentMarkersWidget(
                              (state as EQADMapListState).equipments),
                        if (state.runtimeType == CMADMapListState)
                          adCMMarkersWidget(
                              (state as CMADMapListState).adContructions),
                        if (state.runtimeType == SVMADMapListState)
                          adSVMMarkersWidget(
                              (state as SVMADMapListState).adServices),
                        zoomsFABButtons(),
                        myGeoLocationFABButton(),
                        rowWithExtensionsAndFiltresAndTypeShowAd(),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

SnackBar snackBar({String text = 'Не найдено'}) {
  return SnackBar(
      content: Center(child: Text(text)),
      padding: const EdgeInsets.all(5),
      duration: const Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.orange);
}
