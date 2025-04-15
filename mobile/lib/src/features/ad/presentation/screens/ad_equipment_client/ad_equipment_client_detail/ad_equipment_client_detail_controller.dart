import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_client_interacted_model/ad_client_interacted.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_client_model/ad_equipment_client.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_api_client.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class AdEquipmentClientDetailController extends AppSafeChangeNotifier {
  final String adId;
  bool isLoading = true;
  bool? isLiked = false;
  bool willUpdateList = false;

  late Future<List<AdListRowData>> getRecommendationAds;
  late Future<List<AdListRowData>> retryAds;

  void toggleUpdateList() {
    willUpdateList = !willUpdateList;
  }

  AdEquipmentClientDetailController(this.adId);

  AdEquipmentClient? _adDetails;
  List<AdClientInteracted>? _adClientInteractedList;

  AdEquipmentClient? get adDetails => _adDetails;
  List<AdClientInteracted>? get adClientInteractedList =>
      _adClientInteractedList;

  final _adApiClient = AdApiClient();

  Future<void> loadDetails(BuildContext context) async {
    _adDetails = await _adApiClient.getAdEquipmentClientDetail(adId);

    getRecommendationAds = getAdListRowDataForClient(
        subCategoryID: _adDetails?.equipmentSubcategory?.id);
    retryAds = getAdListRowDataForClient();
    if (kDebugMode) {
      print('_adDetails:$_adDetails');
    }

    if (context.mounted) {
      await checkIsSaved(int.parse(adId), context);
    }

    isLoading = false;

    notifyListeners();
  }

  Future<void> checkIsSaved(int adId, BuildContext context) async {
    final adsResponse = await _adApiClient.getFavoriteAdEquipmentClientList();

    if (adsResponse != null) {
      for (var favorite in adsResponse) {
        if (favorite.id == adId) {
          isLiked = true;
          notifyListeners();
          return;
        }
      }
    } else {
      isLiked = false;
      notifyListeners();
    }
  }

  Future<void> postFavorite(String id) async {
    _adApiClient.postFavoriteAdEquipmentClient(id: id);

    isLiked = true;
    notifyListeners();
  }

  Future<void> deleteFavorite(String id) async {
    _adApiClient.deleteFavoriteAdEquipmentClient(
      id: id,
    );
    isLiked = false;

    notifyListeners();
  }

  Future<void> onCallPressed(
      BuildContext context, String adId, String phoneNumber) async {
    try {
      final response = await _adApiClient.postAdClientInteracted(
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

  Future<bool> onReportPostBussiness(
      BuildContext context,
      int ad_equipment_client_id,
      String description,
      int report_reasons_id) async {
    try {
      final response = await _adApiClient.addReasonsEquipBussiness(
        ad_equipment_client_id: ad_equipment_client_id,
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
        return true;
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
      return false;
    } catch (e) {
      if (!context.mounted) return false;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Произошла ошибка: $e'),
        ),
      );
      return false;
    }
  }

  Future<List<AdListRowData>> getAdListRowDataForClient(
      {int? subCategoryID}) async {
    final adList = await _adApiClient.getAdEquipmentClientListWith(
            subCategoryId: subCategoryID) ??
        [];
    final adListRowData =
        adList.map((e) => AdEquipmentClient.getAdListRowDataFromSM(e)).toList();
    return Future.value(adListRowData);
  }
}
