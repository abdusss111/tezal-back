import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/services/network/api_client/network_client.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../src/core/data/services/storage/token_provider_service.dart';

class AppController extends AppSafeChangeNotifier {
  final RemoteMessage? message;

  AppController({this.message});
  final _tokenProviderService = TokenService();
  bool _isAuth = false;
  bool get isAuth => _isAuth;

  Future<void> checkAuth() async {
    final token = await _tokenProviderService.getToken();
    if (kDebugMode) {
      print(token);
    }

    _isAuth = token != null;
  }

  final _networkClient = NetworkClient();

  // Function to send location to the server
  Future<void> sendLocationToServer(double latitude, double longitude) async {
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = await TokenService().getToken();
    if (token == null) return;
    final payload = TokenService().extractPayloadFromToken(token);
    headers['Authorization'] = 'Bearer $token';
    debugPrint(headers['Authorization'].toString());
    try {
      final body = {
        'driver_id': int.parse(payload.sub ?? "0"),
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // final response =
      await _networkClient.aliPost('/re/receive_driver', body);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
