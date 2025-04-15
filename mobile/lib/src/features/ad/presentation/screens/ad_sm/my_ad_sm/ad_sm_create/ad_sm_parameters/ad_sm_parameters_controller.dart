import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';

import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/my_ad_sm/ad_sm_create/ad_sm_parameters/ad_sm_parameters_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdSMParametersController extends AppSafeChangeNotifier {
  final AdSMParametersData adSMParametersData;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Map<String, String> formData = {};
  List<Map<String, dynamic>> params = [];
  bool isLoading = true;

  AdSMParametersController(this.adSMParametersData);

  Future<void> loadParameters(BuildContext context) async {
    try {
      formData = {
        'name': adSMParametersData.adFormModel.name,
        'description': adSMParametersData.adFormModel.description,
        'price': adSMParametersData.adFormModel.price,
        'brand_id': adSMParametersData.adFormModel.brandId ?? '',
        'city_id': adSMParametersData.adFormModel.cityId ?? '',
        'type_id': adSMParametersData.adFormModel.typeId ?? '',
        'latitude': adSMParametersData.adFormModel.latitude?.toString() ?? '',
        'longitude': adSMParametersData.adFormModel.longitude?.toString() ?? '',
        'address': adSMParametersData.adFormModel.address ?? '',
      };

      final url = Uri.parse(
          '${ApiEndPoints.baseUrl}/${adSMParametersData
              .categoryId}/sub_category/${adSMParametersData.subCategoryId}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes))
        as Map<String, dynamic>;
        final paramsData = jsonData['categories']['params'];

        params = List<Map<String, dynamic>>.from(paramsData);
        isLoading = false;
        notifyListeners();
      } else {
        throw Exception('Failed to load params');
      }
    } catch (e) {
      throw Exception('Failed to load params');
    }
  }

  void updateFormData(String paramName, String value) {
    formData[paramName] = value;
  }

  Future<bool> submitForm(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      final url = '${ApiEndPoints.baseUrl}/ad_sm';

      final token = await TokenService().getToken();
      final headers = {
        'Authorization': 'Bearer $token',
      };

      try {
        final thisFormData = FormData();

        // Добавляем только строки!
        formData.forEach((key, value) {
          if (value != null) {
            thisFormData.fields.add(MapEntry(key, value.toString()));
          }
        });

        // Добавляем изображения
        for (int i = 0; i <
            adSMParametersData.adFormModel.imagePaths.length; i++) {
          File imageFile = File(adSMParametersData.adFormModel.imagePaths[i]);
          thisFormData.files.add(MapEntry(
            'foto',
            await MultipartFile.fromFile(imageFile.path),
          ));
        }

        final response = await Dio().post(
          url,
          data: thisFormData,
          options: Options(
            headers: headers,
            contentType: 'multipart/form-data',
          ),
        );

        debugPrint(response.statusCode.toString());
        debugPrint(response.data.toString());

        if (response.statusCode == 200 || response.statusCode == 201) {
          return true;
        } else {
          BotToast.showText(text: 'Ошибка при сохранении');
          return false;
        }
      } on DioException catch (e) {
        log(formData.toString(), name: 'FormData');
        log(e.response?.data.toString() ?? 'no response');
        log(e.message.toString());
        return false;
      } catch (e) {
        log(e.toString());
        return false;
      }
    } else {
      return false;
    }
  }
}
