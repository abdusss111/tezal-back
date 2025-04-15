import 'dart:developer';

import 'package:eqshare_mobile/src/features/main/location/google_map/google_navigation_screen/client_check_driver_navigation/client_check_driver_navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ClientCheckDriverNavigation extends StatefulWidget {
  const ClientCheckDriverNavigation({super.key});

  @override
  State<ClientCheckDriverNavigation> createState() =>
      _NavigationScreenState();
}

class _NavigationScreenState extends State<ClientCheckDriverNavigation> {
  @override
  void dispose() {
    super.dispose();
    final controller =
    Provider.of<ClientCheckDriverNavigationController>(context,
        listen: false);
    controller.closeStream();
    log('is dispose was done?');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Маршрут водителя'),
        leading: const BackButton(),
      ),
      body: Consumer<ClientCheckDriverNavigationController>(
        builder: (context, value, child) {
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      value.onMapCreated(controller);
                      log('✅ Карта создана');
                    },
                    markers: value.driverMarkerSet,
                    polylines: Set<Polyline>.of(value.polylines.values),
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(43.2220, 76.8512),
                      zoom: 12,
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: Center(
                    child: Text(
                      value.currentDriverPosition == null
                          ? 'Нет данных о местоположении'
                          : 'Водитель в пути',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
