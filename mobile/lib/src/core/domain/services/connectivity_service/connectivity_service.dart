import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:flutter/material.dart';
import '../../../presentation/widgets/connectivity_check_widget.dart';

class ConnectivityService extends ChangeNotifier {
  ConnectivityService._privateConstructor();

  final appChangeNotifier = AppChangeNotifier();

  static final ConnectivityService _instance =
      ConnectivityService._privateConstructor();

  factory ConnectivityService() => _instance;

  final GlobalKey<ConnectivityCheckWidgetState> connectivityWidgetKey =
      GlobalKey();

  List<ConnectivityResult>? _connectivityResult;

  List<ConnectivityResult>? get connectivityResult => _connectivityResult;

  bool get isConnected => appChangeNotifier.isConnected;

  Future<void> startMonitoring() async {
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      _connectivityResult = result; // Store the connectivity result
      appChangeNotifier.isConnected =
          result != ConnectivityResult.none; // Update connection status
      notifyListeners(); // Notify listeners to update the UI if needed
    });
  }

  Future<void> checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    appChangeNotifier.isConnected =
        connectivityResult != ConnectivityResult.none;
    _connectivityResult = connectivityResult; // Store the result
    notifyListeners(); // Notify listeners
  }

  void reloadConnectivityWidget() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      connectivityWidgetKey.currentState?.retryConnectivity();
    });
  }

  Future<List<ConnectivityResult>?> fetchConnectivityResult() async {
    final connectivity = Connectivity();
    final result = await connectivity.checkConnectivity();
    _connectivityResult = result;
    return result;
  }
}
