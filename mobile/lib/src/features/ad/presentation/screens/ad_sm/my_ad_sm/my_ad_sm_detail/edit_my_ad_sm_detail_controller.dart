import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/models/brand/brand.dart';
import 'package:eqshare_mobile/src/core/data/models/categories_params/categories_params.dart';
import 'package:eqshare_mobile/src/core/data/models/cities/city/city_model.dart';
import 'package:eqshare_mobile/src/core/data/repositories/app_general_repo.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_model/ad_specialized_machinery.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_model/params.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_api_client.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/sm_request_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';

class EditMyAdSmDetailController extends AppSafeChangeNotifier {
  TextEditingController headerController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  Future<List<City>>? getCities;
  Future<List<Category>>? getCategory;
  Future<List<SubCategory>>? getSubCategory;

  final AdSpecializedMachinery _getRedactAd;

  void init() async {
    await initAd();
    _fetchCities();
    _fetchCategories();
  }

  EditMyAdSmDetailController({required AdSpecializedMachinery adSpecializedMachinery})
      : _getRedactAd = adSpecializedMachinery;

  final adRepo = SMRequestRepositoryImpl();
  final adApiClient = AdApiClient();

  bool isLoading = true;

  Future<List<SubCategory>> futureSubCategories = Future.value([]);

  late List<City> cities = [];
  late List<Category> categories = [];
  late List<SubCategory> subCategories = [];
  late List<Brand> brands = [];
  List<String> removedNetworkImages = [];

  Map<String, dynamic> newParams = {};
  List<CategoriesParams>? categoriesParams;
  Params? getParams;

  City? _selectedCity;
  Category? _selectedCategory;
  SubCategory? _selectedSubCategory;
  Brand? _selectedBrand;
  File? selectedImage;
  List<String> selectedImages = [];

  List<String> selectedNetworkImages = [];

  City? get selectedCity => _selectedCity;
  Category? get selectedCategory => _selectedCategory;
  SubCategory? get selectedSubCategory => _selectedSubCategory;
  Brand? get selectedBrand => _selectedBrand;
  LatLng? _selectedPoint;
  LatLng? get selectedPoint => _selectedPoint;

  final TextEditingController addressController = TextEditingController();
  String get address => addressController.text;

  String camelToSnake(String input) {
    final snakeCase = input.replaceAllMapped(
        RegExp(r'([a-z])([A-Z])'), (Match m) => '${m[1]}_${m[2]}');
    return snakeCase.toLowerCase();
  }

  void updateFormData(String paramName, String value) {
    newParams[paramName] = value;
  }

  set selectedPoint(LatLng? value) {
    _selectedPoint = value;
    notifyListeners();
  }

  set address(String? value) {
    addressController.text = value ?? '';
    notifyListeners();
  }


  void setSelectedCity(City? newValue) {
    _selectedCity = newValue;
    notifyListeners();
  }

  void setSelectedCategory(Category? newValue) {
    _selectedCategory = newValue;
    _selectedSubCategory = null;
    notifyListeners();
  }

  void setSelectedSubCategory(SubCategory? newValue) {
    _selectedSubCategory = newValue;
    updatePutParams();
    notifyListeners();
  }

  void setSelectedBrand(Brand? newValue) {
    _selectedBrand = newValue;
    notifyListeners();
  }

  void setSelectedPrice(String? newValue) {
    priceController.text = newValue ?? '';
    notifyListeners();
  }

  void _fetchCities() {
    getCities = AppGeneralRepo().getCities() as Future<List<City>>?;
  }

  void _fetchCategories() {
    getCategory = adApiClient.getSMCategoryList();
  }

  void fetchSubCategories(String categoryId) {
    getSubCategory = adApiClient.getSmSubCategoryList(categoryId);
  }

  Future<void> initAd() async {
    addressController.text = _getRedactAd.address ?? '';
    _selectedBrand = _getRedactAd.brand;
    _selectedSubCategory = _getRedactAd.type;
    _selectedCategory = await adApiClient.getSMCategoryWithID(_selectedSubCategory?.mainCategoryID);
    descriptionController.text = _getRedactAd.description ?? '';
    headerController.text = _getRedactAd.name ?? '';
    priceController.text = (_getRedactAd.price ?? '').toString();
    _selectedPoint = LatLng(_getRedactAd.latitude ?? 0, _getRedactAd.longitude ?? 0);
    _selectedCity = City(id: _getRedactAd.city?.id ?? 0, name: _getRedactAd.city?.name ?? '');
    selectedNetworkImages.addAll(_getRedactAd.urlFoto ?? []);
    getParams = _getRedactAd.params;

    fetchSubCategories(_selectedCategory?.id.toString() ?? '');
    await updatePutParams();
    isLoading = false;

    notifyListeners();
  }

