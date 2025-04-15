import 'dart:async';
import 'dart:developer';

import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
// import 'package:separated_column/separated_column.dart';

class MapPickerWidget extends StatefulWidget {
  final LatLng? initialPoint;

  const MapPickerWidget({super.key, this.initialPoint});

  @override
  State<MapPickerWidget> createState() => _MapPickerWidgetState();
}

class _MapPickerWidgetState extends State<MapPickerWidget> {
  bool? serviceEnabled;
  PermissionStatus? permissionGranted;

  ValueNotifier<LatLng?> selectedPointNotifier = ValueNotifier<LatLng?>(null);
  String address = '';
  loc.Location location = loc.Location();
  GoogleMapController? mapController;
  final TextEditingController _addressController = TextEditingController();
  double _currentLat = 0;
  double _currentLng = 0;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _checkPermissions();
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

  Future<void> _searchAddress() async {
    String query = _addressController.text;
    if (query.isEmpty) return;

    try {
      loc.LocationData? locationData = await location.getLocation();
      String city = await _getCityFromCoordinates(
          locationData.latitude!, locationData.longitude!);
      String fullQuery =
          'Kazakhstan, $city city, $query'; // Составляем полный запрос с указанием города
      List<geo.Location> locations = await geo.locationFromAddress(fullQuery);
      if (locations.isNotEmpty) {
        geo.Location location = locations[0];
        final LatLng newLatLng = LatLng(location.latitude, location.longitude);

        selectedPointNotifier.value = newLatLng;
        mapController?.animateCamera(
          CameraUpdate.newLatLng(newLatLng),
        );
        _updateMarker(newLatLng);
      } else {
        selectedPointNotifier.value = null;
        setState(() {
          address = 'No results found for the provided address.';
        });
      }
    } catch (e) {
      debugPrint('Error searching address: $e');
      selectedPointNotifier.value = null;
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
        String city = placemark.locality ?? '';
        return city;
      }
    } catch (e) {
      debugPrint('Error getting city: $e');
    }
    return '';
  }

  Future<String> _getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<geo.Placemark> placemarks =
          await geo.placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        geo.Placemark placemark = placemarks[0];
        return placemark.street ?? '';
      }
    } catch (e) {
      debugPrint('Error getting address: $e');
    }
    return '';
  }

  Future<loc.LocationData?> _currentLocation() async {
    await _checkPermissions();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    final location = loc.Location();

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    try {
      final loc.LocationData currentLocation = await location.getLocation();
      _currentLat = currentLocation.latitude!;
      _currentLng = currentLocation.longitude!;
      selectedPointNotifier.value ??= LatLng(_currentLat, _currentLng);
      _updateMarker(LatLng(_currentLat, _currentLng));
      return currentLocation;
    } catch (e) {
      log('Error location=$e');
    }
  }

  void _updateMarker(LatLng point) {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('selected-location'),
          position: point,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      };
    });
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
          AppDialogService.showLoadingDialog(context);
          await _searchAddress();
          context.pop();
        },
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          labelText: 'Введите адрес',
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              AppDialogService.showLoadingDialog(context);
              await _searchAddress();
              context.pop();
            },
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
      body: FutureBuilder<LocationData?>(
        future: _currentLocation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Could not fetch location data'));
          } else {
            return Stack(
              children: [
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: selectedPointNotifier.value!,
                    zoom: 12,
                  ),
                  markers: _markers,
                  onTap: (LatLng latLng) {
                    selectedPointNotifier.value = latLng;
                    _updateMarker(latLng);
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(16.0),
                        child: ValueListenableBuilder<LatLng?>(
                          valueListenable: selectedPointNotifier,
                          builder: (context, selectedPoint, _) {
                            if (selectedPoint == null) {
                              return const Center(
                                  child: Text('No point selected'));
                            }

                            return FutureBuilder<String>(
                              future: _getAddressFromCoordinates(
                                  selectedPoint.latitude,
                                  selectedPoint.longitude),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  address = snapshot.data ?? '';
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Выбранный адрес: $address'),
                                      const SizedBox(height: 8),
                                      FilledButton(
                                        style: FilledButton.styleFrom(
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          debugPrint(address);
                                          context.pop({
                                            'selectedPoint': selectedPoint,
                                            'address': address,
                                          });
                                        },
                                        child: const Text('Подтвердить'),
                                      ),
                                    ],
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )),
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: _buildAddressSearch(),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
