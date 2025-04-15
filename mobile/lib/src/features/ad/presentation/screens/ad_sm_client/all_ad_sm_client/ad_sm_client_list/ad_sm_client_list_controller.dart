import 'dart:developer';
import 'dart:typed_data';

import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_api_client.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';

import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/features/ad/data/global_fuctions.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/sm_request_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../data/models/ad_sm_models/ad_sm_client_model/ad_client.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';

class AdSMClientListController extends AppSafeChangeNotifier {
  final int? subCategoryId;
  final int? categoryId;

  bool _isLoading = true;
  final _adApiClient = AdApiClient();
  var _ads = <AdListRowData>[];
  bool isLoadingInProgres = false;
  bool isContentEmpty = false;

  Category? selectedCategory;
  SubCategory? selectedSubCategory;
  RangeValues rangeValues = const RangeValues(0, 100000);

  final smRequest = SMRequestRepositoryImpl();

  List<AdListRowData> get ads => List.unmodifiable(_ads.toList());

  bool get isLoading => _isLoading;
  Uint8List? bytesImage;
  bool isLoadingImage = false;
  bool hasError = false;
  bool isBlockType = false;
  SortAlgorithmEnum sortAlgorithm = SortAlgorithmEnum.ascCreatedAt;

  AdSMClientListController(
    BuildContext context, {
    required this.subCategoryId,
    required this.categoryId,
  });

  Future<List<Category>> getCategory() async {
    return AdApiClient().getSMCategoryList();
  }

  void setCategory(int id) {
    selectedCategory = Category(id: id);
    notifyListeners();
  }

  void setSubCategory(int id) {
    selectedSubCategory = SubCategory(id: id);
    notifyListeners();
  }

  Future<void> setupAds(Map<String, dynamic>? qmap) async {
    final token = await TokenService().getToken();
    debugPrint(token);

    if (token == null) {
      return;
    }

    _isLoading = true;
    isContentEmpty = false;

    notifyListeners();

    // checkConnectivity();

    await _loadAds(qmap);

    _isLoading = false;
    notifyListeners();
  }

  AdListRowData _makeRowData(AdClient adSM) {
    String imageUrl;
    if (adSM.documents == null || adSM.documents?.isEmpty == true) {
      imageUrl =
          'https://liamotors.com.ua/image/catalogues/products/no-image.png';
    } else {
      imageUrl = adSM.documents?.first.shareLink ??
          'https://liamotors.com.ua/image/catalogues/products/no-image.png';
    }
    return AdClient.getAdListRowDataFromSM(adSM,
        imageUrl:
            'https://liamotors.com.ua/image/catalogues/products/no-image.png');
  }

  Future<void> _loadAds(Map<String, dynamic>? map) async {
    isLoadingInProgres = true;
    _ads.clear();

    try {
      final adsResponse = await _adApiClient.getAdClientList(
          subCategoryId: selectedSubCategory?.id,
          categoryId: selectedCategory?.id,
          status: RequestStatus.CREATED.name);
      final result = <AdListRowData>[];
      if (adsResponse != null) {
        for (AdClient adSM in adsResponse) {
          result.add(
            _makeRowData(adSM),
          );
        }
        _ads = getSortData(result, sortType: sortAlgorithm);
      }
      if (_ads.isEmpty) {
        isContentEmpty = true;
      } else {
        isContentEmpty = false;
      }
    } catch (e) {
      log(e.toString(), name: 'Errros  : ');
      isLoadingInProgres = false;
    }
  }

  void onAdTap(BuildContext context, int index) async {
    final id = _ads.toList()[index].id.toString();
    debugPrint(id.toString());

    // await Navigator.of(context).pushNamed(
    //   AppRouteNames.adSMClientDetail,
    //   arguments: {'id': id},
    // );
    await context.pushNamed(
      AppRouteNames.adSMClientDetail,
      extra: {'id': id},
    );
  }
}
