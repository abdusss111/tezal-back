import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_client_model/ad_service_client_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_model/ad_service_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_service_repository.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/utils/create_ad_or_request_enum.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyServicesController extends AppSafeChangeNotifier {
  final serviceRepo = AdServiceRepository();

  MyServicesController();

  Future<List<List<AdListRowData>>> getClientData() async {
    final id = AppChangeNotifier().payload?.sub ?? '-1';
    final dataMyRequests =
        await serviceRepo.getMyServiceClient(id, unscoped: true);
    final dataMyAds = await serviceRepo.getMyServiceDriverOrOwner(id);
    final requestListClient = dataMyRequests?.map((e) => create(e)).toList();
    final adListClient =
        dataMyAds?.map((e) => createForDriverOrOwner(e)).toList();

    return [requestListClient ?? [], adListClient ?? []];
  }

  Future<void> anAdTapRequests(BuildContext context,
      {required String id, required bool isClient}) async {
    await context.pushNamed(AppRouteNames.myAdServicesDetail, extra: {
      'id': id,
      'enum': isClient
          ? CreateAdOrRequestEnum.request.name
          : CreateAdOrRequestEnum.ad.name
    });
  }

  AdListRowData create(AdServiceClientModel e) {
    return AdServiceClientModel.getAdListRowDataFromSM(e, isClientType: true);
  }

  AdListRowData createForDriverOrOwner(AdServiceModel e) {
    return AdServiceModel.getAdListRowDataFromSM(e, isClientType: false);
  }
}
