import 'dart:developer';

import 'package:eqshare_mobile/src/features/main/location/google_map/google_navigation_screen/client_check_driver_navigation/client_check_driver_navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ClientCheckDriverNavigation extends StatefulWidget {
  const ClientCheckDriverNavigation({super.key});

  @override
  State<ClientCheckDriverNavigation> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<ClientCheckDriverNavigation> {
  @override
  void dispose() {
    super.dispose();
    Provider.of<ClientCheckDriverNavigationController>(context, listen: false)
        .closeStream();
    log('is dispose was done?');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Маршрут водителя'), leading: BackButton()),
        body: Consumer<ClientCheckDriverNavigationController>(
            builder: (context, value, child) {
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: GoogleMap(
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      onMapCreated: value.onMapCreated,
                      markers: value.driverMarkerSet,
                      polylines: Set<Polyline>.of(value.polylines.values),
                      initialCameraPosition: CameraPosition(
                          target: LatLng(43.2220, 76.8512), zoom: 12)),
                ),
                if (value.currentDriverPosition == null)
                  const SizedBox(
                    height: 100,
                    child: Center(
                        child: Text('Нет данных о местоположении',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500))),
                  )
                else
                  const SizedBox(
                    height: 100,
                    child: Center(
                        child: Text('Водитель в пути',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500))),
                  ),
              ],
            ),
          );
        }));
  }
}