  Future<void> updatePutParams() async {
    final url = '${ApiEndPoints.baseUrl}/${_selectedCategory?.id}/sub_category/${_selectedSubCategory?.id}';
    final response = await Dio().get(url);

    if (response.statusCode == 200) {
      final data = response.data['categories']['params'] as List<dynamic>;
      categoriesParams = data.map((e) => CategoriesParams.fromJson(e)).toList();
    }

    getParams?.toJson().entries.where((entry) => entry.value != null).map((entry) {
      final category = categoriesParams?.firstWhere(
            (e) => e.nameEng == camelToSnake(entry.key),
        orElse: () => CategoriesParams(id: 0),
      );
      if (category?.id == 0) {
        return const SizedBox();
      }
      updateFormData(entry.key.toString(), entry.value.toString());
    });
  }

  Future<List<Brand>> fetchBrands() {
    return adApiClient.getSMBrands();
  }


  void handleLocationSelected(Map<String, dynamic> result) {
    selectedPoint = result['selectedPoint'] as LatLng?;
    address = result['address'] as String? ?? ''; // ✅
  }



  bool get isValidForm {
    final data = address?.isNotEmpty == true &&
        priceController.text.isNotEmpty &&
        selectedCategory != null &&
        selectedSubCategory != null &&
        descriptionController.text.isNotEmpty &&
        headerController.text.isNotEmpty;
    return data;
  }

  Future<bool> putImages() async {
    try {
      final headers = await adRepo.getAuthHeaders();
      final formData = FormData();

      if (selectedImages.isEmpty) {
        log('Нет новых изображений для загрузки');
        return false;
      }

      for (String path in selectedImages) {
        final file = File(path);
        if (file.existsSync()) {
          formData.files.add(MapEntry(
            'foto',
            await MultipartFile.fromFile(file.path),
          ));
        } else {
          log('Файл не найден: $path');
        }
      }

      final response = await Dio().put(
        '${ApiEndPoints.baseUrl}/ad_sm/${_getRedactAd.id}/foto',
        data: formData,
        options: Options(
          headers: headers,
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 200) {
        selectedImages.clear();
        return true;
      } else {
        log('Ошибка загрузки фото: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log('Ошибка при загрузке фото: $e');
      return false;
    }
  }

  Future<bool> putNewInformation() async {
    try {
      final headers = await adRepo.getAuthHeaders();
      final newData = newParams
        ..addAll({
          'id': _getRedactAd.id,
          'name': headerController.text.trim(),
          'description': descriptionController.text.trim(),
          'price': int.tryParse(priceController.text.trim()) ?? 0,
          'brand_id': selectedBrand?.id,
          'city_id': selectedCity?.id,
          'type_id': selectedSubCategory?.id.toString(),
          'latitude': selectedPoint?.latitude,
          'longitude': selectedPoint?.longitude,
          'address': address,
        });
      if (removedNetworkImages.isNotEmpty) {
        newData['removed_documents'] = removedNetworkImages;
      }

      final response = await Dio().put(
          '${ApiEndPoints.baseUrl}/ad_sm/${_getRedactAd.id}/base',
          data: FormData.fromMap(newData),
          options: Options(headers: headers));
      if (response.statusCode == 200) {
        return true;
      } else {
        log(response.toString(), name: 'response');
        throw response;
      }
    } on Exception catch (e) {
      log(e.toString(), name: 'Error');
    }
    return false;
  }

  Future<bool> submitAdUpdate() async {
    if (!isValidForm) {
      log('Форма невалидна');
      return false;
    }

    final updated = await putNewInformation();
    if (!updated) {
      log('Ошибка при обновлении данных');
      return false;
    }

    if (selectedImages.isNotEmpty) {
      final photoUpdated = await putImages();
      if (!photoUpdated) {
        log('Данные обновлены, но фото не загрузились');
      }
    }

    return true;
  }

}
