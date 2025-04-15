import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/request_execution_list/request_execution.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/request_execution_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:web_socket_channel/io.dart';

class ClientLocationController extends AppSafeChangeNotifier {
  late final RequestExecution? requestExecution;
  late WebSocket ws;
  late IOWebSocketChannel channel;
  late StreamSubscription streamSubscription;
  LocationData? currentDriverLocationData;
  late Timer timer;

  final List<Polyline> _polylines = [];

  late final StreamController<LocationData?> _locationStreamController;
  LocationMarkerPosition locationMarkerPosition =
      LocationMarkerPosition(latitude: 0, longitude: 0, accuracy: 0);

  final location = Location();

  bool _isLoading = true;

  List<Polyline> get polylines => _polylines;
  bool get isLoading => _isLoading;

  final int requestID;

  ClientLocationController({required this.requestID});

  Future<void> getRequestExecution() async {
    requestExecution = await RequestExecutionRepository()
        .getRequestExecutionDetail(requestID: requestID.toString());
    _initWebSocketConnection();
  }

  Future<void> _initWebSocketConnection() async {
    final token = await TokenService().getToken();
    final headers = {'Authorization': 'Bearer $token'};
    ws = await WebSocket.connect(
        '${ApiEndPoints.baseUrlForWS}/re/$requestID/stream?isDriver=false',
        headers: headers);
    channel = IOWebSocketChannel(ws);
  }

  void handleMessage(dynamic message) {
    final Map<String, dynamic> data = jsonDecode(message);
    final driverLocation = LocationData.fromMap(data);
    _locationStreamController.add(driverLocation);
    locationMarkerPosition = LocationMarkerPosition(
        latitude: driverLocation.latitude ?? 0,
        longitude: driverLocation.longitude ?? 0,
        accuracy: driverLocation.accuracy ?? 0);

    currentDriverLocationData = driverLocation;
    _updatePolylines();
  }

  Future<void> _checkPermissions() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  void _updatePolylines() async {
    if (currentDriverLocationData != null) {
      final originLat = currentDriverLocationData!.latitude.toString();
      final originLng = currentDriverLocationData!.longitude.toString();
      final destLat = currentDriverLocationData!.latitude.toString();
      final destLng = currentDriverLocationData!.longitude.toString();
      try {
        final route = await fetchRoute(originLat, originLng, destLat, destLng);

        _polylines.clear();
        _polylines.add(
          Polyline(
            points: route,
            color: Colors.red,
            strokeWidth: 3,
          ),
        );
        notifyListeners();
      } catch (e) {
        debugPrint('Failed to fetch route: $e');
      }
    }
  }

  Future<List<LatLng>> fetchRoute(
    String originLat,
    String originLng,
    String destLat,
    String destLng,
  ) async {
    final url =
        'https://router.project-osrm.org/route/v1/driving/$originLng,$originLat;$destLng,$destLat?overview=full&geometries=geojson';
    final response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final coordinates =
          decodedResponse['routes'][0]['geometry']['coordinates'];
      return coordinates
          .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
          .toList();
    } else {
      throw Exception('Failed to fetch route');
    }
  }
}
