import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';/

class AddInMapScreen extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final GoogleMap googleMap;
  final GoogleMapController? controller;

  const AddInMapScreen(
      {super.key,
      this.latitude,
      this.longitude,
      required this.googleMap,
      this.controller});

  @override
  State<AddInMapScreen> createState() => _AddInMapScreenState();
}

class _AddInMapScreenState extends State<AddInMapScreen> {
  // final MapController mapController = MapController();
  GoogleMapController? _mapController;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController =
                  controller; // Сохраните контроллер для дальнейшего использования
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.latitude ?? 0, widget.longitude ?? 0),
              zoom: 13,
            ),
            markers: {
              Marker(
                  position: LatLng(widget.latitude ?? 0, widget.longitude ?? 0),
                  markerId: MarkerId('${widget.latitude}-${widget.longitude}'))
            },
            // Другие параметры карты, если нужно
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                Icons.close,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Transform.rotate(
                angle: 45 * pi / 180,
                child: Icon(
                  Icons.navigation_sharp,
                  size: 24,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                _mapController?.moveCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target:
                            LatLng(widget.latitude ?? 0, widget.longitude ?? 0),
                        zoom: 13)));
              },
            ),
          ),
        ],
      ),
    ));
  }

  // FlutterMap newMethod(BuildContext context) {
  //   return FlutterMap(
  //     mapController: mapController,
  //     options: MapOptions(
  //       initialCenter: LatLng(widget.latitude ?? 0.0, widget.longitude ?? 0.0),
  //       initialZoom: 13.0,
  //     ),
  //     children: [
  //       TileLayer(
  //         urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
  //         subdomains: const ['a', 'b', 'c'],
  //       ),
  //       MarkerLayer(
  //         markers: [
  //           Marker(
  //             width: 40.0,
  //             height: 40.0,
  //             point: LatLng(widget.latitude ?? 0.0, widget.longitude ?? 0.0),
  //             child: const Icon(
  //               Icons.location_on,
  //               color: Colors.red,
  //               size: 40.0,
  //             ),
  //           ),
  //         ],
  //       ),
  //       Align(
  //         alignment: Alignment.topRight,
  //         child: IconButton(
  //           icon: Icon(
  //             Icons.close,
  //             size: 20,
  //             color: Theme.of(context).primaryColor,
  //           ),
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ),
  //       ),
  //       Align(
  //         alignment: Alignment.bottomRight,
  //         child: IconButton(
  //           icon: Transform.rotate(
  //             angle: 45 * pi / 180,
  //             child: Icon(
  //               Icons.navigation_sharp,
  //               size: 20,
  //               color: Theme.of(context).primaryColor,
  //             ),
  //           ),
  //           onPressed: () {
  //             mapController.move(
  //                 LatLng(widget.latitude ?? 0, widget.longitude ?? 0), 12);
  //           },
  //         ),
  //       ),
  //     ],
  //     // children: const [], // Add an empty list of children
  //   );
  // }
}
