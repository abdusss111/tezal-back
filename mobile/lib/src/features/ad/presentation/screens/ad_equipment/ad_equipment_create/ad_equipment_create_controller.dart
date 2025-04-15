import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/models/brand/brand.dart';
import 'package:eqshare_mobile/src/core/data/repositories/app_general_repo.dart';

import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/core/res/extensions/string_extensions.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_api_client.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_equipment_repository.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/equipment_request_repository_impl.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';

import '../../../../../../core/data/models/cities/city/city_model.dart';

import '../../../../../../core/data/services/storage/token_provider_service.dart';

class AdEquipmentCreateController extends AppSafeChangeNotifier {
  TextEditingController headerController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  final adEquipmentRepo = EquipmentRequestRepositoryImpl();
  final adApiClient = AdApiClient();
  final AdEquipmentRepository adEquipmentRepository = AdEquipmentRepository();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<List<SubCategory>> futureSubCategories = Future.value([]);

  late final Future<List<Category>> getCategoryFuture;
  late final Future<List<Brand>> getBrandFuture;
  late final Future<List<City>> getCityFuture;

  City? _selectedCity;
  Category? _selectedCategory;
  SubCategory? _selectedSubCategory;
  Brand? _selectedBrand;
  File? selectedImage;
  List<String> selectedImages = [];

  List<String> networkImages = [];

  City? get selectedCity => _selectedCity;
  Category? get selectedCategory => _selectedCategory;
  SubCategory? get selectedSubCategory => _selectedSubCategory;
  Brand? get selectedBrand => _selectedBrand;
  LatLng? _selectedPoint;

  LatLng? get selectedPoint => _selectedPoint;

  String? _address;
  String price = '';

  String? get address => _address;

  final int? editID;

  AdEquipmentCreateController({this.editID}) {
    _init();
  }

  void _init() {
    if (editID != null) {
      _initGetEditValue(editID!);
    } else {
      _isLoading = false;
      notifyListeners();
    }

    getBrandFuture = fetchBrands();
    getCategoryFuture = fetchCategories();
    getCityFuture = fetchCities();
  }

  Future<void> _initGetEditValue(int adID) async {
    final ad = await adApiClient.getAdEquipmentDetail(adID.toString());
    headerController.text = ad?.title ?? '';
    descriptionController.text = ad?.description ?? '';
    price = (ad?.price ?? '').toString();
    _selectedSubCategory = ad?.subcategory;
    _selectedCategory = await adEquipmentRepository
        .getCategoryWithID(selectedSubCategory?.mainCategoryID ?? 0);
    address = ad?.address;
    _selectedBrand = ad?.brand;
    _selectedPoint = LatLng(ad?.latitude ?? 0, ad?.longitude ?? 0);
    _selectedCity = City(id: ad?.city?.id ?? 0, name: ad?.city?.name ?? '');
    networkImages = ad?.urlFoto ?? [];

    _isLoading = false;
    notifyListeners();
  }

  void setPrice(String value) {
    price = value;
    notifyListeners();
  }

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
  }

  void setSelectedCategory(Category? newValue) {
    if (_selectedCategory != newValue) {
      _selectedSubCategory = null;
    }
    _selectedCategory = newValue;

    notifyListeners();
  }

  void setSelectedSubCategory(SubCategory? newValue) {
    _selectedSubCategory = newValue;
  }

  void setSelectedBrand(Brand? newValue) {
    _selectedBrand = newValue;
  }

  Future<List<City>> fetchCities() {
    return AppGeneralRepo().getCities();
  }

  Future<List<Category>> fetchCategories() {
    return adApiClient.getEqCategoryList();
  }

  void fetchSubCategories(String categoryId) {
    futureSubCategories = adApiClient.getEqSubCategoryList(categoryId);
  }

  Future<List<Brand>> fetchBrands() {
    return adApiClient.getEquipmentBrands();
  }

  Future<bool> editAdEquipment() async {
    final url = '${ApiEndPoints.baseUrl}/equipment/ad_equipment/$editID';
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = await TokenService().getToken();
    headers['Authorization'] = 'Bearer $token';
    try {
      final formData = {
        'title': headerController.text.trim().capitalizeFirstLetter(),
        'description':
            descriptionController.text.trim().capitalizeFirstLetter(),
        'price': double.tryParse(priceController.text.trim()) ?? 0,
        'equipment_brand_id': selectedBrand?.id,
        'city_id': selectedCity?.id,
        'equipment_sub_сategory_id': selectedSubCategory?.id,
        'latitude': selectedPoint?.latitude,
        'longitude': selectedPoint?.longitude,
        'address': address,
        'user_id': int.parse(AppChangeNotifier().payload?.sub ?? '-1'),
      };

      final response = await Dio().put(
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
        return true;
      } else {
        BotToast.showText(text: 'Error');
        return false;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        log((e.response?.data).toString(), name: 'Error : ');
      } else {
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message.toString());
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> uploadAdEquipment() async {
    final url = '${ApiEndPoints.baseUrl}/equipment/ad_equipment';
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = await TokenService().getToken();
    headers['Authorization'] = 'Bearer $token';
    try {
      final formData = FormData.fromMap({
        'base': jsonEncode({
          'title': headerController.text.trim().capitalizeFirstLetter(),
          'description':
              descriptionController.text.trim().capitalizeFirstLetter(),
          'price': double.tryParse(priceController.text.trim()) ?? 0,
          'equipment_brand_id': selectedBrand?.id,
          'city_id': selectedCity?.id,
          'equipment_sub_сategory_id': selectedSubCategory?.id,
          'latitude': selectedPoint?.latitude,
          'longitude': selectedPoint?.longitude,
          'address': address,
        })
      });

      debugPrint(formData.fields.toString());
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
        //"dial tcp 159.89.163.98:9200: connect: connection refused"
        log((e.response?.data).toString(), name: 'Error : ');
        // debugPrint(e.response?.headers.toString() ?? 'null response');
        // debugPrint(e.response?.requestOptions.toString() ?? 'null response');
      } else {
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message.toString());
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void handleLocationSelected(Map<String, dynamic> result) {
    selectedPoint = result['selectedPoint'] as LatLng?;
    address = result['address'] as String?;
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
      if (!context.mounted) return;
      AppDialogService.showLoadingDialog(context);

      await uploadAdEquipment();
      if (!context.mounted) return;
      // Navigator.pop(context);
      context.pop();

      showSuccessDialog(context);
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
      context.goNamed(AppRouteNames.myAdEquipmentList);
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => ChangeNotifierProvider(
      //       create: (_) => MyAdEquipmentListController(),
      //       child: const MyAdEquipmentListScreen(),
      //     ),
      //   ),
      // );\
    },
    buttonText: 'Мои объявления',
  );
}
