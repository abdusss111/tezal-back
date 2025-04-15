import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:eqshare_mobile/src/core/data/models/cities/city/city_model.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/get_core_widgets.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_photos_widget_small.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/get_widget.dart';
import 'package:eqshare_mobile/src/features/home/home_controller.dart';
import 'package:http/http.dart' as http;

import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/services/providers/loading_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_image_network_widget.dart';
import 'package:eqshare_mobile/src/core/res/app_images.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_model/ad_constrution_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_model/ad_equipment.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_model/ad_service_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_model/ad_specialized_machinery.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:developer' as dev;

import 'package:provider/provider.dart';
import 'package:eqshare_mobile/src/features/main/location/bloc/sm_list_map_bloc.dart';

Future<BitmapDescriptor> createBeautifulMarker(
    String? customUrlImage, String label) async {
  try {
    const double markerWidth = 220; // Marker width in pixels
    const double markerHeight = 201; // Marker height in pixels
    const double squareSize = 170; // Size of the square
    const double cornerRadius = 20; // Corner radius for rounded square
    const double pinHeight = 50; // Height of the pin's narrow section

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint();

    // Draw rounded square top part of the marker
    paint.color = Colors.orange; // Orange square background
    final RRect roundedSquare = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        (markerWidth - squareSize) / 2, // Center the square horizontally
        0, // Start at the top
        squareSize,
        squareSize,
      ),
      Radius.circular(cornerRadius), // Rounded corners
    );
    canvas.drawRRect(roundedSquare, paint);

    // Draw the "pin" shape (narrow bottom)
    final Path pinPath = Path();
    pinPath.moveTo(markerWidth / 2, markerHeight); // Bottom center
    pinPath.lineTo(
        (markerWidth / 2) - 25, markerHeight - pinHeight); // Bottom-left
    pinPath.lineTo(
        (markerWidth / 2) + 25, markerHeight - pinHeight); // Bottom-right
    pinPath.close();
    paint.color = Colors.orange;
    canvas.drawPath(pinPath, paint);

    // Add a white rounded square inner section
    paint.color = Colors.white; // White rounded square inside
    final RRect innerRoundedSquare = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        (markerWidth - (squareSize - 20)) / 2, // Center the square horizontally
        10, // Add a slight margin
        squareSize - 20,
        squareSize - 20,
      ),
      Radius.circular(cornerRadius),
    );
    canvas.drawRRect(innerRoundedSquare, paint);

    if (customUrlImage != null) {
      // If URL image is provided, download and draw the image
      final response = await http.get(Uri.parse(customUrlImage));
      if (response.statusCode == 200) {
        final Uint8List imageBytes = response.bodyBytes;

        // Decode the image
        final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
        final ui.FrameInfo frame = await codec.getNextFrame();
        final ui.Image image = frame.image;

        // Calculate scaling factors for "cover" effect
        final double scaleX = (squareSize - 20) / image.width;
        final double scaleY = (squareSize - 20) / image.height;
        final double scale = scaleX > scaleY
            ? scaleX
            : scaleY; // Choose the larger scale to cover

        final double offsetX = ((squareSize - 20) - (image.width * scale)) / 2;
        final double offsetY = ((squareSize - 20) - (image.height * scale)) / 2;

        // Define a rounded square clip area
        final Path clipPath = Path()
          ..addRRect(innerRoundedSquare)
          ..close();
        canvas.clipPath(clipPath);

        // Draw the scaled image inside the clip area
        final Rect srcRect = Rect.fromLTWH(
            0, 0, image.width.toDouble(), image.height.toDouble());
        final Rect destRect = Rect.fromLTWH(
          (markerWidth - (squareSize - 20)) / 2 +
              offsetX, // Adjust for centering
          10 + offsetY, // Adjust for centering
          image.width * scale,
          image.height * scale,
        );
        canvas.drawImageRect(image, srcRect, destRect, paint);
      } else {
        // If the image fails to load, display a fallback emoji
        _drawFallbackText(canvas, markerWidth, squareSize, label: label);
      }
    } else {
      // If no URL is provided, display a fallback emoji
      _drawFallbackText(canvas, markerWidth, squareSize, label: label);
    }

    // Convert canvas to image and return as BitmapDescriptor
    final ui.Image markerImage = await pictureRecorder
        .endRecording()
        .toImage(markerWidth.toInt(), markerHeight.toInt());
    final ByteData? byteData =
        await markerImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List finalImageBytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(finalImageBytes);
  } catch (e) {
    debugPrint('Error creating marker: $e');
    return BitmapDescriptor.defaultMarker; // Fallback to default marker
  }
}

