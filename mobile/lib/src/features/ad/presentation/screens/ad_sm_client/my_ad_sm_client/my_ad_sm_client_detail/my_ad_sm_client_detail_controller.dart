import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_client_interacted_model/ad_client_interacted.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_client_model/ad_client.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';



class MyAdSMClientDetailController extends AppSafeChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }

  final String adId;
  bool isLoading = true;

  MyAdSMClientDetailController(this.adId);

  AdClient? _adDetails;
  List<AdClientInteracted>? _adClientInteractedList;

  AdClient? get adDetails => _adDetails;
  List<AdClientInteracted>? get adClientInteractedList =>
      _adClientInteractedList;

  final _adApiClient = AdApiClient();

  Future<void> loadDetails(BuildContext context) async {
    _adDetails = await _adApiClient.getAdSMClientDetail(adId);

    isLoading = false;

    notifyListeners();
  }

  Future< List<AdClientInteracted>? > getAdClientInteracted() async{
    return _adApiClient.getAdClientInteractedList(adId);
  }

  Future<void> loadInteractedDetails(BuildContext context) async {
    _adClientInteractedList =
        await _adApiClient.getAdClientInteractedList(adId);
    if (kDebugMode) {
      print('_interactedList:$_adClientInteractedList');
    }
    isLoading = false;

    notifyListeners();
  }

  Future<void> onDeleteTap() async {
    await AdApiClient().deleteAdSMClient(adId);
    notifyListeners();
  }
}
