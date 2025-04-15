import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/services/providers/loading_change_notifier.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_client_model.dart/ad_construction_client_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_model/ad_constrution_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_construction_materials_repository.dart';
import 'package:flutter/material.dart';

class AdConstructionDetailScreenController extends AppSafeChangeNotifier
    with LoadingChangeNotifier {
  final adConstructionMaterialsRepository = AdConstructionMaterialsRepository();

  AdConstrutionModel? _adConstrutionModel;
  AdConstructionClientModel? _adConstructionClientModel;

  AdConstrutionModel? get adConstrutionModel => _adConstrutionModel;
  AdConstructionClientModel? get adConstructionClientModel =>
      _adConstructionClientModel;

  final String adID;

  late bool isClient;

  AdConstructionDetailScreenController({required this.adID}) {
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
    _adConstrutionModel = await adConstructionMaterialsRepository
        .getAdConstructionMaterialDetailForClient(adID: adID);
    getRecommendationAds =
        getAdListRowDataForClient(subCategoryId: _adConstrutionModel?.id);
    retryAds = getAdListRowDataForClient();
  }

  Future<void> _loadAdConstructionClientModel() async {
    _adConstructionClientModel = await adConstructionMaterialsRepository
        .getAdConstructionMaterialDetailForDriverOrOwner(adID: adID);
    getRecommendationAds = getAdListRowDataForDriver(
        subCategoryId: _adConstructionClientModel?.id);
    retryAds = getAdListRowDataForDriver();
  }

  var uniqueKey = UniqueKey();
  void changeUniqueKeyForLike() {
    uniqueKey = UniqueKey();

    notifyListeners();
  }

  late Future<List<AdListRowData>> getRecommendationAds;
  late Future<List<AdListRowData>> retryAds;

  Future<List<AdListRowData>> getAdListRowDataForClient(
      {int? subCategoryId, int? cityId}) async {
    final adList = await adConstructionMaterialsRepository
            .getAdConstructionMaterialListForClient(
                selectedSubCategory: subCategoryId, cityId: cityId) ??
        [];
    final adListRowData = adList
        .map((e) => AdConstrutionModel.getAdListRowDataFromSM(e))
        .toList();
    return Future.value(adListRowData);
  }

  Future<List<AdListRowData>> getAdListRowDataForDriver(
      {int? subCategoryId, int? cityId}) async {
    final adList = await adConstructionMaterialsRepository
            .getAdConstructionMaterialListForDriverOrOwner(
                selectedSubCategory: subCategoryId, cityId: cityId) ??
        [];
    final adListRowData = adList
        .map((e) => AdConstructionClientModel.getAdListRowDataFromSM(e))
        .toList();
    return Future.value(adListRowData);
  }
}
