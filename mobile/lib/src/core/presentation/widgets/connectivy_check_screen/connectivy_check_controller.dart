import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityServiceController extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  late Stream<List<ConnectivityResult>> connectivityStream;

  ConnectivityServiceController() {
    connectivityStream = _connectivity.onConnectivityChanged;
  }

  Future<List<ConnectivityResult>> fetchConnectivityResult() async {
    return await _connectivity.checkConnectivity();
  }
}
