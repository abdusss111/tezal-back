import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_client_model/ad_client.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_model/ad_specialized_machinery.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_api_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyAdSMListController extends AppSafeChangeNotifier {
  final _adApiClient = AdApiClient();

  Future<List<List<AdListRowData>>> getClientData() async {
    final dataMyRequests = await _adApiClient.getAdClientList(
        id: AppChangeNotifier().payload?.sub ?? '-1', unscoped: true);
    final dataMyAds = await _adApiClient.getAdSMList(
        userID: AppChangeNotifier().payload?.sub ?? '-1',
        categoryId: null,
        subCategoryId: null);
    final requestListClient = dataMyRequests?.map((e) => create(e)).toList();
    final adListClient =
        dataMyAds?.map((e) => createForDriverOrOwner(e)).toList();

    return [requestListClient ?? [], adListClient ?? []];
  }

  Future<void> anAdTapRequests(BuildContext context,
      {required String id, required bool isClient}) async {
    await context.pushNamed(
        isClient
            ? AppRouteNames.myAdSMClientDetail
            : AppRouteNames.myAdSMDetail,
        extra: {
          'id': id,
        });
  }

  AdListRowData create(AdClient adSM) {
    String imageUrl;
    if (adSM.documents == null || adSM.documents?.isEmpty == true) {
      imageUrl = '';
    } else {
      imageUrl = adSM.documents?.first.shareLink ?? '';
    }
    return AdClient.getAdListRowDataFromSM(adSM, isClientType: true);
  }

  AdListRowData createForDriverOrOwner(AdSpecializedMachinery e) {
    return AdSpecializedMachinery.getAdListRowDataFromSM(e,
        isClientType: false, status: '');
  }
}
