import 'dart:async';

import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class LocationPermissionStatus extends StatefulWidget {
  final double? iconSize;

  const LocationPermissionStatus({Key? key, this.iconSize}) : super(key: key);

  @override
  _LocationPermissionStatusState createState() =>
      _LocationPermissionStatusState();
}

class _LocationPermissionStatusState extends State<LocationPermissionStatus>
    with WidgetsBindingObserver {
  final StreamController<Color> _permissionStatusStreamController =
      StreamController<Color>.broadcast();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updatePermissionStatus(context.read<ProfileController>());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _permissionStatusStreamController.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _updatePermissionStatus(context.read<ProfileController>());
    }
  }

  Future<void> _updatePermissionStatus(
      ProfileController profileController) async {
    final permission = await Geolocator.checkPermission();
    final isTrackingEnabled = profileController.isLocationTrackingEnabled;

    final bool isPermissionGranted = permission == LocationPermission.always;

    if (isTrackingEnabled && isPermissionGranted) {
      _permissionStatusStreamController.add(Colors.green);
      if (!profileController.isLocationTrackingEnabled) {
        profileController.sendLocationStatus(true);
      }
    } else {
      _permissionStatusStreamController.add(Colors.red);
      if (profileController.isLocationTrackingEnabled) {
        profileController.sendLocationStatus(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (context, profileController, _) {
        _updatePermissionStatus(profileController);

        return StreamBuilder<Color>(
          stream: _permissionStatusStreamController.stream,
          initialData: Colors.grey,
          builder: (context, snapshot) {
            final color = snapshot.data ?? Colors.grey;
            return Icon(
              Icons.location_on,
              color: color,
              size: widget.iconSize, // Установка размера иконки
            );
          },
        );
      },
    );
  }
}
