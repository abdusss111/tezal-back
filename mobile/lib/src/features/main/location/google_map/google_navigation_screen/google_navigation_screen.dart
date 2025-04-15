import 'dart:developer';

import 'package:eqshare_mobile/src/features/main/location/google_map/google_navigation_screen/google_navigation_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class GoogleNavigationScreen extends StatefulWidget {
  const GoogleNavigationScreen({super.key});

  @override
  State<GoogleNavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<GoogleNavigationScreen> {
  @override
  void dispose() {
    super.dispose();
    Provider.of<GoogleNavigationScreenController>(context, listen: false)
        .closeStream();
    log('is dispose was done?');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Карта'), leading: BackButton()),
      body: Consumer<GoogleNavigationScreenController>(
        builder: (context, value, child) {
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    onMapCreated: value.onMapCreated,
                    polylines: Set<Polyline>.of(value.polylines.values),
                    markers: value.destinationMarker != null
                        ? Set<Marker>.from([value.destinationMarker!])
                        : Set<Marker>(),
                    initialCameraPosition: CameraPosition(
                      target: LatLng(43.2220, 76.8512),
                      zoom: 12,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                  child: Center(
                    child: Text(
                      'Вы в пути',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }}