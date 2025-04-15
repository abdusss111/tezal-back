// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:eqshare_mobile/src/features/requests/data/repository/request_execution_repository.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_map_animations/flutter_map_animations.dart';
// import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
// import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
// import 'package:go_router/go_router.dart';
// import 'package:http/http.dart' as http;
// import 'package:latlong2/latlong.dart';
// import 'package:location/location.dart';
// import 'package:separated_column/separated_column.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// import '../../../core/data/services/storage/token_provider_service.dart';
// import '../../requests/data/models/request_execution_list/request_execution.dart';

// class ClientLocationScreen extends StatefulWidget {
//   final  int requestID;

//   const ClientLocationScreen({
//     super.key,
//     required this.requestID,
//   });

//   @override
//   State<ClientLocationScreen> createState() => _ClientLocationScreenState();
// }

// class _ClientLocationScreenState extends State<ClientLocationScreen>
//     with TickerProviderStateMixin {
//   bool? serviceEnabled;
//   PermissionStatus? permissionGranted;
//   final location = Location();
//   static const _useTransformerId = 'useTransformerId';
//   WebSocketChannel? channel;
//   late WebSocket ws;
//   late Timer timer;
//   late final _animatedMapController = AnimatedMapController(vsync: this);
//   StreamController<LocationMarkerPosition>? _positionStreamController;
//   StreamController<LocationMarkerPosition>? _currentPositionStreamController;
//   double _currentLat = 0;
//   double _currentLng = 0;
//   AlignOnUpdate? _alignPositionOnUpdate;
//   StreamController<double?>? _alignPositionStreamController;
//   final List<Polyline> _polylines = [];

//   get _requestCoordinates => LatLng(widget.request.finishLatitude ?? 0.0,
//       widget.request.finishLongitude ?? 0.0);

//   late StreamSubscription? _streamSubscription;
//   late LocationMarkerPosition _currentDriverPosition;
//   late Future<RequestExecution?> getRequestExecution;

//   @override
//   void initState() {
//     getRequestExecution = RequestExecutionRepository().getRequestExecutionDetail(requestID: widget.requestID.toString());
//     try {
//       _initWebSocketConnection();
//       _fetchCurrentLocation();

//       _positionStreamController = StreamController<LocationMarkerPosition>();
//       _alignPositionOnUpdate = AlignOnUpdate.always;
//       _alignPositionStreamController = StreamController<double?>();

//       _currentDriverPosition =
//           LocationMarkerPosition(latitude: 0, longitude: 0, accuracy: 1);

//       _streamSubscription =
//           _positionStreamController?.stream.listen((snapshot) {
//         LocationMarkerPosition position = snapshot;
//         debugPrint(snapshot.toString());

//         setState(() {
//           _currentDriverPosition = position;
//           final originLat = _requestCoordinates.latitude.toString();
//           final originLng = _requestCoordinates.longitude.toString();
//           final destLat = _currentDriverPosition.latitude.toString();
//           final destLng = _currentDriverPosition.longitude.toString();
//           routeFetch(originLat, originLng, destLat, destLng);
//         });
//       });

//       _currentDriverPosition = LocationMarkerPosition(
//           latitude: _currentDriverPosition.latitude,
//           longitude: _currentDriverPosition.longitude,
//           accuracy: 1);

//       timer = Timer.periodic(const Duration(seconds: 3), (_) {
//         _fetchCurrentLocation();
//       });
//     } catch (e) {
//       print(e);
//     }
//     super.initState();
//   }

//   bool isLoading = false;
//   bool isPopCalled = false;

//   Future<LocationData?> _currentLocation() async {
//     final location = Location();
//     final loc = await location.getLocation();
//     print('loc.latitude:${loc.latitude}');
//     print('loc.longitude:${loc.longitude}');

