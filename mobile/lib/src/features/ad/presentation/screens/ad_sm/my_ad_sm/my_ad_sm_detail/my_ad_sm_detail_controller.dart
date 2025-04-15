import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_model/ad_specialized_machinery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../../../../data/models/ad_sm_interacted_list/ad_sm_interacted_list.dart';
import '../../../../../data/repository/ad_api_client.dart';

class MyAdSMDetailController extends AppSafeChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }

  final String adId;
  bool isLoading = true;

  MyAdSMDetailController(this.adId);

  AdSpecializedMachinery? _adDetails;
  AdSmInteractedList? _adSmInteractedList;

  AdSpecializedMachinery? get adDetails => _adDetails;
  AdSmInteractedList? get adSmInteractedList => _adSmInteractedList;

  final _adApiClient = AdApiClient();

  Future<void> loadDetails(BuildContext context) async {
    _adDetails = await _adApiClient.getAdSMDetail(adId);
    if (!context.mounted) return;

    await loadInteractedDetails(context);

    isLoading = false;

    notifyListeners();
  }

  Future<void> loadInteractedDetails(BuildContext context) async {
    _adSmInteractedList = await _adApiClient.getAdSMInteractedList(adId);
    if (kDebugMode) {
      print('_interactedList:$_adSmInteractedList');
    }
    isLoading = false;

    notifyListeners();
  }

  Future<void> onDeleteTap() async {
    await AdApiClient().deleteAdSM(adId);

  

    notifyListeners();
  }
}
