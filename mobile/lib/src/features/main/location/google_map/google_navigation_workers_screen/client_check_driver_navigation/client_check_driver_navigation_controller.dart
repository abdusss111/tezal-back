import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:eqshare_mobile/src/core/data/services/network/api_client/user_profile_api_client.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';

class UserLocation {
  final double currentLatitude;
  final double currentLongitude;

  UserLocation({required this.currentLatitude, required this.currentLongitude});

  static String toMap(UserLocation e) {
    return jsonEncode({
      'latitude': e.currentLatitude,
      'longitude': e.currentLongitude,
      'created_at': DateTime.now().toIso8601String(),
    });
  }
}

class GoogleNavigationWorkersScreenController extends AppSafeChangeNotifier {
  GoogleMapController? controller;
  Position? _currentPosition;
  final LatLng destinationGeo;
  final String currentReID;
  final String workerId;
  late WebSocket ws;

  late IOWebSocketChannel channel;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  final _workersApiClient = UserProfileApiClient();
  Map<MarkerId, Marker> markers = {}; // Map to store driver markers

  GoogleNavigationWorkersScreenController({
    required this.currentReID,
    required this.destinationGeo,
    required this.workerId,
  }) {
    init();
  }

  void init() async {
    await checkPermission();
    await initWebSocket();
    await getLocations();
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
  Future<void> checkPermission() async {
    final permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.always &&
        permission != LocationPermission.whileInUse) {
      log('Location permission denied');
    }
  }

  Future<void> getLocations() async {
    final token = await TokenService().getToken();
    if (token == null) return;

    final payload = TokenService().extractPayloadFromToken(token);
    final workersResponse = await _workersApiClient.getWorkersLocations(
      payload.sub ?? '1',
    );
    print('WORKERS: $workersResponse');
    if (workersResponse == null || workersResponse.isEmpty) {
      print("No driver locations available.");
      return;
    }

    final workersResponse2 = await _workersApiClient.getMyWorkers(
      payload.sub ?? '1',
    );

    // Process each driver in workersResponse
    if (workersResponse is List) {
      for (var driver in workersResponse) {
        if (driver is Map<String, dynamic> && driver['is_location_enabled']) {
          final driverId = driver['driver_id']; // Expected to be an int
          final name = driver['name'];
          final lastName = driver['last_name'];
          final latitude = driver['latitude'];
          final longitude = driver['longitude'];
          final time = driver['time'];

          // Debugging type information
          print('workerId: $workerId, type: ${workerId.runtimeType}');
          print('driverId: $driverId, type: ${driverId.runtimeType}');

          // Safely parse workerId to an int
          int? parsedWorkerId = int.tryParse(workerId);

          // Check if all required fields are present
          if (driverId != null &&
              name != null &&
              lastName != null &&
              latitude != null &&
              longitude != null) {
            if (workerId.isNotEmpty) {
              // Compare parsedWorkerId with driverId
              if (parsedWorkerId != null && parsedWorkerId == driverId) {
                addOrUpdateDriverMarker(
                    driverId,
                    name,
                    lastName,
                    latitude,
                    longitude,
                    findUrlImage(driverId, workersResponse2),
                    time
                );
                break; // Exit loop after adding the specific driver's marker
              }
            } else {
              // Add all drivers if workerId is empty
              addOrUpdateDriverMarker(
                  driverId,
                  name,
                  lastName,
                  latitude,
                  longitude,
                  findUrlImage(driverId, workersResponse2),
                  time
              );
            }
          } else {
            print("Invalid driver data: $driver");
          }
        } else {
          print("Unexpected format in workersResponse: $driver");
        }
      }
    } else {
      print("workersResponse is not a list as expected: $workersResponse");
    }
    centerMap();
    notifyListeners(); // Notify UI to update map markers
  }

  Future<Uint8List> resizeImage(Uint8List imageData, int targetWidth) async {
    final codec =
    await ui.instantiateImageCodec(imageData, targetWidth: targetWidth);
    final frame = await codec.getNextFrame();
    final resizedImage =
    await frame.image.toByteData(format: ui.ImageByteFormat.png);
    return resizedImage!.buffer.asUint8List();
  }

  Future<BitmapDescriptor> _getMarkerIconFromUrl(String url) async {
    try {
      // Download the image from the URL
      print('Downloading image from URL: $url');
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Uint8List imageBytes = response.bodyBytes;

        // Resize the image
        imageBytes =
        await resizeImage(imageBytes, 100); // Resize to 100px width

        // Debug: Print the image size
        print('Image downloaded successfully. Bytes: ${imageBytes.length}');
        return BitmapDescriptor.fromBytes(imageBytes);
      } else {
        throw Exception(
            'Failed to load marker image from URL. Status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching marker icon: $e');
      return BitmapDescriptor.defaultMarker; // Fallback to default marker
    }
  }

