import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_client_interacted_model/ad_client_interacted.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../data/models/ad_sm_models/ad_sm_client_model/ad_client.dart';
import '../../../../../data/repository/ad_api_client.dart';

class AdSMClientDetailController extends AppSafeChangeNotifier {
  final String adId;
  bool isLoading = true;
  bool isLiked = false;
  bool willUpdateList = false;

  late Future<List<AdListRowData>> getRecommendationAds;
  late Future<List<AdListRowData>> retryAds;

  void toggleUpdateList() {
    willUpdateList = !willUpdateList;
  }

  AdSMClientDetailController(this.adId) {
    loadDetails();
  }

  AdClient? _adDetails;
  List<AdClientInteracted>? _adClientInteractedList;

  AdClient? get adDetails => _adDetails;
  List<AdClientInteracted>? get adClientInteractedList =>
      _adClientInteractedList;

  final _adApiClient = AdApiClient();

  Future<void> loadDetails() async {
    _adDetails = await _adApiClient.getAdSMClientDetail(adId);

    getRecommendationAds =
        getAdListRowData(subCategoryId: _adDetails?.type?.id ?? 0);
    retryAds = getAdListRowData();

    await checkIsSaved(int.parse(adId));

    isLoading = false;

    notifyListeners();
  }

  Future<bool> checkIsFavourite(int adId, BuildContext context) async {
    final adsResponse = await _adApiClient.getFavoriteAdSMClientList();
    if (adsResponse != null) {
      for (var favorite in adsResponse) {
        if (favorite.id == adId) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> checkIsSaved(int adId) async {
    final adsResponse = await _adApiClient.getFavoriteAdSMClientList();

    List<AdClient> favoriteList = [];
    if (adsResponse != null) {
      for (var favorite in adsResponse) {
        if (favorite.id != adId) {
          isLiked = true;
          notifyListeners();
          return;
        }
      }

      for (var element in favoriteList) {
        if (element.id == adId) {
          isLiked = true;
          notifyListeners();
        }
      }
      notifyListeners();
    }
  }

  Future<void> postFavorite(String id, BuildContext context) async {
    _adApiClient.postFavoriteAdSMClient(id: id);

    isLiked = true;
    notifyListeners();
  }

  Future<void> deleteFavorite(String id, BuildContext context) async {
    _adApiClient.deleteFavoriteAdSMClient(
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

  Future<void> onWhatsAppPressed(
      BuildContext context, String adId, String phoneNumber) async {
    try {
      String whatsappLink =
          'StringFormatHelper.formatWhatsAppNumber(phoneNumber)';
      String url = whatsappLink;
      if (url != '') {
        launchUrl(Uri.parse(url));
        final response = await _adApiClient.postAdClientInteracted(
          adId: adId,
        );
        if (response != null && response.statusCode == 200) {
        } else {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ошибка при выполнении заказа'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Невозможно отправить сообщение в WhatsApp'),
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
        // Navigator.pop(context);
        context.pop();
      }
    }
  }

  Future<bool> onReportPostBussiness(BuildContext context, int ad_client_id,
      String description, int report_reasons_id) async {
    try {
      final response =
          await _adApiClient.addReasonsAdSpecializedMachineryBussiness(
        ad_client_id: ad_client_id,
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
        return false;
      }
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

  Future<List<AdListRowData>> getAdListRowData({int? subCategoryId}) async {
    final adList =
        await _adApiClient.getAdClientList(subCategoryId: subCategoryId) ?? [];
    final adListRowData =
        adList.map((e) => AdClient.getAdListRowDataFromSM(e)).toList();
    return Future.value(adListRowData);
  }
}
