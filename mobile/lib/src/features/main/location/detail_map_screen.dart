import 'dart:math';

import 'package:eqshare_mobile/src/features/main/location/add_in_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HalfScreenMapWidget extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final double? height;

  const HalfScreenMapWidget({
    super.key,
    this.latitude,
    this.longitude,
    this.height,
  });

  @override
  State<HalfScreenMapWidget> createState() => _HalfScreenMapWidgetState();
}

class _HalfScreenMapWidgetState extends State<HalfScreenMapWidget> {
  GoogleMapController? controller;

  @override
  Widget build(BuildContext context) {
    var googleMap = GoogleMap(
      zoomControlsEnabled: false,
      onMapCreated: (controller) {
        this.controller = controller;
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.latitude ?? 0, widget.longitude ?? 0),
        zoom: 13,
      ),
      markers: {
        Marker(
          position: LatLng(widget.latitude ?? 0, widget.longitude ?? 0),
          markerId: MarkerId('${widget.latitude}-${widget.longitude}'),
        ),
      },
    );

    return Container(
      child: SizedBox(
      height: widget.height ?? MediaQuery.of(context).size.height / 5,
      child: Stack(
        children: [
          // Map Container with Rounded Corners and Shadows
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), // Rounded corners
              boxShadow: const [
                BoxShadow(
                  offset: Offset(-1, -1), // Shadow offset top-left
                  blurRadius: 5, // Blur radius
                  color: Color.fromRGBO(0, 0, 0, 0.04), // Light shadow
                ),
                BoxShadow(
                  offset: Offset(1, 1), // Shadow offset bottom-right
                  blurRadius: 5,
                  color: Color.fromRGBO(0, 0, 0, 0.04), // Light shadow
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge, // Clip child content to the border radius
            child: googleMap, // Map widget
          ),
          // Top-right Icon
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                Icons.open_in_full,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  enableDrag: false,
                  builder: (context) {
                    return AddInMapScreen(
                      googleMap: googleMap,
                      controller: controller,
                      latitude: widget.latitude,
                      longitude: widget.longitude,
                    );
                  },
                );
              },
            ),
          ),
          // Bottom-right Icon
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: Transform.rotate(
                angle: 45 * pi / 180,
                child: Icon(
                  Icons.navigation_sharp,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                controller?.moveCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(widget.latitude ?? 0, widget.longitude ?? 0),
                    zoom: 13,
                  ),
                ));
              },
            ),
          ),
        ],
      ),
    ));
  }
}
