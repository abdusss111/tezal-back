import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/request_execution_repository.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:separated_column/separated_column.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class NewClientLocationScreen extends StatefulWidget {
  final int requestID;

  const NewClientLocationScreen({
    super.key,
    required this.requestID,
  });

  @override
  State<NewClientLocationScreen> createState() => _ClientLocationScreenState();
}

class _ClientLocationScreenState extends State<NewClientLocationScreen>
    with TickerProviderStateMixin {
  LocationData? _currentDriverLocationData;
  final List<Polyline> _polylines = [];
  var _locationMarkerPosition =
      LocationMarkerPosition(latitude: 0, longitude: 0, accuracy: 0);

  late final StreamController<LocationData?> _locationStreamController;

  late final _animatedMapController = AnimatedMapController(vsync: this);
  late StreamSubscription _streamSubscription;
  late WebSocket ws;
  late Timer timer;
  late WebSocketChannel channel;
  late AlignOnUpdate _alignPositionOnUpdate = AlignOnUpdate.always;

  late final LatLng requestCoordinates;
  bool isFirstTimeBuild = true;
  // LatLng(widget.finishLatitude, widget.finishLongitude);
  @override
  void initState() {
    super.initState();
    _locationStreamController = StreamController<LocationData?>.broadcast();

    initAllData();
  }

  Future<void> initAllData() async {
    await _initWebSocketConnection();

    _streamSubscription = channel.stream.listen((message) {
      handleMessage(message);
    });
  }

  Future<void> _initWebSocketConnection() async {
    final token = await TokenService().getToken();
    final headers = {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJDTElFTlQiLCJleHAiOjE3MzE3OTEwNjksImlhdCI6MTcyOTE2MTMyMywiaXNzIjoiZXFzaGFyZSIsIm5iZiI6MTcyOTE2MTMyMywic3ViIjoiMTY0In0.8jrCd_k8As-J0jI7hC5out2X3Dw2jVLgS7t8GHnM_C0'
    };
    final path =
        '${ApiEndPoints.baseUrlForWS}/re/${widget.requestID}/stream?isDriver=false';

    try {
      ws = await WebSocket.connect(path, headers: headers);
      channel = IOWebSocketChannel(ws);
      final requestExecution = await RequestExecutionRepository()
          .getRequestExecutionDetail(requestID: widget.requestID.toString());
      requestCoordinates = LatLng(requestExecution?.finishLatitude ?? 0,
          requestExecution?.finishLongitude ?? 0);
    } catch (e) {
      log(e.toString(), name: 'Error on connect ws : ');
    }
  }

  void handleMessage(dynamic message) {
    final Map<String, dynamic> data = jsonDecode(message);
    final driverLocation = LocationData.fromMap(data);
    _locationStreamController.add(driverLocation);
    _locationMarkerPosition = LocationMarkerPosition(
        latitude: driverLocation.latitude ?? 0,
        longitude: driverLocation.longitude ?? 0,
        accuracy: driverLocation.accuracy ?? 0);

    setState(() {
      _currentDriverLocationData = driverLocation;
      _updatePolylines();
    });
  }

  void _updatePolylines() async {
    if (_currentDriverLocationData != null) {
      final originLat = _currentDriverLocationData!.latitude.toString();
      final originLng = _currentDriverLocationData!.longitude.toString();
      final destLat = requestCoordinates.latitude.toString();
      final destLng = requestCoordinates.longitude.toString();
      try {
        final route = await fetchRoute(originLat, originLng, destLat, destLng);
        setState(() {
          if (isFirstTimeBuild && route.isNotEmpty) {
            LatLngBounds bounds = LatLngBounds(route.first, route.last);
            _animatedMapController.mapController
                .fitCamera(CameraFit.bounds(bounds: bounds));
            isFirstTimeBuild = false;
          }
          _polylines.clear();
          _polylines.add(
            Polyline(
              points: route,
              color: Colors.red,
              strokeWidth: 3,
            ),
          );
        });
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

  @override
  void dispose() {
    _locationStreamController.close();

    channel.sink.close();
    _animatedMapController.dispose();
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Маршрут водителя'),
      ),
      body: StreamBuilder<LocationData?>(
        stream: _locationStreamController.stream,
        builder: (BuildContext context, AsyncSnapshot<LocationData?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final driverLocation = snapshot.data;

            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      FlutterMap(
                        mapController: _animatedMapController.mapController,
                        options: MapOptions(
                          initialCenter: LatLng(
                            _currentDriverLocationData?.latitude ??
                                driverLocation?.latitude ??
                                0.0,
                            _currentDriverLocationData?.longitude ??
                                driverLocation?.longitude ??
                                0.0,
                          ),
                          initialZoom: 12,
                          minZoom: 11,
                          maxZoom: 19,
                          onPositionChanged:
                              (MapCamera mapCamera, bool hasGesture) {
                            if (hasGesture &&
                                _alignPositionOnUpdate != AlignOnUpdate.never) {
                              setState(() =>
                                  _alignPositionOnUpdate = AlignOnUpdate.never);
                            }
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName:
                                'com.example.flutter_map_example',
                            maxZoom: 19,
                          ),
                          LocationMarkerLayer(
                            position: _locationMarkerPosition,
                            style: LocationMarkerStyle(
                              marker: DefaultLocationMarker(
                                color: Theme.of(context).primaryColor,
                                child: const Icon(
                                    size: 20,
                                    Icons.directions_car,
                                    color: Colors.white),
                              ),
                              markerSize: const Size.square(30),
                              accuracyCircleColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              headingSectorColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.9),
                              headingSectorRadius: 120,
                              showAccuracyCircle: true,
                              showHeadingSector: true,
                            ),
                          ),
                          AnimatedLocationMarkerLayer(
                            style: LocationMarkerStyle(
                              marker: const DefaultLocationMarker(
                                color: Colors.red,
                                child: Icon(Icons.location_on,
                                    size: 20, color: Colors.white),
                              ),
                              markerSize: const Size.square(30),
                              accuracyCircleColor: Colors.red.withOpacity(0.5),
                              headingSectorColor: Colors.red.withOpacity(0.8),
                              headingSectorRadius: 0,
                              showHeadingSector: false,
                              showAccuracyCircle: false,
                            ),
                            position: LocationMarkerPosition(
                              latitude: requestCoordinates.latitude,
                              longitude: requestCoordinates.longitude,
                              accuracy: 25,
                            ),
                          ),
                          PolylineLayer(polylines: _polylines),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: SeparatedColumn(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const SizedBox(height: 8),
                                children: [
                                  FloatingActionButton(
                                    mini: true,
                                    onPressed: () =>
                                        _animatedMapController.animatedZoomIn(),
                                    tooltip: 'Zoom in',
                                    child: const Icon(Icons.add),
                                  ),
                                  FloatingActionButton(
                                    mini: true,
                                    onPressed: () => _animatedMapController
                                        .animatedZoomOut(),
                                    tooltip: 'Zoom out',
                                    child: const Icon(Icons.remove),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Positioned(
                        bottom: 10,
                        right: 5,
                        child: SeparatedColumn(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 8),
                          children: [
                            FloatingActionButton(
                              heroTag: 'driverLocationScreen',
                              mini: true,
                              onPressed: () {
                                if (_currentDriverLocationData != null) {
                                  final latLng = LatLng(
                                    _currentDriverLocationData!.latitude!,
                                    _currentDriverLocationData!.longitude!,
                                  );
                                  _animatedMapController.mapController
                                      .move(latLng, 17.0);
                                  setState(() {});
                                }
                              },
                              child: Transform.rotate(
                                angle: 45 * pi / 180,
                                child: const Icon(Icons.navigation_sharp,
                                    size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 100,
                  child: Center(
                    child: Text('Водитель в пути',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('Нет данных о местоположении'));
          }
        },
      ),
    );
  }
}
