import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'google_navigation_workers_screen_controller.dart';

class GoogleNavigationWorkersScreen extends StatefulWidget {
  const GoogleNavigationWorkersScreen({Key? key}) : super(key: key);

  @override
  State<GoogleNavigationWorkersScreen> createState() =>
      _GoogleNavigationWorkersScreenState();
}

class _GoogleNavigationWorkersScreenState
    extends State<GoogleNavigationWorkersScreen> {
  @override
  void dispose() {
    Provider.of<GoogleNavigationWorkersScreenController>(context, listen: false)
        .closeStream();
    super.dispose();
  }

  String formatDateTime(String? createdAt) {
    if (createdAt != null) {
      final DateTime dateTime = DateTime.parse(createdAt);
      final DateFormat formatter = DateFormat("d MMM yyyy 'г.' HH:mm", 'ru_RU');
      return formatter.format(dateTime);
    } else {
      return 'Дата и время не указаны';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Карта'),
        leading: const BackButton(),
      ),
      body: Consumer<GoogleNavigationWorkersScreenController>(
        builder: (context, controller, child) {
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    onMapCreated: (GoogleMapController googleMapController) {
                      controller.controller = googleMapController;
                      controller.centerMap(); // Центрируйте карту после инициализации
                    },
                    polylines: Set<Polyline>.of(controller.polylines.values),
                    markers: Set<Marker>.of(controller.markers.values),
                    initialCameraPosition: CameraPosition(
                      target: controller.destinationGeo,
                      zoom: 12,
                    ),
                  ),
                ),
                Center(
                    child: SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          controller.selectedDriverTime != null
                              ? 'В последний раз обновлено: \n ${formatDateTime(controller.selectedDriverTime)}'
                              : 'Выберите водителя на карте',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}