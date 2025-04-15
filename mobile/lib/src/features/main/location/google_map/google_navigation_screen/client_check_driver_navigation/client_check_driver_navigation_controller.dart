import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/features/main/location/google_map/google_navigation_screen/check_user_navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:web_socket_channel/io.dart';

class ClientCheckDriverNavigationController extends AppSafeChangeNotifier {
  GoogleMapController? controller;
  Position? _currentDriverPosition;
  Position? get currentDriverPosition => _currentDriverPosition;

  final LatLng destinationGeo;
  final String currentReID;

  late WebSocket ws;
  late IOWebSocketChannel channel;

  PolylinePoints? polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};

  Set<Marker> driverMarkerSet = {};
  BitmapDescriptor? carIcon;

  ClientCheckDriverNavigationController({
    required this.currentReID,
    required this.destinationGeo,
  }) {
    log("📌 Контроллер создан");

    init();
    _loadCarIcon();
    _addDestinationMarker(); // Добавляем маркер назначения при инициализации
    initWebSocket(); // 💡 Вызовем WebSocket сразу при создании!
  }

  void init() async {
    await checkPermission();
  }

  Future<void> initOnMapCreated() async {
    log("🔥 initOnMapCreated() вызван"); // Проверяем

    await initWebSocket();
    await createPolylines();
  }

  Future<void> initWebSocket() async {
    log("🌐 Подключаемся к WebSocket: ${ApiEndPoints.baseUrlForWS}/re/$currentReID/stream?is_driver=false");

    try {
      final token = await TokenService().getToken();

      final headers = {'Authorization': 'Bearer $token'};

      final path =
          '${ApiEndPoints.baseUrlForWS}/re/$currentReID/stream?is_driver=false';

      ws = await WebSocket.connect(path, headers: headers);
      channel = IOWebSocketChannel(ws);

      channel.stream.listen((message) async {
        log("📩 WebSocket получил данные: $message");

        final data = jsonDecode(message);
        final double latitude = data['latitude'];
        final double longitude = data['longitude'];
        final newPosition = LatLng(latitude, longitude);
        _updateDriverPosition(newPosition);

        if (_currentDriverPosition == null) {
          _currentDriverPosition = Position(
              latitude: latitude,
              longitude: longitude,
              timestamp: DateTime.now(),
              accuracy: 0,
              altitude: 0,
              heading: 0,
              speed: 0,
              speedAccuracy: 0,
              altitudeAccuracy: 0,
              headingAccuracy: 0);
          await createPolylines();
        }
      }, onError: (error) {
        log("❌ WebSocket ошибка: $error");
        _reconnectWebSocket(); // Переподключение при ошибке
      }, onDone: () {
        log("🚪 WebSocket соединение закрыто");
        _reconnectWebSocket(); // Переподключение при закрытии соединения
      });
    } catch (e) {
      log('WebSocket connection error: $e');
      _reconnectWebSocket(); // Переподключение при исключении
    }
  }

  void _reconnectWebSocket() async {
    log("🔄 Переподключаем WebSocket через 5 секунд...");
    await Future.delayed(Duration(seconds: 5));
    initWebSocket();
  }

  void _initDriverMarker(LatLng newPosition) {
    if (carIcon == null) return;

    driverMarkerSet.removeWhere((m) => m.markerId.value == 'driver');

    driverMarkerSet.add(Marker(
      markerId: MarkerId('driver'),
      position: newPosition,
      icon: carIcon!,
      rotation: _getUserHeading(),
      infoWindow: InfoWindow(title: 'Местоположение водителя'),
    ));

    notifyListeners();
  }

  void _addDestinationMarker() {
    driverMarkerSet.add(Marker(
      markerId: MarkerId('destination'),
      position: destinationGeo,
      infoWindow: InfoWindow(title: 'Пункт назначения'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ));
    notifyListeners();
  }

  void _updateDriverPosition(LatLng newPosition) {
    _currentDriverPosition = Position(
      latitude: newPosition.latitude,
      longitude: newPosition.longitude,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );

    log("📍 Водитель обновился: ${newPosition.latitude}, ${newPosition.longitude}");

    _initDriverMarker(newPosition);
    _moveCamera();

    // 🔥 Перестраиваем маршрут после каждого обновления позиции!
    createPolylines();

    notifyListeners();
  }

  void _moveCamera() {
    if (controller == null || _currentDriverPosition == null) return;

    controller!.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(_currentDriverPosition!.latitude, _currentDriverPosition!.longitude),
      ),
    );
  }

  Future<void> _loadCarIcon() async {
    carIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(64, 64)),
      'assets/images/car_in_map.png',
    );
    notifyListeners(); // Убедитесь, что иконка загружена перед использованием
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
    polylines.clear();
    notifyListeners();
  }

  Future<void> createPolylines() async {
    try {
      polylinePoints = PolylinePoints();
      if (_currentDriverPosition == null) return;

      final result = await polylinePoints!.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(
            _currentDriverPosition!.latitude,
            _currentDriverPosition!.longitude,
          ),
          destination: PointLatLng(destinationGeo.latitude, destinationGeo.longitude),
          headers: {'Authorization': 'Bearer AIzaSyC45LiL7vakqWnbrhL4xYDkjE2pE0jk5Fw'},
          mode: TravelMode.driving,
        ),
        googleApiKey: 'AIzaSyC45LiL7vakqWnbrhL4xYDkjE2pE0jk5Fw',
      );

      if (result.points.isNotEmpty) {
        polylineCoordinates = result.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();
        _addPolyline();
      }
    } catch (e) {
      log('Error creating polylines: $e');
    }
  }

  void _addPolyline() {
    polylines[PolylineId('route')] = Polyline(
      polylineId: PolylineId('route'),
      color: Colors.blue,
      points: polylineCoordinates,
      width: 4,
    );
    notifyListeners();
  }

  LatLng _getNextRoutePoint() {
    if (polylineCoordinates.isEmpty || _currentDriverPosition == null) {
      return LatLng(0, 0);
    }

    double minDistance = double.infinity;
    int closestIndex = 0;

    for (int i = 0; i < polylineCoordinates.length; i++) {
      double distance = Geolocator.distanceBetween(
        _currentDriverPosition!.latitude,
        _currentDriverPosition!.longitude,
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
      );

      if (distance < minDistance) {
        minDistance = distance;
        closestIndex = i;
      }
    }

    return closestIndex + 1 < polylineCoordinates.length
        ? polylineCoordinates[closestIndex + 1]
        : polylineCoordinates.last;
  }

  double _getUserHeading() {
    if (_currentDriverPosition == null || polylineCoordinates.isEmpty) return 0;

    LatLng nextPoint = _getNextRoutePoint();
    return Geolocator.bearingBetween(
      _currentDriverPosition!.latitude,
      _currentDriverPosition!.longitude,
      nextPoint.latitude,
      nextPoint.longitude,
    );
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
      if (_currentDriverPosition != null) {
        moveCamera(_currentDriverPosition!);
      }
    } catch (e) {
      log('Error getting current location: $e');
    }
  }

  void moveCamera(Position position) {
    controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 18.0,
        ),
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    this.controller = controller;
    log("🗺️ onMapCreated() вызван"); // Проверяем

    initOnMapCreated();
  }

  void closeStream() {
    channel.sink.close();
    ws.close();
    notifyListeners();
  }
}