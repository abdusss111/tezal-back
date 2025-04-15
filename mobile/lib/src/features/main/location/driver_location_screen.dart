import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/request_execution_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:separated_column/separated_column.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class DriverLocationScreen extends StatefulWidget {
  final int request;

  const DriverLocationScreen({
    super.key,
    required this.request,
  });

  @override
  State<DriverLocationScreen> createState() => _DriverLocationScreenState();
}

class _DriverLocationScreenState extends State<DriverLocationScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  static const _useTransformerId = 'useTransformerId';
  late WebSocketChannel channel;
  bool? serviceEnabled;
  PermissionStatus? permissionGranted;
  final location = Location();
  late WebSocket ws;
  late Timer timer;
  LocationData? _currentLocationData = LocationData.fromMap({
    'latitude': 0.0,
    'longitude': 0.0,
  });
  late final _animatedMapController = AnimatedMapController(vsync: this);
  late final StreamController<LocationMarkerPosition> _positionStreamController;
  late AlignOnUpdate _alignPositionOnUpdate;
  late final StreamController<double?> _alignPositionStreamController;

  late LatLng _requestCoordinates;
  // LatLng(widget.request.finishLatitude ?? 0.0,
  // widget.request.finishLongitude ?? 0.0);
  final List<Polyline> _polylines = [];
  late StreamSubscription _streamSubscription;

  bool isFirstTimeBuild = true;

  @override
  void initState() {
    super.initState();
    _initWebSocketConnection();
    initLateParametrs();
    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      _fetchCurrentLocation();
    });
  }

  void initLateParametrs() async {
    _positionStreamController = StreamController.broadcast();
    _alignPositionOnUpdate = AlignOnUpdate.always;
    _alignPositionStreamController = StreamController<double?>.broadcast();
  }

  Future<LocationData?> _currentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    final location = Location();

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
    final loc = await location.getLocation();
    return loc;
  }

  void _initWebSocketConnection() async {
    final token = await TokenService().getToken();
    final headers = {'Authorization': 'Bearer $token'};
    final requestExecution = await RequestExecutionRepository()
        .getRequestExecutionDetail(requestID: widget.request.toString());
    _requestCoordinates = LatLng(requestExecution?.finishLatitude ?? 0,
        requestExecution?.finishLongitude ?? 0);
    final path =
        '${ApiEndPoints.baseUrlForWS}/re/${widget.request}/stream?is_driver=true';
    log(path, name: 'Path');
    ws = await WebSocket.connect(path, headers: headers);
    channel = IOWebSocketChannel(ws);
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

  Future<void> _fetchCurrentLocation() async {
    await _checkPermissions();
    if (isLoading && mounted) {
      AppDialogService.showLoadingDialog(context);
      isLoading = false;
    }
    _currentLocationData = await _currentLocation();

    setState(() {
      _sendLocationData();
      routeFetch();
    });

    _streamSubscription = channel.stream.listen((data) {
      final position = LocationMarkerPosition(
        latitude: jsonDecode(data)['latitude'] ?? 0,
        longitude: jsonDecode(data)['longitude'] ?? 0,
        accuracy: 25,
      );
      _positionStreamController.sink.add(position);
    });
  }

  bool isLoading = true;
  bool isPopCalled = false; // Флаг для отслеживания вызова pop

  Future<void> routeFetch() async {
    if (isLoading) {
      AppDialogService.showLoadingDialog(context);
      isLoading = false;
    }
    try {
      final route = await fetchRoute();
      _addPolylineToMap(route);
    } catch (e) {
      debugPrint('folled to fetch route: $e');
    } finally {
      if (!isPopCalled) {
        if (mounted) {
          context.pop();
        }
        isPopCalled = true;
      }
    }
  }

  Future<Map<String, dynamic>> fetchRoute() async {
    final originLat = _currentLocationData?.latitude;
    final originLng = _currentLocationData?.longitude;

    final destLat = _requestCoordinates.latitude;
    final destLng = _requestCoordinates.longitude;

    final url =
        'https://router.project-osrm.org/route/v1/driving/$originLng,$originLat;$destLng,$destLat?overview=full&geometries=geojson';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      return decodedResponse['routes'][0]['geometry'];
    } else {
      throw Exception('Failed to fetch route');
    }
  }

  void _addPolylineToMap(Map<String, dynamic> geometry) {
    if (geometry.isNotEmpty) {
      List<dynamic> coordinates = geometry['coordinates'];
      List<LatLng> latLngPoints =
          coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
      _polylines.clear();
      setState(() {
        if (isFirstTimeBuild && latLngPoints.isNotEmpty) {
          LatLngBounds bounds =
              LatLngBounds(latLngPoints.first, latLngPoints.last);
          _animatedMapController.mapController.fitCamera(CameraFit.bounds(
              bounds: bounds, minZoom: 8, padding: const EdgeInsets.all(20)));
          isFirstTimeBuild = false;
        }
        _polylines.add(
          Polyline(
            points: latLngPoints,
            color: Colors.red,
            strokeWidth: 3,
          ),
        );
      });
    } else {
      debugPrint('No routes found in response');
    }
  }

  @override
  void dispose() {
    channel.sink.close();

    ws.close();
    timer.cancel();

    _positionStreamController.close();
    _alignPositionStreamController.close();
    _animatedMapController.dispose();
    _streamSubscription.cancel();

    super.dispose();
  }

  void _sendLocationData() {
    double? newLatitude = _currentLocationData?.latitude;
    double? newLongitude = _currentLocationData?.longitude;
    final date =
        DateTimeUtils().dateFormatWithyyyyMMddTHHmmssSSSSSSSSS(DateTime.now());
    log(newLatitude.toString(), name: 'nw lat');
    log(newLongitude.toString(), name: 'nw low');
    log(date.toString(), name: 'new data');

    final locationData = jsonEncode({
      'latitude': newLatitude,
      'longitude': newLongitude,
      'created_at': date
    });

    try {
      channel.sink.add(locationData);
      debugPrint('Location data sent successfully');

      debugPrint('add');
    } on Exception catch (e) {
      debugPrint('Error sending location data: ${e.toString()}');
    }

    channel.sink.done.then((_) {
      debugPrint('WebSocket sink is closed. Unable to send data.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Карта'),
      ),
      body: FutureBuilder<LocationData?>(
          future: _currentLocation(),
          builder: (context, AsyncSnapshot<LocationData?> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        FlutterMap(
                          mapController: _animatedMapController.mapController,
                          options: MapOptions(
                            initialCenter: const LatLng(0, 0),
                            initialZoom: 12,
                            minZoom: 11,
                            maxZoom: 19,
                            onPositionChanged:
                                (MapCamera mapCamera, bool hasGesture) {
                              if (hasGesture &&
                                  _alignPositionOnUpdate !=
                                      AlignOnUpdate.never) {
                                setState(
                                  () => _alignPositionOnUpdate =
                                      AlignOnUpdate.never,
                                );
                              }
                            },
                          ),
                          children: [
                            TileLayer(
                              tileUpdateTransformer:
                                  _animatedMoveTileUpdateTransformer,
                              tileProvider: CancellableNetworkTileProvider(),
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName:
                                  'com.example.flutter_map_example',
                              maxZoom: 19,
                            ),
                            CurrentLocationLayer(
                              alignPositionStream:
                                  _alignPositionStreamController.stream,
                              alignPositionOnUpdate: _alignPositionOnUpdate,
                              style: LocationMarkerStyle(
                                marker: DefaultLocationMarker(
                                  color: Theme.of(context).primaryColor,
                                  child: const Icon(
                                    size: 20,
                                    Icons.directions_car,
                                    color: Colors.white,
                                  ),
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
                                  child: Icon(
                                    Icons.location_on,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                markerSize: const Size.square(30),
                                accuracyCircleColor:
                                    Colors.red.withOpacity(0.5),
                                headingSectorColor: Colors.red.withOpacity(0.8),
                                headingSectorRadius: 0,
                                showHeadingSector: false,
                                showAccuracyCircle: false,
                              ),
                              position: LocationMarkerPosition(
                                latitude: _requestCoordinates.latitude,
                                longitude: _requestCoordinates.longitude,
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
                                      (BuildContext context, int index) {
                                    return const SizedBox(height: 8);
                                  },
                                  children: [
                                    FloatingActionButton(
                                      mini: true,
                                      onPressed: () => _animatedMapController
                                          .animatedZoomIn(),
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
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(
                                height: 8,
                              );
                            },
                            children: [
                              FloatingActionButton(
                                heroTag: 'driverLocationScreen',
                                mini: true,
                                onPressed: () {
                                  setState(
                                    () => _alignPositionOnUpdate =
                                        AlignOnUpdate.always,
                                  );
                                  _alignPositionStreamController.add(17);
                                },
                                child: Transform.rotate(
                                  angle: 45 * pi / 180,
                                  child: const Icon(
                                    Icons.navigation_sharp,
                                    size: 20,
                                  ),
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
                      child: Text(
                        'Вы в пути',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

final _animatedMoveTileUpdateTransformer = TileUpdateTransformer.fromHandlers(
  handleData: (updateEvent, sink) {
    final id = AnimationId.fromMapEvent(updateEvent.mapEvent);

    if (id == null) return sink.add(updateEvent);
    if (id.customId != _DriverLocationScreenState._useTransformerId) {
      if (id.moveId == AnimatedMoveId.started) {
        debugPrint('TileUpdateTransformer disabled, using default behaviour.');
      }
      return sink.add(updateEvent);
    }

    switch (id.moveId) {
      case AnimatedMoveId.started:
        debugPrint('Loading tiles at animation destination.');
        sink.add(
          updateEvent.loadOnly(
            loadCenterOverride: id.destLocation,
            loadZoomOverride: id.destZoom,
          ),
        );
        break;
      case AnimatedMoveId.inProgress:
        break;
      case AnimatedMoveId.finished:
        debugPrint('Pruning tiles after animated movement.');
        sink.add(updateEvent.pruneOnly());
        break;
    }
  },
);
