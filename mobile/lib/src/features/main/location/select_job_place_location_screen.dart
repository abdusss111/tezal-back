import 'dart:async';
import 'dart:math';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:latlong2/latlong.dart' as loc;

class MapPickerWidget extends StatefulWidget {
  final LatLng? initialPoint;

  const MapPickerWidget({super.key, this.initialPoint});

  @override
  State<MapPickerWidget> createState() => _MapPickerWidgetState();
}

class _MapPickerWidgetState extends State<MapPickerWidget> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? controller;
  ValueNotifier<LatLng?> selectedPointNotifier = ValueNotifier<LatLng?>(null);
  late final TextEditingController _addressController = TextEditingController();
  String address = '';
  // double _currentLat = 0;
  // double _currentLng = 0;

  LatLng? currentPosition;
  Future<LatLng?>? getfuture;

  @override
  void initState() {
    super.initState();
    // _currentLat = widget.initialPoint?.latitude ?? 43.222;
    // _currentLng = widget.initialPoint?.longitude ?? 76.851;
    // selectedPointNotifier.value ??= LatLng(, _currentLng);
    checkLocationPermission();
    // getfuture = getLocation();
  }

  // Future<void> checkLocation() async {
  //   final value = await Geolocator.requestPermission();
  //   if (value == LocationPermission.always ||
  //       value == LocationPermission.whileInUse) {
  //     getLocation();
  //   } else {
  //     final value = await Geolocator.requestPermission();
  //     if (value == LocationPermission.always ||
  //         value == LocationPermission.whileInUse) {
  //       getLocation();
  //     } else {
  //       if (mounted) Navigator.pop(context);
  //     }
  //   }
  // }

  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Ask for permission again, if denied, fallback
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Use fallback location if permission is denied
        setState(() {
          currentPosition = widget.initialPoint ??
              LatLng(43.222, 76.851); // Fallback location
        });
        return;
      }
    }

    // If permission is granted, fetch current location
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    final data = await Geolocator.getCurrentPosition();
    setState(() {
      currentPosition = LatLng(data.latitude, data.longitude);
    });
    controller?.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(target: currentPosition!, zoom: 12)),
    );
  }

  Future<void> _searchAddress() async {
    String query = _addressController.text;
    if (query.isEmpty) return;

    try {
      // Получаем текущее местоположение пользователя
      final GoogleMapController controller = await _controller.future;
      // final data await Geolocator.getCurrentPosition();
      LatLng currentPositionData = LatLng(
          currentPosition?.latitude ?? 0, currentPosition?.longitude ?? 0);

      // Получаем название города из текущих координат
      String currentCity = await _getCityFromCoordinates(
          currentPositionData.latitude, currentPositionData.longitude);

      // Составляем полный запрос с учетом города
      String fullQuery = '$query, $currentCity, Kazakhstan';

      List<geo.Location> locations = await geo.locationFromAddress(fullQuery);
      if (locations.isNotEmpty) {
        geo.Location location = locations[0];
        selectedPointNotifier.value =
            LatLng(location.latitude, location.longitude);

        // Анимируем камеру к найденной точке
        controller.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(location.latitude, location.longitude),
          ),
        );
      } else {
        // Если в текущем городе ничего не найдено, ищем по всей стране
        String countryQuery = 'Kazakhstan, $query';
        List<geo.Location> countryLocations =
            await geo.locationFromAddress(countryQuery);
        if (countryLocations.isNotEmpty) {
          geo.Location location = countryLocations[0];
          selectedPointNotifier.value =
              LatLng(location.latitude, location.longitude);

          // Анимируем камеру к найденной точке
          controller.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(location.latitude, location.longitude),
            ),
          );
        } else {
          selectedPointNotifier.value = null;
          setState(() {
            address = 'No results found for the provided address.';
          });
        }
      }
    } catch (e) {
      debugPrint('Error searching address: $e');
      setState(() {
        address = 'Загрузка...';
      });
    }
  }

  Future<String> _getCityFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<geo.Placemark> placemarks =
          await geo.placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        geo.Placemark placemark = placemarks[0];
        return placemark.locality ?? ''; // Возвращаем название города
      }
    } catch (e) {
      debugPrint('Error getting city: $e');
    }
    return ''; // Возвращаем пустую строку, если не удалось определить город
  }

  Future<String> _getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<geo.Placemark> placemarks =
          await geo.placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        geo.Placemark placemark = placemarks[0];
        return ' ${placemark.street ?? ''},${placemark.locality}';
      }
    } catch (e) {
      debugPrint('Error getting address: $e');
    }
    return '';
  }

  @override
  void dispose() {
    selectedPointNotifier.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Widget _buildAddressSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _addressController,
        textInputAction: TextInputAction.search,
        onSubmitted: (value) async {
          await _searchAddress();
        },
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          labelText: 'Введите адрес',
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              await _searchAddress();
            },
          ),
        ),
      ),
    );
  }

  Align myGeoLocationFABButton() {
    return Align(
      alignment: Alignment(1, 0.65),
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, bottom: 8),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.1125,
          height: MediaQuery.of(context).size.width * 0.1125,
          child: FloatingActionButton(
            heroTag: 'SmList3',
            mini: true,
            onPressed: () async {
              await checkLocationPermission();

              if (currentPosition == null) {
                await getCurrentLocation();
                controller?.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: LatLng(currentPosition?.latitude ?? 0,
                            currentPosition?.longitude ?? 0),
                        zoom: 13)));
              } else {
                controller?.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target: currentPosition!, zoom: 13)));
              }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выберите точку вызова'),
      ),
      body: FutureBuilder(
          future: getfuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return AppCircularProgressIndicator();
            } else if (snapshot.hasError) {
              return StatefulBuilder(builder: (context, setStater) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 4),
                        child: Text(
                          'Для выбора местоположение нужно разрешение. Нажмите обновить!',
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 4),
                        child: AppPrimaryButtonWidget(
                            // buttonType: ButtonType.,
                            onPressed: () {
                              setStater(() {
                                checkLocationPermission();
                              });
                            },
                            text: ('Обновите страницу')),
                      )
                    ],
                  ),
                );
              });
            }
            return Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: _buildAddressSearch(),
                ),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: ValueListenableBuilder<LatLng?>(
                      valueListenable: selectedPointNotifier,
                      builder: (context, selectedPoint, _) {
                        return Stack(
                          children: [
                            GoogleMap(
                              myLocationEnabled: currentPosition !=
                                  null, // Enable only if location is available
                              myLocationButtonEnabled: false,
                              initialCameraPosition: CameraPosition(
                                target:
                                    selectedPoint ?? // If a point is selected, focus there
                                        LatLng(
                                            currentPosition?.latitude ?? 43.222,
                                            currentPosition?.longitude ??
                                                76.851), // Default to a city center (e.g., Almaty)
                                zoom: 12,
                              ),
                              onMapCreated: (GoogleMapController controller) {
                                this.controller = controller;
                                _controller.complete(controller);
                              },
                              markers: selectedPoint != null
                                  ? {
                                      Marker(
                                        markerId:
                                            const MarkerId('selected_point'),
                                        position: selectedPoint,
                                      ),
                                    }
                                  : {},
                              onTap: (LatLng latLng) {
                                selectedPointNotifier.value = latLng;
                              },
                            ),
                            myGeoLocationFABButton(),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(child:  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ValueListenableBuilder<LatLng?>(
                        valueListenable: selectedPointNotifier,
                        builder: (context, selectedPoint, _) {
                          if (selectedPoint == null) {
                            return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 8),
                                  if (address.isEmpty) Text('Выберите адрес'),
                                ]);
                          }

                          return FutureBuilder<String>(
                            future: _getAddressFromCoordinates(
                                selectedPoint.latitude,
                                selectedPoint.longitude),
                            builder: (context, snapshot) {
                              // if (snapshot.connectionState ==
                              //     ConnectionState.waiting) {
                              //   return const CircularProgressIndicator();
                              // } else if (snapshot.hasError) {
                              //   return Text('Error: ${snapshot.error}');
                              // } else {
                              address = snapshot.data ?? '';
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 8),
                                  if (address.isEmpty) Text('Выберите адрес'),
                                  if (address.isNotEmpty)
                                    Text('Выбранный адрес: $address'),
                                  const SizedBox(height: 8),
                                  if (address.isNotEmpty)
                                    FilledButton(
                                      style: FilledButton.styleFrom(
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        context.pop({
                                          'selectedPoint': loc.LatLng(
                                              selectedPoint.latitude,
                                              selectedPoint.longitude),
                                          'address': address,
                                        });
                                      },
                                      child: const Text('Сохранить'),
                                    ),
                                ],
                              );
                              // }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
            )],
            );
          }),
    );
  }
}