void _drawFallbackText(Canvas canvas, double markerWidth, double circleDiameter,
    {required String label}) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(
      text: label.isNotEmpty
          ? label
          : '\u{1F464}', // Use label or a default emoji
      style: const TextStyle(
        fontSize: 60,
        color: Colors.grey,
        fontWeight: FontWeight.bold,
      ),
    ),
    textDirection: TextDirection.ltr,
  );
  textPainter.layout();
  textPainter.paint(
    canvas,
    Offset(
      (markerWidth - textPainter.width) / 2, // Center horizontally
      (circleDiameter - textPainter.height) / 2, // Center vertically
    ),
  );
}

class GoogleMapScreenController extends AppSafeChangeNotifier
    with LoadingChangeNotifier {
  ClusterManager? clusterManagers;
  GoogleMapController? controller;
  Set<Marker> markers = {};

  List<dynamic> data;
  ServiceTypeEnum serviceTypeEnum;
  City? selectedCity;
  static const double markerOffsetFactor = 15;

  static const double clusterManagerLongitudeOffset = 3;

  LatLng? currentLocation;
  LatLng currentAlmatyLocation = LatLng(43.2220, 76.8512);
  final BuildContext? context;

  GoogleMapScreenController(
      {required this.data,
        required this.serviceTypeEnum,
        this.context,


      }) {
    Geolocator.requestPermission();
    _initLocation();
    initController();
    _initializeSearchAndData();  // Custom method to replace initState()
  }
  final TextEditingController _searchController = TextEditingController();

  void _initializeSearchAndData() {
    _searchController.clear();  // Очистка поля поиска

    // Проверка, что context не равен null
    if (context != null) {
      context!.read<SmListMapBloc>().add(FetchData(
        serviceTypeEnum: context!.read<SmListMapBloc>().state.pickedServiceType,
      ));
    } else {
      debugPrint('Context is null, skipping FetchData');
    }
  }

  void _initLocation() {
    final selectedCity =
        Provider.of<HomeController>(router.configuration.navigatorKey.currentContext!, listen: false).selectedCity;

    if (selectedCity != null) {
      currentLocation = LatLng(selectedCity.latitude ?? 0, selectedCity.longitude ?? 0);
    } else {
      currentLocation = LatLng(43.2220, 76.8512);  // Алматы по умолчанию
    }
    notifyListeners();
  }
  void onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  void moveMyGeo() async {
    // Проверяем и запрашиваем разрешение на геолокацию
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      final request = await Geolocator.requestPermission();
      if (request == LocationPermission.denied ||
          request == LocationPermission.deniedForever) {
        // Если пользователь отказал — просто выходим
        debugPrint('Пользователь отказал в доступе к геолокации');
        return;
      }
    }

    // Получаем текущую позицию
    final position = await Geolocator.getCurrentPosition();
    final currentLatLng = LatLng(position.latitude, position.longitude);

    // Сохраняем
    currentLocation = currentLatLng;

    // Перемещаем камеру к текущей позиции
    controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: currentLatLng, zoom: 17),
      ),
    );

    notifyListeners(); // если ты где-то отображаешь текущую точку
  }


  void checkLocation() async {
    final value = await Geolocator.checkPermission();
    if (value == LocationPermission.always ||
        value == LocationPermission.whileInUse) {
      getLocation();
    } else {
      final value = await Geolocator.requestPermission();
      if (value == LocationPermission.always ||
          value == LocationPermission.whileInUse) {
        getLocation();
      } else {
        router.configuration.navigatorKey.currentContext?.pop();
      }
    }
  }

  Future<LatLng?> getLocation() async {
    final data = await Geolocator.getCurrentPosition();
    currentLocation = LatLng(data.latitude, data.longitude);
    notifyListeners();
    return currentLocation;
  }

  void _addClusterManager() {
    updateMarkersTypeInCluster(data: data, serviceTypeEnum: serviceTypeEnum);
  }

  String cutLongTitle(String cutString, {int endOfCutForString = 14}) {
    if (cutString.length > 15) {
      return '${cutString.substring(0, endOfCutForString)}...';
    }
    return cutString;
  }

  int _currentTaskId = 0; // Идентификатор задачи, чтобы отслеживать последнюю запущенную

  void updateMarkersTypeInCluster({
    required ServiceTypeEnum serviceTypeEnum,
    required List<dynamic> data,
  }) {
    markers.clear();
    _currentTaskId++; // Увеличиваем ID, чтобы остановить предыдущий цикл

    switch (serviceTypeEnum) {
      case ServiceTypeEnum.MACHINARY:
        _addMarkersToClusterSm(data as List<AdSpecializedMachinery>, _currentTaskId);
        return;
      case ServiceTypeEnum.EQUIPMENT:
        _addMarkersToCluster(
          data: data as List<AdEquipment>,
          getId: (item) => item.id.toString(),
          getAddress: (item) => item.address,
          getImageUrl: (item) => item.urlFoto ?? [],
          getPrice: (item) => item.price,
          getDescription: (item) => item.description,
          getRating: (item) => item.rating,
          serviceTypeEnum: ServiceTypeEnum.EQUIPMENT,
          getTitle: (item) => item.title,
          getLatitude: (item) => item.latitude ?? 0,
          getLongitude: (item) => item.longitude ?? 0,
          taskId: _currentTaskId
        );
        return;
      case ServiceTypeEnum.CM:
        _addMarkersToCluster(
          data: data as List<AdConstrutionModel>,
          getId: (item) => item.id.toString(),
          getAddress: (item) => item.address ?? 'no name',
          getImageUrl: (item) => item.urlFoto ?? [],
          getPrice: (item) => item.price,
          getDescription: (item) => item.description,
          getRating: (item) => item.rating,
          serviceTypeEnum: ServiceTypeEnum.CM,
          getTitle: (item) => item.title ?? 'no name',
          getLatitude: (item) => item.latitude ?? 0,
          getLongitude: (item) => item.longitude ?? 0,
          taskId: _currentTaskId
        );
        return;
      case ServiceTypeEnum.SVM:
        _addMarkersToCluster(
          data: data as List<AdServiceModel>,
          getId: (item) => item.id.toString(),
          getAddress: (item) => item.address ?? '',
          getImageUrl: (item) => item.urlFoto ?? [],
          getPrice: (item) => item.price,
          getDescription: (item) => item.description,
          getRating: (item) => item.rating,
          serviceTypeEnum: ServiceTypeEnum.SVM,
          getTitle: (item) => item.title ?? 'no name',
          getLatitude: (item) => item.latitude ?? 0,
          getLongitude: (item) => item.longitude ?? 0,
          taskId: _currentTaskId
        );
        return;
    }
  }

  Future<void> _addMarkersToClusterSm(List<AdSpecializedMachinery> data, int taskId) async {
    for (var i in data) {
      if (taskId != _currentTaskId) break; // Прерываем цикл, если пришел новый вызов

      final MarkerId markerId = MarkerId(i.id.toString());
      final String? imageUrl = (i.urlFoto != null && i.urlFoto!.isNotEmpty)
          ? i.urlFoto!.first
          : null;

      final BitmapDescriptor customMarker = await createBeautifulMarker(imageUrl, '?');

      final Marker marker = Marker(
        anchor: const Offset(.5, .5),
        clusterManagerId: clusterManagers?.clusterManagerId,
        icon: customMarker,
        markerId: markerId,
        consumeTapEvents: true,
        onTap: () {
          dev.log('wasPrint $markerId : ${i.name}');
          selectedModelBottomSheet(
              id: i.id.toString(),
              title: i.name ?? 'no name',
              address: i.address,
              image: i.urlFoto,
              description: i.description,
              price: i.price,
              rating: i.rating,
              serviceTypeEnum: ServiceTypeEnum.MACHINARY);
        },
        position: LatLng(i.latitude ?? 0, i.longitude ?? 0),
      );

      markers.add(marker);
      setLoading(false);
      notifyListeners();
    }

    setLoading(false);
  }




  void initController() {
    clusterManagers = ClusterManager(
        clusterManagerId: const ClusterManagerId("clusterManagerId"),
        onClusterTap: (Cluster cluster) {
          controller
              ?.animateCamera(CameraUpdate.newLatLngBounds(cluster.bounds, 50));
          dev.log(cluster.markerIds.toString(), name: 'Cluster tap');
          dev.log('${cluster.position}', name: 'Cluster position: ');
        });

    _addClusterManager();
  }

  void _addMarkersToCluster<T>({
    required List<T> data,
    required ServiceTypeEnum serviceTypeEnum,
    required String Function(T) getId,
    required String Function(T) getTitle,
    required String Function(T) getAddress,
    required List<String> Function(T) getImageUrl,
    required String? Function(T) getDescription,
    required num? Function(T) getPrice,
    required double? Function(T) getRating,
    required double Function(T) getLatitude,
    required double Function(T) getLongitude,
    required int taskId
  }) async {
    for (var item in data) {
      if (taskId != _currentTaskId) break; // Прерываем цикл, если пришел новый вызов
      final BitmapDescriptor customMarker =
          await createBeautifulMarker(getImageUrl(item).first, 'a');
      final MarkerId markerId = MarkerId('${getId(item)}-$serviceTypeEnum');
      final Marker marker = Marker(
        anchor: const Offset(.5, .5),
        clusterManagerId: clusterManagers?.clusterManagerId,
        markerId: markerId,
        icon: customMarker,
        consumeTapEvents: true,
        onTap: () {
          dev.log('wasPrint $markerId : ${getTitle(item)}');
          selectedModelBottomSheet(
              id: getId(item),
              title: getTitle(item),
              serviceTypeEnum: serviceTypeEnum,
              image: getImageUrl(item),
              description: getDescription(item),
              price: getPrice(item),
              rating: getRating(item),
              address: getAddress(item));
        },
        position: LatLng(
          getLatitude(item),
          getLongitude(item),
        ),
      );
      markers.add(marker);

      setLoading(false);

      // final progress =
      //     ProgressHUD.of(router.configuration.navigatorKey.currentContext!);

      // progress?.dismiss();
      notifyListeners();
    }
  }

  Future<dynamic> selectedModelBottomSheet(
      {String? title,
      String? address,
      String? description,
      double? rating,
      num? price,
      List<String>? image,
      required ServiceTypeEnum serviceTypeEnum,
      required String id}) {
    return showModalBottomSheet(
      context: router.configuration.navigatorKey.currentContext!,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SafeArea(
            child: Container(
          padding: const EdgeInsets.all(16.0),
          child:
          SingleChildScrollView(child:

              Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                  child: const Text(
                'Выбранная точка',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),

              const SizedBox(height: 16),
              // ListTile(
              //     minVerticalPadding: 0,
              //     // minLeadingWidth: 150,
              //     leading: SizedBox(
              //       width: 120,
              //       height: 200,
              //       child: AppImageNetworkWidget(
              //         imageUrl:
              //             image != null && image.isNotEmpty ? image.first : '',
              //         imagePlaceholder: AppImages.imagePlaceholder,
              //         boxFit: image != null && image.isNotEmpty
              //             ? BoxFit.cover
              //             : null,
              //         width: 120,
              //         height: 200,
              //       ),
              //     ),
              //     title: Text(cutLongTitle(title ?? '')),
              //     subtitle:
              //         Text(cutLongTitle(address ?? '', endOfCutForString: 20))),
              // const SizedBox(height: 16),
              Column(children: [
                AdDetailPhotosWidgetSmall(
                  imageUrls: image ?? [],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AdDetailHeaderWidget(
                            titleText: title ?? '',
                          ),
                          const SizedBox(height: 8),
                          AdDetailPriceWidget(
                              price: price.toString(), rating: rating),
                          AdDivider()
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Container(
                    //   padding: EdgeInsets.symmetric(horizontal: 16),
                    //   decoration: const BoxDecoration(
                    //     color: Colors.white,
                    //   ),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       // AdDescriptionWidget(
                    //       //   descriptionText:
                    //       //       adDetail?.description ?? '',
                    //       //   adSM: controller.adDetails,
                    //       // ),
                    //       Padding(
                    //           padding: const EdgeInsets.all(4),
                    //           child: Divider(color: Colors.grey.shade100)),
                    //       AdDescriptionOnlyWidget(
                    //           description: description ?? ''),
                    //     ],
                    //   ),
                    // ),
                  ],
                )
              ]),
              const SizedBox(height: 16),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SafeArea(
                      child: AppPrimaryButtonWidget(
                          onPressed: () async {
                            if (serviceTypeEnum == ServiceTypeEnum.MACHINARY) {
                              await context.pushNamed(
                                AppRouteNames.adSMDetail,
                                extra: {'id': id.toString()},
                              );
                            } else if (serviceTypeEnum ==
                                ServiceTypeEnum.EQUIPMENT) {
                              await context.pushNamed(
                                  AppRouteNames.adEquipmentDetail,
                                  extra: {"id": id.toString()});
                            } else if (serviceTypeEnum == ServiceTypeEnum.CM) {
                              context.pushNamed(
                                  AppRouteNames.adConstructionDetail,
                                  extra: {'id': id.toString()});
                            } else if (serviceTypeEnum == ServiceTypeEnum.SVM) {
                              context.pushNamed(
                                  AppRouteNames.adServiceDetailScreen,
                                  extra: {'id': id.toString()});
                            }
                          },
                          textColor: Colors.white,
                          text: 'Подробнее'))),

              // ElevatedButton(

              //   onPressed: () async {
              //     if (serviceTypeEnum == ServiceTypeEnum.MACHINARY) {
              //       await context.pushNamed(
              //         AppRouteNames.adSMDetail,
              //         extra: {'id': id.toString()},
              //       );
              //     } else if (serviceTypeEnum == ServiceTypeEnum.EQUIPMENT) {
              //       await context.pushNamed(AppRouteNames.adEquipmentDetail,
              //           extra: {"id": id.toString()});
              //     } else if (serviceTypeEnum == ServiceTypeEnum.CM) {
              //       context.pushNamed(AppRouteNames.adConstructionDetail,
              //           extra: {'id': id.toString()});
              //     } else if (serviceTypeEnum == ServiceTypeEnum.SVM) {
              //       context.pushNamed(AppRouteNames.adServiceDetailScreen,
              //           extra: {'id': id.toString()});
              //     }

              //     // if (showAdSpecializedMachinery) {

              //     // } else {
              //     //   await context.pushNamed(AppRouteNames.adEquipmentDetail,
              //     //       extra: {"id": id.toString()});
              //     // }
              //   },
              //   child: const Text('Посмотреть объявление'),
              // ),
            ],
          ),
        )));
      },
    );
  }
}
