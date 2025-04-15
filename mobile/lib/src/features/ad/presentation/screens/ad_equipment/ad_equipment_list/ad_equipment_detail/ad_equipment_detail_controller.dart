import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';

import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/core/res/extensions/string_extensions.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_model/ad_equipment.dart';

import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../data/repository/ad_api_client.dart';

class AdEquipmentDetailController extends AppSafeChangeNotifier {
  final String adId;
  bool isLoading = true;
  bool? isLiked;
  bool willUpdateList = false;
  final appChangeNotifier = AppChangeNotifier();

  AdEquipmentDetailController(this.adId);

  AdEquipment? _adDetails;

  AdEquipment? get adDetails => _adDetails;

  late Future<List<AdListRowData>> getRecommendationAds;
  late Future<List<AdListRowData>> retryAds;

  final _adApiClient = AdApiClient();

  void toggleUpdateList() {
    willUpdateList = !willUpdateList;
  }

  Future<void> loadDetails() async {
    _adDetails = await _adApiClient.getAdEquipmentDetail(adId);

    getRecommendationAds = getAdListRowDataForClient(
        subCategoryID: _adDetails?.subcategory?.id);
    retryAds = getAdListRowDataForClient();
    await appChangeNotifier.getUserMode();
    if (!(appChangeNotifier.userMode == UserMode.guest)) {
      await checkIsSaved(int.parse(adId));
    }
    isLoading = false;

    notifyListeners();
  }

  Future<void> checkIsSaved(int adId) async {
    final adsResponse = await _adApiClient.getFavoriteAdEquipmentList();
    if (adsResponse != null) {
      for (var equipment in adsResponse) {
        if (equipment.id == adId) {
          isLiked = true;
          notifyListeners();
          return;
        }
      }
    } else {
      isLiked = false;
      notifyListeners();
    }
    if (isLiked == false) {
      isLiked = false;
      notifyListeners();
    }
  }

  Future<void> postFavorite(String id) async {
    _adApiClient.postFavoriteAdEquipment(
      id: id,
    );

    isLiked = true;
    notifyListeners();
  }

  Future<void> deleteFavorite(String id) async {
    _adApiClient.deleteFavoriteAdEquipment(
      id: id,
    );
    isLiked = false;

    notifyListeners();
  }

  Future<void> onCallPressed(
    BuildContext context, String adId, String phoneNumber) async {
  try {
    final response = await _adApiClient.postAdSMInteracted(
      adId: adId,
    );
    if (response != null && response.statusCode == 200) {
      final url = 'tel:$phoneNumber';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Невозможно совершить звонок'),
          ),
        );
      }
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ошибка при выполнении заказа'),
        ),
      );
    }
  } catch (e) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Произошла ошибка: $e'),
      ),
    );
  } finally {
    if (context.mounted) {
      context.pop();
    }
  }
}

  Future<bool> createRequestForDriverOROwnerFromClient(
      {required String adID,
      required double adPrice,
      required String address,
      required String description,
      required LatLng? latLng,
      DateTime? toDateTime,
      required List<String> selectedImages,
      required DateTime? fromDateTime}) async {
    final url = '${ApiEndPoints.baseUrl}/equipment/request_ad_equipment';

    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = await TokenService().getToken();
    headers['Authorization'] = 'Bearer $token';
    try {
      final formData = FormData.fromMap({
        'base': jsonEncode({
          'ad_equipment_id': int.parse(adID),
          if (fromDateTime != null)
            'start_lease_at': DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS'Z'")
                .format(fromDateTime),
          if (toDateTime != null)
            'end_lease_at': DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS'Z'")
                .format(toDateTime),
          'description': description.capitalizeFirstLetter(),
          'address': address,
          'latitude': latLng?.latitude,
          'longitude': latLng?.longitude,
        })
      });
      for (int i = 0; i < selectedImages.length; i++) {
        if (selectedImages[i] == 'place_holder') continue;
        File imageFile = File(selectedImages[i]);
        formData.files.add(MapEntry(
          'foto',
          await MultipartFile.fromFile(imageFile.path),
        ));
      }

      if (fromDateTime != null && toDateTime != null) {
        final additionalEntries = {
          'count_hour': DateTimeUtils()
              .calculateHoursDifference(fromDateTime, toDateTime),
        };
        formData.fields.addAll(additionalEntries.entries
            .map((entry) => MapEntry<String, String>(entry.key, entry.value)));
      }
      // final queryParameters = {
      //   'status': 'CREATED',
      // };

      final response = await Dio().post(
        url,
        // queryParameters: queryParameters,
        data: formData,
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        var map = response.data as Map;
        if (map['status'] == 'Successfully sended') {
          return true;
        } else {
          return true;
        }
      } else {
        return false;
      } //"service requestAdEquipment: Create: repository requestAdEquipment `Create` `Create`: ERROR: null value in column "start_lease_at…"
    } on DioException catch (e) {
      debugPrint(e.response?.data.toString() ?? 'NULL');
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> onReportPostClient(
      BuildContext context,
      int specializedMachineryId,
      String description,
      int report_reasons_id) async {
    try {
      final response = await _adApiClient.addReasonsAdEquipmentClient(
        ad_equipment_id: specializedMachineryId,
        description: description,
        report_reasons_id: report_reasons_id,
      );
      if (response != null && response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            padding: EdgeInsets.all(40),
            content: Center(
              child: Text(
                  style: TextStyle(fontSize: 17), 'Жалоба успешно отправлена'),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            padding: EdgeInsets.all(40),
            content: Center(
              child: Text(
                  style: TextStyle(fontSize: 17),
                  'Ошибка при отправке жалоб11ы'),
            ),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Произошла ошибка: $e'),
        ),
      );
    }
  }

  Future<List<AdListRowData>> getAdListRowDataForClient(
      {int? subCategoryID, int? cityId}) async {
    final adList =
        await _adApiClient.getAdEquipmentList(subCategoryId: subCategoryID) ?? [];
    final adListRowData =
        adList.map((e) => AdEquipment.getAdListRowDataFromSM(e)).toList();
    return Future.value(adListRowData);
  }
}
