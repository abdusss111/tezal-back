import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_client_interacted_model/ad_client_interacted.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_client_model/ad_equipment_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/repository/ad_api_client.dart';

class MyAdEquipmentClientDetailController extends AppSafeChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }

  final String adId;
  bool isLoading = true;

  late final Future<List<AdClientInteracted>?> getAdClientInteracted;

  MyAdEquipmentClientDetailController(this.adId) {
    _init();
  }

  void _init() {
    getAdClientInteracted = _adApiClient.getAdClientInteractedList(adId) ; 
  }

  AdEquipmentClient? _adDetails;
  List<AdClientInteracted>? _adClientInteractedList;

  AdEquipmentClient? get adDetails => _adDetails;
  List<AdClientInteracted>? get adClientInteractedList =>
      _adClientInteractedList;

  final _adApiClient = AdApiClient();

  Future<void> loadDetails(BuildContext context) async {
    _adDetails = await _adApiClient.getAdEquipmentClientDetail(adId);
    isLoading = false;

    notifyListeners();
  }



  Future<void> onDeleteTap() async {
    // AppDialogService.showLoadingDialog(context);

    // notifyListeners();
    await AdApiClient().deleteAdEquipmentClient(adId);

    // Navigator.pop(context);
    // Navigator.pop(context);
    // Navigator.pushNamed(context, AppRouteNames.myAdEquipmentClientList);
    // context.pop();
    // context.pop();
    // context.pushNamed(AppRouteNames.myAdEquipmentList);

    notifyListeners();
  }
}