  void centerMap() {
    if (markers.isEmpty) return;

    if (markers.length == 1) {
      // Если только один водитель, центрируйте карту на его местоположении
      final marker = markers.values.first;
      controller?.animateCamera(
        CameraUpdate.newLatLng(marker.position),
      );
    } else {
      // Если водителей больше одного, охватите всех
      final bounds = _calculateBounds();
      controller?.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50), // Padding 50px
      );
    }
  }

  LatLngBounds _calculateBounds() {
    double? minLat, maxLat, minLng, maxLng;

    for (var marker in markers.values) {
      final position = marker.position;
      minLat = (minLat == null || position.latitude < minLat) ? position.latitude : minLat;
      maxLat = (maxLat == null || position.latitude > maxLat) ? position.latitude : maxLat;
      minLng = (minLng == null || position.longitude < minLng) ? position.longitude : minLng;
      maxLng = (maxLng == null || position.longitude > maxLng) ? position.longitude : maxLng;
    }

    return LatLngBounds(
      southwest: LatLng(minLat!, minLng!),
      northeast: LatLng(maxLat!, maxLng!),
    );
  }

  Future<BitmapDescriptor> createBeautifulMarker(String? customUrlImage, String label) async {
    try {
      const double markerWidth = 200; // Marker width in pixels
      const double markerHeight = 181; // Marker height in pixels
      const double circleDiameter = 150; // Circle diameter in pixels
      const double iconSize = 100; // Icon size in pixels
      const double pinHeight = 50; // Height of the pin's narrow section

      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      final Paint paint = Paint();

      // Draw circular top part of the marker
      paint.color = Colors.orange; // Orange circular background
      canvas.drawCircle(
        Offset(markerWidth / 2, circleDiameter / 2), // Centered at the top
        circleDiameter / 2,
        paint,
      );

      // Draw the "pin" shape (narrow bottom)
      final Path pinPath = Path();
      pinPath.moveTo(markerWidth / 2, markerHeight); // Bottom center
      pinPath.lineTo((markerWidth / 2) - 50, markerHeight - pinHeight); // Bottom-left
      pinPath.lineTo((markerWidth / 2) + 50, markerHeight - pinHeight); // Bottom-right
      pinPath.close();
      paint.color = Colors.orange;
      canvas.drawPath(pinPath, paint);

      // Add a white circular inner section
      paint.color = Colors.white; // White circle inside
      canvas.drawCircle(
        Offset(markerWidth / 2, circleDiameter / 2),
        circleDiameter / 2.5,
        paint,
      );

      if (customUrlImage != null) {
        // If URL image is provided, download and draw the image
        final response = await http.get(Uri.parse(customUrlImage));
        if (response.statusCode == 200) {
          final Uint8List imageBytes = response.bodyBytes;

          // Decode the image
          final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
          final ui.FrameInfo frame = await codec.getNextFrame();
          final ui.Image image = frame.image;

          // Define a circular clip area
          final double radius = circleDiameter / 2.5;
          final Offset center = Offset(markerWidth / 2, circleDiameter / 2);
          final Path clipPath = Path()
            ..addOval(Rect.fromCircle(center: center, radius: radius))
            ..close();

          // Clip the canvas to the circular area
          canvas.clipPath(clipPath);

          // Calculate scaling factors for "cover" effect
          final double scaleX = (radius * 2) / image.width;
          final double scaleY = (radius * 2) / image.height;
          final double scale = scaleX > scaleY ? scaleX : scaleY; // Choose the larger scale

          // Calculate offsets to center the scaled image
          final double offsetX = center.dx - (image.width * scale) / 2;
          final double offsetY = center.dy - (image.height * scale) / 2;

          // Draw the image scaled to "cover" the circular area
          canvas.drawImageRect(
            image,
            Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
            Rect.fromLTWH(offsetX, offsetY, image.width * scale, image.height * scale),
            paint,
          );
        }
      } else {
        // If no URL image, draw a default human icon in the center
        final TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: '\u{1F464}', // Unicode for a person icon
            style: const TextStyle(
              fontSize: 60,
              color: Colors.grey,
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

      // Convert canvas to image and return as BitmapDescriptor
      final ui.Image markerImage = await pictureRecorder
          .endRecording()
          .toImage(markerWidth.toInt(), markerHeight.toInt());
      final ByteData? byteData = await markerImage.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List finalImageBytes = byteData!.buffer.asUint8List();

      return BitmapDescriptor.fromBytes(finalImageBytes);
    } catch (e) {
      debugPrint('Error creating marker: $e');
      return BitmapDescriptor.defaultMarker; // Fallback to default marker
    }
  }

  Future<void> addOrUpdateDriverMarker(
      int driverId,
      String name,
      String lastName,
      double latitude,
      double longitude,
      String? urlImage,
      String time,
      ) async {
    final markerId = MarkerId(driverId.toString());

    BitmapDescriptor icon;
    if (urlImage != null) {
      icon = await createBeautifulMarker(urlImage, name);
    } else {
      icon = await createBeautifulMarker(null, name);
    }

    final marker = Marker(
      markerId: markerId,
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(
        title: name + ' ' + lastName,
        snippet: 'Обновлено: $time',
      ),
      icon: icon,
      onTap: () {
        // Handle marker tap, update the selected driver time
        selectDriver(time);
      },
    );

    markers[markerId] = marker;
    notifyListeners();
    centerMap();
  }

  String? selectedDriverTime;

  void selectDriver(String time) {
    selectedDriverTime = time;
    notifyListeners();  // Update UI to show the time
  }

  String? findUrlImage(int driverId, List<User>? workersResponse2) {
    if (workersResponse2 == null || workersResponse2.isEmpty) {
      return null; // Return null if the list is empty or null
    }

    for (var worker in workersResponse2) {
      if (worker.id == driverId) {
        return worker.customUrlImage;
      }
    }

    return null; // Return null if no match is found
  }

  void sendDataForWs({required double latitude, required double longitude}) {
    final userLocation =
    UserLocation(currentLatitude: latitude, currentLongitude: longitude);
    log('Position: latitude: $latitude, longitude: $longitude');
    channel.sink.add(UserLocation.toMap(userLocation));
  }

  void closeStream() {
    channel.sink.close();
  }
}