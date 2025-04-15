import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_client_model/ad_equipment_client.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_model/ad_equipment.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_api_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/utils/create_ad_or_request_enum.dart';

class MyAdEquipmentListController extends AppSafeChangeNotifier {
  final _adApiClient = AdApiClient();

  Future<List<List<AdListRowData>>> getClientData() async {
    final dataMyRequests = await _adApiClient.getAdEquipmentClientListWith(
        id: AppChangeNotifier().payload?.sub ?? '-1', unscoped: true);

    final dataMyAds = await _adApiClient.getAdEquipmentList(
        userId: AppChangeNotifier().payload?.sub ?? '-1',
        categoryId: null,
        subCategoryId: null);
    final requestListClient = dataMyRequests?.map((e) => create(e)).toList();
    final adListClient =
        dataMyAds?.map((e) => createForDriverOrOwner(e)).toList();

    return [requestListClient ?? [], adListClient ?? []];
  }

  Future<void> anAdTapRequests(BuildContext context,
      {required String id, required bool isClient}) async {
    await context.pushNamed(AppRouteNames.myAdEquipmentClientDetail, extra: {
      'id': id,
      'enum': isClient
          ? CreateAdOrRequestEnum.request.name
          : CreateAdOrRequestEnum.ad.name
    });
  }

  AdListRowData createForDriverOrOwner(AdEquipment adSM) {
    return AdEquipment.getAdListRowDataFromSM(adSM,
        isClienType: false,
        imageUrl:
            'https://liamotors.com.ua/image/catalogues/products/no-image.png');
  }

  AdListRowData create(AdEquipmentClient ad) {
    return AdEquipmentClient.getAdListRowDataFromSM(ad,
        isClientType: true,
        imageUrl:
            'https://liamotors.com.ua/image/catalogues/products/no-image.png');
  }
}
