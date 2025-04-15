import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/features/main/location/google_map/google_navigation_screen/check_user_navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:web_socket_channel/io.dart';

class UserLocation {
  final double currentLatitude;
  final double currentLongitude;

  UserLocation({required this.currentLatitude, required this.currentLongitude});

  static String toMap(UserLocation e) {
    return jsonEncode({
      'latitude': e.currentLatitude,
      'longitude': e.currentLongitude,
      'created_at': DateTimeUtils()
          .dateFormatWithyyyyMMddTHHmmssSSSSSSSSS(DateTime.now()),
    });
  }
}

class GoogleNavigationScreenController extends AppSafeChangeNotifier {
  GoogleMapController? controller;
  Position? _currentPosition;
  final LatLng destinationGeo;
  final String currentReID;
  final String destinationAddress;

  late WebSocket ws;
  late IOWebSocketChannel channel;
  PolylinePoints? polylinePoints;
  late Stream<Position> getPositionStream;

  late StreamSubscription<Position> _positionStreamSubscription;
  StreamSubscription<Position> get positionStreamSubscription =>
      _positionStreamSubscription;

  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  Marker? destinationMarker;

  GoogleNavigationScreenController({
    required this.currentReID,
    required this.destinationGeo,
    required this.destinationAddress,
  }) {
    init();
  }

  void init() async {
    await checkPermission();
    await getCurrentLocation();
  }

  Future<void> initOnMapCreated() async {
    await initWebSocket();
    startLocationStream();
    await createPolylines();
    _addDestinationMarker();
  }

  Future<void> initWebSocket() async {
    try {
      final token = await TokenService().getToken();
      final headers = {'Authorization': 'Bearer $token'};
      final path =
          '${ApiEndPoints.baseUrlForWS}/re/$currentReID/stream?is_driver=true';
      ws = await WebSocket.connect(path, headers: headers);
      channel = IOWebSocketChannel(ws);
    } catch (e) {
      log('WebSocket connection error: $e');
    }
  }

  int count = 0;
  void startLocationStream() {
    getPositionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );

