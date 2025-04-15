import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_client_model.dart/ad_construction_client_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_model/ad_constrution_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_construction_materials_repository.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/utils/create_ad_or_request_enum.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyAdConstructionControllers extends AppSafeChangeNotifier {
  final constructionRepo = AdConstructionMaterialsRepository();

  Future<List<List<AdListRowData>>> getClientData() async {
    final dataMyRequests = await constructionRepo.getMyAdConstructionsForClient(
        AppChangeNotifier().payload?.sub ?? '-1',
        unscoped: true);
    final dataMyAds =
        await constructionRepo.getMyAdConstructionsForDriverOrOwner(
            AppChangeNotifier().payload?.sub ?? '-1');
    final requestListClient = dataMyRequests?.map((e) => create(e)).toList();
    final adListClient =
        dataMyAds?.map((e) => createForDriverOrOwner(e)).toList();

    return [requestListClient ?? [], adListClient ?? []];
  }

  Future<void> anAdTapRequests(BuildContext context,
      {required String id, required bool isClient}) async {
    await context.pushNamed(AppRouteNames.myAdConstructionDetail, extra: {
      'id': id,
      'enum': isClient
          ? CreateAdOrRequestEnum.request.name
          : CreateAdOrRequestEnum.ad.name
    });
  }

  AdListRowData create(AdConstructionClientModel e) {
    return AdConstructionClientModel.getAdListRowDataFromSM(e,
        isClientType: true);
  }

  AdListRowData createForDriverOrOwner(AdConstrutionModel e) {
    return AdConstrutionModel.getAdListRowDataFromSM(e, isClientType: false);
  }
}
