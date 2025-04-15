import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/services/providers/loading_change_notifier.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_client_model/ad_service_client_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_model/ad_service_model.dart';
import 'package:flutter/foundation.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_service_repository.dart';

class AdServiceDetailScreenController extends AppSafeChangeNotifier
    with LoadingChangeNotifier {
  bool isAdLisked = false;

  late Future<List<AdListRowData>> getRecommendationAds;
  late Future<List<AdListRowData>> retryAds;

  late bool isClient;

  var uniqueKey = UniqueKey();
  final adServiceRepo = AdServiceRepository();
  AdServiceModel? adService;
  AdServiceClientModel? adServiceClient;

  final String adID;

  AdServiceDetailScreenController({required this.adID}) {
    loadDetails();
  }

  Future<void> loadDetails() async {
    final payload = await getPayload();
    isClient =
        payload == null || payload.aud == 'CLIENT' || payload.aud == 'GUEST';
    notifyListeners();
    if (isClient) {
      await _loadAdConstrutionModel();
    } else {
      await _loadAdConstructionClientModel();
    }
    setLoading(false);
  }

  Future<void> _loadAdConstrutionModel() async {
    adService = await adServiceRepo.getAdServiceDetailForClient(adID: adID);
    getRecommendationAds =
        getAdListRowDataForClient(subCategoryID: adService?.subCategoryID);
    retryAds = getAdListRowDataForClient();
  }

  Future<void> _loadAdConstructionClientModel() async {
    adServiceClient =
        await adServiceRepo.getAdServiceDetailForDriverOrOwner(adID: adID);
    getRecommendationAds = getAdListRowDataForDriver(
        subCategoryID: adServiceClient?.subCategoryID);
    retryAds = getAdListRowDataForDriver();
  }

  void setUpadServiceClient(AdServiceClientModel? adServiceClient) {
    this.adServiceClient = adServiceClient;
    notifyListeners();
  }

  void changeUniqueKeyForLike() {
    uniqueKey = UniqueKey();
    notifyListeners();
  }

  Future<void> addORDeleteAdFromFovaurite(String id) async {
    bool? newValue;
    if (!isAdLisked) {
      newValue = await adServiceRepo
          .adForFavouriteADDriverOrOwnerServiceFromClientAccount(id);
    } else {
      newValue = await adServiceRepo
          .deleteFavouriteADDriverOrOwnerServiceFromClientAccount(id);
    }
    changeIsAdLiked(newValue);
  }

  Future<void> addORDeleteAdFromFovauriteForDriverOrOwner(String id) async {
    bool? newValue;
    if (!isAdLisked) {
      newValue = await adServiceRepo
          .adForFavouriteADClientServiceFromDriverOrOwnerAccount(id);
    } else {
      newValue = await adServiceRepo
          .deleteFavouriteADClientServiceFromDriverOrOwnerAccount(id);
    }
    changeIsAdLiked(newValue);
  }

  void changeIsAdLiked(bool value) {
    isAdLisked = value;
    notifyListeners();
  }

  Future<bool> isAdLiskedForClientCheck(String id) async {
    isAdLisked = await adServiceRepo.checkIsAdServiceISFavouriteForClient(
        aadServiceID: int.parse(id));
    notifyListeners();
    return isAdLisked;
  }

  Future<bool> isAdLiskedForDrivertCheck(String id) async {
    isAdLisked = await adServiceRepo
        .checkIsAdServiceISFavouriteForDriverOrOwner(int.parse(id));
    notifyListeners();
    return isAdLisked;
  }

  // Future<AdServiceModel?> getAdServiceDetailForClient(String id) async {
  //   return adServiceRepo.getAdServiceDetailForClient(adID: id);
  // }

  // Future<AdServiceClientModel?> getAdServiceDetailForDriverOrOwner(
  //     String id) async {
  //   return adServiceRepo.getAdServiceDetailForDriverOrOwner(adID: id);
  // }

  Future<bool> sendReport(
      {required String adID,
      required reportReasonID,
      required String reportText}) async {
    final data = await adServiceRepo.sendReport(
        adID: adID, reportReasonID: reportReasonID, reportText: reportText);
    return data;
  }

  Future<List<AdListRowData>> getAdListRowDataForClient(
      {int? subCategoryID}) async {
    final adList = await adServiceRepo.getAdServiceListForClient(
            selectedSubCategory: subCategoryID) ??
        [];
    final adListRowData =
        adList.map((e) => AdServiceModel.getAdListRowDataFromSM(e)).toList();
    return Future.value(adListRowData);
  }

  Future<List<AdListRowData>> getAdListRowDataForDriver(
      {int? subCategoryID}) async {
    final adList = await adServiceRepo.getAdServiceListForDriverOrOwner(
            selectedSubCategory: subCategoryID) ??
        [];
    final adListRowData = adList
        .map((e) => AdServiceClientModel.getAdListRowDataFromSM(e))
        .toList();
    return Future.value(adListRowData);
  }
}