    _positionStreamSubscription = getPositionStream.listen((Position position) {
      final isPositionDifferense =
          _currentPosition?.latitude != position.latitude ||
              _currentPosition?.longitude != position.longitude;
      log(_currentPosition.toString(), name: 'CurrentPosition : ');
      log(position.toString(), name: 'GetPosition : ');

      if (isPositionDifferense) {
        _currentPosition = position;
        sendDataForWs(
            latitude: position.latitude, longitude: position.longitude);
        needToReCreatePolylines(
            userPosition: LatLng(position.latitude, position.longitude));
      }
    });
  }

  Future<void> needToReCreatePolylines({required LatLng userPosition}) async {
    final isToNeedToReCreate = CheckUserNavigationService().checkUserNavigation(
        userPosition: userPosition,
        polylineCoordinates: polylineCoordinates,
        nextRoutePoint: _getNextRoutePoint(),
        userHeading: _getUserHeading(),
        thresholdDistance: 60,
        thresholdDirection: 0.30);

    if (isToNeedToReCreate) {
      await clearPolylines();
      await createPolylines();
    }
  }

  Future<void> clearPolylines() async {
    polylineCoordinates.clear();
    notifyListeners();
  }

  Future<void> createPolylines() async {
    try {
      polylinePoints = PolylinePoints();
      log('Перед построением маршрута: $_currentPosition', name: 'DEBUG');

      if (_currentPosition == null) {
        log('Ожидание получения местоположения...', name: 'DEBUG');
        await getOnlyCurrentLocation();
        log('После вызова getOnlyCurrentLocation: $_currentPosition', name: 'DEBUG');
      }

      if (_currentPosition == null) {
        log('Ошибка! Координаты так и не получены, маршрут не может быть построен.', name: 'ERROR');
        return;
      }

      log('Строим маршрут от ${_currentPosition!.latitude}, ${_currentPosition!.longitude} до ${destinationGeo.latitude}, ${destinationGeo.longitude}');

      final String url =
          "https://routes.googleapis.com/directions/v2:computeRoutes?key=AIzaSyC45LiL7vakqWnbrhL4xYDkjE2pE0jk5Fw";

      final HttpClientRequest request = await HttpClient().postUrl(Uri.parse(url));
      request.headers.set('Content-Type', 'application/json');
      request.headers.set('X-Goog-FieldMask', 'routes.distanceMeters,routes.duration,routes.polyline.encodedPolyline');

      request.write(json.encode({
        "origin": {
          "location": {
            "latLng": {
              "latitude": _currentPosition!.latitude,
              "longitude": _currentPosition!.longitude
            }
          }
        },
        "destination": {
          "location": {
            "latLng": {
              "latitude": destinationGeo.latitude,
              "longitude": destinationGeo.longitude
            }
          }
        },
        "travelMode": "DRIVE"
      }));

      final HttpClientResponse response = await request.close();
      final String responseBody = await response.transform(utf8.decoder).join();
      final Map<String, dynamic> decodedResponse = json.decode(responseBody);

      if (decodedResponse['routes'] == null || decodedResponse['routes'].isEmpty) {
        log('Ошибка! Google не вернул маршрут', name: 'ERROR');
        return;
      }

      String encodedPolyline = decodedResponse['routes'][0]['polyline']['encodedPolyline'];
      log('Маршрут успешно получен и декодируется', name: 'DEBUG');

      drawRouteOnMap(encodedPolyline);

    } catch (e) {
      log('Ошибка при создании маршрута: $e', name: 'ERROR');
    }
  }

  void drawRouteOnMap(String encodedPolyline) {
    List<LatLng> polylineCoordinates = [];

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> result = polylinePoints.decodePolyline(encodedPolyline);

    if (result.isNotEmpty) {
      for (var point in result) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    log("Декодированные координаты маршрута: $polylineCoordinates");

    _addPolyline(polylineCoordinates);
  }

  void _addPolyline(List<LatLng> coordinates) {
    PolylineId id = PolylineId('route');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: coordinates,
      width: 5,
    );
    polylines[id] = polyline;
    notifyListeners();
  }

  void _addDestinationMarker() {
    destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: destinationGeo,
      infoWindow: InfoWindow(title: destinationAddress),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    notifyListeners();
  }

  LatLng _getNextRoutePoint() {
    if (polylineCoordinates.isEmpty || _currentPosition == null) {
      return LatLng(0, 0);
    }

    double minDistance = double.infinity;
    int closestIndex = 0;

    for (int i = 0; i < polylineCoordinates.length; i++) {
      double distance = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
      );

      if (distance < minDistance) {
        minDistance = distance;
        closestIndex = i;
      }
    }

    if (closestIndex + 1 < polylineCoordinates.length) {
      return polylineCoordinates[closestIndex + 1];
    } else {
      return polylineCoordinates.last;
    }
  }

  double _getUserHeading() {
    if (_currentPosition == null || polylineCoordinates.isEmpty) {
      return 0;
    }

    LatLng nextPoint = _getNextRoutePoint();
    return Geolocator.bearingBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      nextPoint.latitude,
      nextPoint.longitude,
    );
  }

  void sendDataForWs({required double latitude, required double longitude}) {
    final userLocation = UserLocation(
      currentLatitude: latitude,
      currentLongitude: longitude,
    );
    log('Position: latitude: $latitude,longitude:  $longitude');

    channel.sink.add(UserLocation.toMap(userLocation));
  }

  Future<void> checkPermission() async {
    final permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      await getCurrentLocation();
    } else {
      router.configuration.navigatorKey.currentContext!.pop();
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      log('CURRENT POS: $_currentPosition');

      controller?.animateCamera(
        CameraUpdate.newLatLng(LatLng(_currentPosition!.latitude, _currentPosition!.longitude)),
      );

      controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: 18.0,
          ),
        ),
      );
    } catch (e) {
      log('Error getting current location: $e');
    }
  }

  Future<void> getOnlyCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      notifyListeners();
    } catch (e) {
      log('Error getting current location: $e');
    }
  }

  void onMapCreated(GoogleMapController controller) {
    this.controller = controller;
    initOnMapCreated();
  }

  void closeStream() {
    _positionStreamSubscription.cancel();
    channel.sink.close();
    ws.close();
    notifyListeners();
  }
}