//     final _prevLatitude = _currentLat;
//     final _prevLongitude = _currentLng;
//     _currentLat = loc.latitude ?? 0;
//     _currentLng = loc.longitude ?? 0;
//     if (_prevLongitude != _currentLng && _prevLatitude != _currentLat) {
//       if (_currentPositionStreamController?.isClosed == false) {
//         setState(() {
//           _currentPositionStreamController = StreamController()
//             ..add(
//               LocationMarkerPosition(
//                 latitude: _currentLat,
//                 longitude: _currentLng,
//                 accuracy: 0,
//               ),
//             );
//         });
//       }
//     }
//     return loc;
//   }

//   Future<void> _checkPermissions() async {
//     serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled!) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled!) {
//         return;
//       }
//     }

//     permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }
//   }

//   Future<void> _fetchCurrentLocation() async {
//     await _checkPermissions();

//     try {
//       setState(() {
//         isLoading = true;
//       });

//       final locationData = await _currentLocation();

//       setState(() {
//         if (_positionStreamController?.isClosed == false) {
//           _positionStreamController?.addStream(channel!.stream.map((data) {
//             return LocationMarkerPosition(
//               latitude: jsonDecode(data)['latitude'] ?? 0,
//               longitude: jsonDecode(data)['longitude'] ?? 0,
//               accuracy: 25,
//             );
//           }));
//         }
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error fetching location: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void _initWebSocketConnection() async {
//     final token = await TokenService().getToken();
//     final headers = {'Authorization': 'Bearer $token'};
//     if (token == null) {
//       return;
//     }
//     final payload = TokenService().extractPayloadFromToken(token);
//     String isDriver;
//     debugPrint('aud: ${payload.aud}');
//     if (payload.aud == 'OWNER') {
//       isDriver = '?is_driver=false';
//     } else {
//       isDriver = '?is_driver=false';
//     }
//     ws = await WebSocket.connect(
//         'ws://206.189.109.61:8777/re/${widget.requestID}/stream$isDriver',
//         headers: headers);
//     channel = IOWebSocketChannel(ws);
//   }

//   Future<void> routeFetch(
//     String originLat,
//     String originLng,
//     String destLat,
//     String destLng,
//   ) async {
//     try {
//       setState(() {
//         isLoading = true;
//       });

//       final route = await fetchRoute(originLat, originLng, destLat, destLng);
//       _addPolylineToMap(route);
//     } catch (e) {
//       debugPrint('Failed to fetch route: $e');
//     } finally {
//       if (!isPopCalled) {
//         if (mounted) {
//           // Navigator.of(context).pop();
//           context.pop();
//         }
//         isPopCalled = true;
//       }
//     }
//   }

//   Future<Map<String, dynamic>> fetchRoute(
//     String originLat,
//     String originLng,
//     String destLat,
//     String destLng,
//   ) async {
//     final url =
//         'https://router.project-osrm.org/route/v1/driving/$destLng,$destLat;$originLng,$originLat?overview=full&geometries=geojson';

//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       final decodedResponse = jsonDecode(response.body);
//       return decodedResponse['routes'][0]['geometry'];
//     } else {
//       throw Exception('Failed to fetch route');
//     }
//   }

//   void _addPolylineToMap(Map<String, dynamic> geometry) {
//     if (geometry.isNotEmpty) {
//       List<dynamic> coordinates = geometry['coordinates'];
//       List<LatLng> latLngPoints =
//           coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
//       _polylines.clear();
//       _polylines.add(
//         Polyline(
//           points: latLngPoints,
//           color: Colors.redAccent,
//           strokeWidth: 3,
//         ),
//       );
//     } else {
//       debugPrint('No routes found in response');
//     }
//   }

//   @override
//   void dispose() {
//     timer.cancel();
//     channel?.sink.close();
//     _animatedMapController.dispose();
//     if (_positionStreamController?.isClosed == false) {
//       _positionStreamController?.close();
//     }
//     if (_currentPositionStreamController?.isClosed == false) {
//       _currentPositionStreamController?.close();
//     }
//     if (_alignPositionStreamController?.isClosed == false) {
//       _alignPositionStreamController?.close();
//     }
//     _streamSubscription?.cancel();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Карта'),
//       ),
//       body: FutureBuilder<RequestExecution?>(
//         future: getRequestExecution,
//         builder: (context,snapshot){
//           if(snapshot.connectionState == ConnectionState.waiting){
//             return const Center(child:  CircularProgressIndicator());
//           }else if(snapshot.hasError){
//             return const Center(child: Text('Попробуйте позже, что то пошло не так') );
            
//           }
//           return Column(
//             children: [
//               Expanded(
//                 child: Stack(
//                   children: [
//                     FutureBuilder(
//                         future: _currentLocation(),
//                         builder: (BuildContext context,
//                             AsyncSnapshot<LocationData?> snapshot) {
//                           if (snapshot.hasData) {
//                             return FlutterMap(
//                               mapController: _animatedMapController.mapController,
//                               options: MapOptions(
//                                 initialCenter: LatLng(_requestCoordinates.latitude,
//                                     _requestCoordinates.longitude),
//                                 initialZoom: 12,
//                                 minZoom: 11,
//                                 maxZoom: 19,
//                                 onPositionChanged:
//                                     (MapPosition position, bool hasGesture) {
//                                   if (hasGesture &&
//                                       _alignPositionOnUpdate !=
//                                           AlignOnUpdate.never) {
//                                     setState(
//                                       () {
//                                         _alignPositionOnUpdate =
//                                             AlignOnUpdate.never;
//                                       },
//                                     );
//                                   }
//                                 },
//                               ),
//                               children: [
//                                 TileLayer(
//                                   tileUpdateTransformer:
//                                       _animatedMoveTileUpdateTransformer,
//                                   tileProvider: CancellableNetworkTileProvider(),
//                                   urlTemplate:
//                                       'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                                   userAgentPackageName:
//                                       'com.example.flutter_map_example',
//                                   maxZoom: 19,
//                                 ),
//                                 PolylineLayer(polylines: _polylines),
//                                 AnimatedLocationMarkerLayer(
//                                   style: LocationMarkerStyle(
//                                     marker: const DefaultLocationMarker(
//                                       color: Colors.red,
//                                       child: Icon(
//                                         size: 20,
//                                         Icons.location_on,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     markerSize: const Size.square(30),
//                                     accuracyCircleColor:
//                                         Colors.red.withOpacity(0.5),
//                                     headingSectorColor: Colors.red.withOpacity(0.8),
//                                     headingSectorRadius: 0,
//                                     showHeadingSector: false,
//                                     showAccuracyCircle: false,
//                                   ),
//                                   position: LocationMarkerPosition(
//                                     latitude: _requestCoordinates.latitude,
//                                     longitude: _requestCoordinates.longitude,
//                                     accuracy: 25,
//                                   ),
//                                 ),
//                                 CurrentLocationLayer(
//                                   positionStream:
//                                       _currentPositionStreamController?.stream,
//                                   indicators: const LocationMarkerIndicators(
//                                     serviceDisabled: Align(
//                                       alignment: Alignment.topCenter,
//                                       child: SizedBox(
//                                         width: double.infinity,
//                                         child: ColoredBox(
//                                           color: Colors.red,
//                                           child: Padding(
//                                             padding: EdgeInsets.all(8.0),
//                                             child: Text(
//                                               'Пожалуйста, включите службу определения местоположения.',
//                                               textAlign: TextAlign.center,
//                                               style: TextStyle(
//                                                   fontSize: 18,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   alignPositionStream:
//                                       _alignPositionStreamController?.stream,
//                                   alignPositionOnUpdate: _alignPositionOnUpdate,
//                                   style: LocationMarkerStyle(
//                                     marker: DefaultLocationMarker(
//                                       color: Theme.of(context).primaryColor,
//                                     ),
//                                     markerSize: const Size.square(20),
//                                     accuracyCircleColor: Theme.of(context)
//                                         .primaryColor
//                                         .withOpacity(0.2),
//                                     headingSectorColor: Theme.of(context)
//                                         .primaryColor
//                                         .withOpacity(0.8),
//                                     headingSectorRadius: 100,
//                                   ),
//                                 ),
//                                 AnimatedLocationMarkerLayer(
//                                   style: LocationMarkerStyle(
//                                     markerDirection: MarkerDirection.north,
//                                     marker: const Icon(
//                                       size: 30,
//                                       CupertinoIcons.car_detailed,
//                                       color: Colors.black,
//                                     ),
//                                     markerSize: const Size.square(35),
//                                     accuracyCircleColor:
//                                         Colors.green.withOpacity(0.5),
//                                     headingSectorColor:
//                                         Colors.green.withOpacity(0.8),
//                                     headingSectorRadius: 0,
//                                     showHeadingSector: false,
//                                     showAccuracyCircle: false,
//                                   ),
//                                   position: _currentDriverPosition,
//                                 ),
//                                 Align(
//                                   alignment: Alignment.centerRight,
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(right: 5.0),
//                                     child: SeparatedColumn(
//                                       mainAxisSize: MainAxisSize.min,
//                                       crossAxisAlignment: CrossAxisAlignment.end,
//                                       separatorBuilder:
//                                           (BuildContext context, int index) {
//                                         return const SizedBox(height: 8);
//                                       },
//                                       children: [
//                                         FloatingActionButton(
//                                           mini: true,
//                                           onPressed: () => _animatedMapController
//                                               .animatedZoomIn(),
//                                           tooltip: 'Zoom in',
//                                           child: const Icon(Icons.add),
//                                           heroTag: 'clientLocationScreen1',
//                                         ),
//                                         FloatingActionButton(
//                                           mini: true,
//                                           onPressed: () => _animatedMapController
//                                               .animatedZoomOut(),
//                                           tooltip: 'Zoom out',
//                                           child: const Icon(Icons.remove),
//                                           heroTag: 'clientLocationScreen2',
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             );
//                           } else {
//                             return const Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           }
//                         }),
//                     Positioned(
//                       bottom: 10,
//                       right: 5,
//                       child: SeparatedColumn(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         separatorBuilder: (BuildContext context, int index) {
//                           return const SizedBox(
//                             height: 8,
//                           );
//                         },
//                         children: [
//                           FloatingActionButton(
//                             heroTag: 'clientLocationScreen3',
//                             mini: true,
//                             onPressed: () {
//                               setState(
//                                 () {
//                                   _alignPositionOnUpdate = AlignOnUpdate.always;
//                                 },
//                               );
//                               _alignPositionStreamController?.add(17);
//                             },
//                             child: Transform.rotate(
//                               angle: 45 * pi / 180,
//                               child: const Icon(
//                                 Icons.navigation_sharp,
//                                 size: 20,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 100,
//                 child: Center(
//                   child: Text(
//                     'Водитель в пути',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         }
//       ),
//     );
//   }
// }

// final _animatedMoveTileUpdateTransformer = TileUpdateTransformer.fromHandlers(
//   handleData: (updateEvent, sink) {
//     final id = AnimationId.fromMapEvent(updateEvent.mapEvent);

//     if (id == null) return sink.add(updateEvent);
//     if (id.customId != _ClientLocationScreenState._useTransformerId) {
//       if (id.moveId == AnimatedMoveId.started) {
//         debugPrint('TileUpdateTransformer disabled, using default behaviour.');
//       }
//       return sink.add(updateEvent);
//     }

//     switch (id.moveId) {
//       case AnimatedMoveId.started:
//         debugPrint('Loading tiles at animation destination.');
//         sink.add(
//           updateEvent.loadOnly(
//             loadCenterOverride: id.destLocation,
//             loadZoomOverride: id.destZoom,
//           ),
//         );
//         break;
//       case AnimatedMoveId.inProgress:
//         break;
//       case AnimatedMoveId.finished:
//         debugPrint('Pruning tiles after animated movement.');
//         sink.add(updateEvent.pruneOnly());
//         break;
//     }
//   },
// );
