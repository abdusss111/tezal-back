import 'dart:developer';

import 'package:eqshare_mobile/src/core/data/models/cities/city/city_model.dart';
import 'package:eqshare_mobile/src/core/data/services/network/api_client/network_client.dart';

class AppGeneralRepo {
  final _networkClient = NetworkClient();
  Future<List<City>> getCities() async {
    try {
      final response = await _networkClient.aliGet(
          path: '/city',
          fromJson: (json) {
            final List<dynamic> getCities = json['brands'];
            final List<City> result =
                getCities.map((e) => City.fromJson(e)).toList();
            return result;
          });
      print(response);
      return response ?? [];
    } on Exception catch (e) {
      log(e.toString(),name: 'Errii sL : ');
      return [];
    }
  }
}
