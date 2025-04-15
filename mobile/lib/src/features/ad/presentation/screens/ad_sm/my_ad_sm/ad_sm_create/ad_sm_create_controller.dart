import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/models/brand/brand.dart';
import 'package:eqshare_mobile/src/core/data/repositories/app_general_repo.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';

import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/core/res/extensions/string_extensions.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_api_client.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/my_ad_sm/ad_sm_create/ad_sm_parameters/ad_sm_parameters_screen.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/sm_request_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../../../core/data/services/storage/token_provider_service.dart';
import '../../../../../../../core/presentation/routing/app_route.dart';

import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import '../../../../../../../core/data/models/cities/city/city_model.dart';

class AdFormModel {
  String name;
  String description;
  String price;
  String? brandId;
  String? cityId;
  String? typeId;
  double? latitude;
  double? longitude;
  String? address;
  List<String> imagePaths;

  AdFormModel(
      {required this.name,
      required this.description,
      required this.price,
      this.brandId,
      this.cityId,
      this.typeId,
      this.latitude,
      this.longitude,
      this.address,
      required this.imagePaths});
}

class AdSMCreateController extends AppSafeChangeNotifier {
  TextEditingController headerController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  Future<List<City>>? getCities;
  Future<List<Category>>? getCategory;
  Future<List<SubCategory>>? getSubCategory;

  void init() {
    _fetchCities();
    _fetchCategories();
  }

  final adRepo = SMRequestRepositoryImpl();
  final adApiClient = AdApiClient();

  bool isLoading = false;

  Future<List<SubCategory>> futureSubCategories = Future.value([]);

  late List<City> cities = [];
  late List<Category> categories = [];
  late List<SubCategory> subCategories = [];
  late List<Brand> brands = [];

  City? _selectedCity;
  Category? _selectedCategory;
  SubCategory? _selectedSubCategory;
  Brand? _selectedBrand;
  File? selectedImage;
  List selectedImages = ['place_holder'];

  City? get selectedCity => _selectedCity;

  Category? get selectedCategory => _selectedCategory;

  SubCategory? get selectedSubCategory => _selectedSubCategory;

  Brand? get selectedBrand => _selectedBrand;
  LatLng? _selectedPoint;

  LatLng? get selectedPoint => _selectedPoint;

  String? _address;

  String? get address => _address;

  set selectedPoint(LatLng? value) {
    _selectedPoint = value;
    notifyListeners();
  }

  set address(String? value) {
    _address = value;
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
    notifyListeners();
  }

  void setSelectedBrand(Brand? newValue) {
    _selectedBrand = newValue;
    notifyListeners();
  }

  void _fetchCities() {
    getCities = AppGeneralRepo().getCities();
  }

  void _fetchCategories() {
    getCategory = adApiClient.getSMCategoryList();
  }

  void fetchSubCategories(String categoryId) {
    getSubCategory = adApiClient.getSmSubCategoryList(categoryId);
  }

  Future<List<Brand>> fetchBrands() {
    return adApiClient.getSMBrands();
  }

  Future<bool> uploadAdSM() async {
    final url = '${ApiEndPoints.baseUrl}/ad_sm';
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = await TokenService().getToken();
    headers['Authorization'] = 'Bearer $token';
    try {
      final formData = FormData.fromMap({
        'name': headerController.text.trim().capitalizeFirstLetter(),
        'description':
            descriptionController.text.trim().capitalizeFirstLetter(),
        'price': int.tryParse(priceController.text.trim()) ?? 0,
        'brand_id': selectedBrand?.id,
        'city_id': selectedCity?.id,
        'type_id': selectedSubCategory?.id,
        'latitude': selectedPoint?.latitude,
        'longitude': selectedPoint?.longitude,
        'address': address,
      });
      debugPrint(formData.toString());
      for (int i = 0; i < selectedImages.length; i++) {
        if (selectedImages[i] == 'place_holder') continue;
        File imageFile = File(selectedImages[i]);
        formData.files.add(MapEntry(
          'foto',
          await MultipartFile.fromFile(imageFile.path),
        ));
      }
      final response = await Dio().post(
        url,
        data: formData,
        options: Options(
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());
      debugPrint(response.statusMessage.toString());
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        final map = response.data as Map;
        if (map['status'] == 'Successfully added') {
          return true;
        } else {
          return false;
        }
      } else {
        BotToast.showText(text: 'Error');
        return false;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint(e.response?.data);
        debugPrint(e.response?.headers.toString() ?? 'null response');
        debugPrint(e.response?.requestOptions.toString() ?? 'null response');
      } else {
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message.toString());
      }
      throw e.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  void handleLocationSelected(Map<String, dynamic> result) {
    selectedPoint = result['selectedPoint'] as LatLng?;
    address = result['address'] as String?;
    notifyListeners();
  }

    void setPrice(String result) {
   priceController.text = result;
    notifyListeners();
  }

  bool get isValidForm {
    return address?.isNotEmpty == true &&
        priceController.text.isNotEmpty &&
        selectedCategory != null &&
        selectedSubCategory != null &&
        descriptionController.text.isNotEmpty &&
        headerController.text.isNotEmpty;
  }

  void handleNextButtonPressed(BuildContext context) async {
    if (isValidForm) {
      final adSMParametersData = AdSMParametersData(
        adFormModel: AdFormModel(
          name: headerController.text.trim(),
          description: descriptionController.text.trim(),
          price: (int.tryParse(priceController.text.trim()) ?? 0).toString(),
          brandId: selectedBrand?.id.toString(),
          cityId: selectedCity?.id.toString(),
          typeId: selectedSubCategory?.id.toString(),
          latitude: selectedPoint?.latitude,
          longitude: selectedPoint?.longitude,
          address: address,
          imagePaths: selectedImages
              .map((imagePath) {
                if (imagePath == 'place_holder') return null;
                return imagePath;
              })
              .where((entry) => entry != null)
              .cast<String>()
              .toList(),
        ),
        categoryId: selectedCategory?.id ?? -1,
        subCategoryId: selectedSubCategory?.id ?? -1,
      );

      if (!context.mounted) return;

      context.pushNamed(AppRouteNames.adSMParameters,
          extra: adSMParametersData);
    } else {
      AppDialogService.showNotValidFormDialog(context);
    }
  }
}

void showSuccessDialog(BuildContext context) {
  AppDialogService.showSuccessDialog(
    context,
    title: 'Ваше объявление успешно создано!',
    onPressed: () {
      context.pop();
      context.pop();

      if (context.canPop()) {
        context.pop();
        context.pushReplacementNamed(AppRouteNames.myAdSMList);
      } else {
        context.pushNamed(AppRouteNames.myAdSMList);
      }
    },
    buttonText: 'Мои объявления',
  );
}

void showFailureDialog(BuildContext context) {
  AppDialogService.showNotValidFormDialog(
    context,
    'Ваше объявление не опубликовано из за технической неполадки, просим попробовать позже',
  );
}
