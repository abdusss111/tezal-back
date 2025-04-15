import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'package:eqshare_mobile/src/core/data/services/network/api_client/network_client.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_client_model/ad_equipment_client.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:intl/intl.dart';

class AdEquipmentRepository {
  final _networkClient = NetworkClient();
  final dio = Dio();
  final baseUrl = ApiEndPoints.baseUrl;

  Future<Map<String, dynamic>> getAuthHeaders() async {
    final token = await TokenService().getToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<Category?> getCategoryWithID(int id) async {
    final result = await _networkClient.aliGet(
        path: '/equipment/category/$id',
        fromJson: (json) {
          final data = json['category'];
          final result = Category.fromJson(data);
          return result;
        });
    return result;
  }

  Future<AdEquipmentClient?> getAdEquipmentClientDetail(String adId) async {
    return _networkClient.aliGet(
      path: '/equipment/ad_equipment_client/$adId',
      fromJson: (json) {
        return AdEquipmentClient.fromJson(json['ad_equipment_client']);
      },
    );
  }

  Future<bool> editORUpdateADClient(
      {required int id,
      required String description,
      required String address,
      required int cityID,
      DateTime? endLeaseDate,
      required double latitude,
      required double longitude,
      required double price,
      required int serviceSubcategoryID,
      required DateTime startLeaseDate,
      required List<String> images,
      required String title}) async {
    final formData = FormData.fromMap({
      'base': jsonEncode({
        "address": address,
        "city_id": cityID,
        "description": description,
        if (endLeaseDate != null)
          "end_lease_date":
              dateFormatWithyyyyMMddTHHmmssSSSSSSSSS(endLeaseDate),
        "latitude": latitude,
        "longitude": longitude,
        "price": price,
        "equipment_subcategory_id": serviceSubcategoryID,
        "start_lease_date":
            dateFormatWithyyyyMMddTHHmmssSSSSSSSSS(startLeaseDate),
        "title": title
      })
    });
    if (images.isNotEmpty) {
      for (int i = 0; i < images.length; i++) {
        File imageFile = File(images[i]);
        formData.files.add(MapEntry(
          'foto',
          await MultipartFile.fromFile(imageFile.path),
        ));
      }
    }
    try {
      final headers = await getAuthHeaders();
      final response = await dio.put('$baseUrl/service/ad_service_client/$id',
          data: formData, options: Options(headers: headers));
      if (response.statusCode == 200) {
        return true;
      }
    } on Exception catch (e) {
      printLog(e, 'postClientAdService');
    }
    return false;
  }

  String dateFormatWithyyyyMMddTHHmmssSSSSSSSSS(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS'Z'").format(dateTime);
  }

  void printLog(Object e, String name) {
    log(e.toString(), name: name);
  }
}
