import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';

import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_model/ad_specialized_machinery.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../data/repository/ad_api_client.dart';

class AdSMDetailController extends AppSafeChangeNotifier {
  final String adId;
  bool isLoading = true;
  bool? isLiked = false;
  bool willUpdateList = false;

  late Future<List<AdListRowData>> getRecommendationAds;
  late Future<List<AdListRowData>> retryAds;

  AdSMDetailController(this.adId);

  AdSpecializedMachinery? _adDetails;

  AdSpecializedMachinery? get adDetails => _adDetails;

  final _adApiClient = AdApiClient();

  void toggleUpdateList() {
    willUpdateList = !willUpdateList;
  }

  Future<void> loadDetails(BuildContext context) async {
    _adDetails = await _adApiClient.getAdSMDetail(adId);

    getRecommendationAds =
        getAdListRowData(subCategoryID: _adDetails?.type?.id ?? 0, cityID: _adDetails?.cityId );
    retryAds = getAdListRowData();
    // debugPrint(
    //     'imageUrl: ${_adDetails?.adSpecializedMachinery?.urlFoto?.first.toString()}');
    await AppChangeNotifier().getUserMode();
    if (!(AppChangeNotifier().userMode == UserMode.guest) && context.mounted) {
      await checkIsSaved(int.parse(adId), context);
    }
    isLoading = false;

    notifyListeners();
  }

  Future<List<AdListRowData>> getAdListRowData(
      {int? categoryID, int? subCategoryID, int? cityID}) async {
    final adList = await _adApiClient.getAdSMList(
            categoryId: categoryID, subCategoryId: subCategoryID, cityId: cityID) ??
        [];
    final adListRowData = adList
        .map((e) => AdSpecializedMachinery.getAdListRowDataFromSM(e))
        .toList();
    // if(adListRowData.isEmpty){
    //   return getAdListRowData();
    // }
    return Future.value(adListRowData);
  }

  Future<void> checkIsSaved(int adId, BuildContext context) async {
    final adsResponse = await _adApiClient.getFavoriteAdSpecializedMachinery();
    List<AdSpecializedMachinery> favoriteList = [];
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

  Future<void> postFavorite(String id, BuildContext context) async {
    _adApiClient.postFavoriteAdSM(id: id);

    isLiked = true;
    notifyListeners();
  }

  Future<void> deleteFavorite(String id, BuildContext context) async {
    _adApiClient.deleteFavoriteAdSM(
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

  Future<void> onWhatsAppPressed(
      BuildContext context, String adId, String phoneNumber) async {
    try {
      String url = 'whatsappLink';
      if (url != '') {
        launchUrl(Uri.parse(url));
        final response = await _adApiClient.postAdSMInteracted(
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

  // Future<ReportReasonList?> getReportReasons(BuildContext context) async {
  //   final response = await _adApiClient.getReasonsReport(context);
  //   print('resp ${response}');
  //   return response;
  // }

  Future<void> onReportPostClient(
      BuildContext context,
      int specializedMachineryId,
      String description,
      int report_reasons_id) async {
    try {
      final response =
          await _adApiClient.addReasonsAdSpecializedMachineryClient(
        ad_specialized_machinery_id: specializedMachineryId,
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
                  style: TextStyle(fontSize: 17), 'Ошибка при отправке жалобы'),
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
}
