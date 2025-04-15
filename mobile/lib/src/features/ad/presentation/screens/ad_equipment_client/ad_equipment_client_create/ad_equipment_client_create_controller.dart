import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/models/cities/city/city_model.dart';
import 'package:eqshare_mobile/src/core/data/repositories/app_general_repo.dart';

import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';

import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';

import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_api_client.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_equipment_repository.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/equipment_request_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import 'package:eqshare_mobile/src/core/res/extensions/string_extensions.dart';

class AdEquipmentClientCreateController extends AppSafeChangeNotifier {
  final int? editID;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  AdEquipmentClientCreateController({this.editID}) {
    _init();
  }

  late AdEquipmentClientCreateController controller;
  late final Future<List<Category>> getCategoryFuture;
  late Future<List<SubCategory>> getSubCategoryFuture;

  late final Future<List<City>> getCityFuture;

  void _init() {
    if (editID != null) {
      _initGetEditValue(editID!);
    } else {
      _isLoading = false;
      notifyListeners();
    }

    getCategoryFuture = fetchCategories();
    getCityFuture = fetchCities();
    fetchSubCategories('0');
  }

  Future<void> _initGetEditValue(int adID) async {
    final ad =
        await adEquipmentRepository.getAdEquipmentClientDetail(adID.toString());
    title = ad?.title ?? '';
    desc = ad?.description ?? '';
    price = (ad?.price ?? '').toString();
    _selectedSubCategory = ad?.equipmentSubcategory;
    _selectedCategory = await adEquipmentRepository
        .getCategoryWithID(selectedSubCategory?.mainCategoryID ?? 0);
    address = ad?.address;
    _selectedPoint = LatLng(ad?.latitude ?? 0, ad?.longitude ?? 0);
    _selectedCity = City(id: ad?.city?.id ?? 0, name: ad?.city?.name ?? '');

    fromDateTime = DateTimeUtils()
        .formatDateFromyyyyMMddTHHmmssSSSSSSSS(ad?.startLeaseDate);
    if (ad?.endLeaseDate != null) {
      isEndTimeEnabled = true;
      toDateTime = DateTimeUtils()
          .formatDateFromyyyyMMddTHHmmssSSSSSSSS(ad?.endLeaseDate);
    }
    networkImages = ad?.urlFoto ?? [];
    _isLoading = false;
    notifyListeners();
  }

  bool? isEndTimeEnabled = false;
  DateTime? fromDate;
  DateTime? fromDateTime;
  TimeOfDay? fromTime;
  DateTime? toDate;
  DateTime? toDateTime;
  TimeOfDay? toTime;
  LatLng? _selectedPoint;
  String? title;
  String? desc;
  String? price;

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

  TextEditingController headerController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  final adRepo = EquipmentRequestRepositoryImpl();

  final AdEquipmentRepository adEquipmentRepository = AdEquipmentRepository();

  City? _selectedCity;
  Category? _selectedCategory;
  SubCategory? _selectedSubCategory;

  File? selectedImage;
  List<String> selectedImages = [];
  List<String> networkImages = [];

  City? get selectedCity => _selectedCity;
  Category? get selectedCategory => _selectedCategory;
  SubCategory? get selectedSubCategory => _selectedSubCategory;

  void setPrice(String value) {
    price = value;
    notifyListeners();
  }

  void setSelectedCity(City? newValue) {
    _selectedCity = newValue;
    notifyListeners();
  }

  void setSelectedFromDateTime(DateTime? dateTime) {
    fromDateTime = dateTime;
    notifyListeners();
  }

  void setSelectedToDateTime(DateTime? dateTime) {
    toDateTime = dateTime;
    notifyListeners();
  }

  void removeImages(int removeImageIndex) {
    selectedImages.removeAt(removeImageIndex);
    notifyListeners();
  }

  void setSelectedCategory(Category? newValue) {
    if (_selectedCategory != newValue) {
      _selectedSubCategory = null;
    }
    _selectedCategory = newValue;
    fetchSubCategories(_selectedCategory!.id.toString());
    notifyListeners();
  }

  void setSelectedSubCategory(SubCategory? newValue) {
    _selectedSubCategory = newValue;
    notifyListeners();
  }

  void setTitle(String? newValue) {
    title = newValue;
    notifyListeners();
  }

  void setDescription(String? newValue) {
    desc = newValue;
    notifyListeners();
  }

  void setImage(String imagePath) {
    selectedImages.add(imagePath);
    notifyListeners();
  }

  Future<List<City>> fetchCities() {
    return AppGeneralRepo().getCities();
  }

  Future<List<Category>> fetchCategories() {
    return AdApiClient().getEqCategoryList();
  }

  void fetchSubCategories(String categoryId) {
    getSubCategoryFuture = AdApiClient().getEqSubCategoryList(categoryId);
    notifyListeners();
  }

  void handleLocationSelected(Map<String, dynamic> result) {
    selectedPoint = result['selectedPoint'] as LatLng?;
    address = result['address'] as String?;
    notifyListeners();
  }

  Future<bool> uploadAdClient() async {
    final url = '${ApiEndPoints.baseUrl}/equipment/ad_equipment_client';
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
          if (fromDateTime != null)
            'start_lease_date': DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS'Z'")
                .format(fromDateTime!),
          if (toDateTime != null)
            'end_lease_date': DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS'Z'")
                .format(toDateTime!),
          'price': double.tryParse(priceController.text.trim()) ?? 0,
          'city_id': selectedCity?.id,
          'equipment_subcategory_id': selectedSubCategory?.id,
          'latitude': selectedPoint?.latitude,
          'longitude': selectedPoint?.longitude,
          'address': address,
        })
      });
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
      if (response.statusCode == 200 || response.statusCode == 500) {
        
        final map = response.data as Map<String, dynamic>;
        return true;
      } else {
        BotToast.showText(text: 'Error');
        return false;
      }
    } on DioException catch (e) {
      log(e.toString());
      if (e.response != null) {
        log(e.response?.data.toString() ?? 'dd');
        log(e.response?.headers.toString() ?? 'null response');
        log(e.response?.requestOptions.toString() ?? 'null response');
      } else {
        log(e.requestOptions.toString());
        log(e.message.toString());
      }

      log(e.toString(), name: 'Error on add ADS');
      return false;
    }
  }

  Future<bool> editOrUpdateAdClient() async {
    try {
      final data = await adEquipmentRepository.editORUpdateADClient(
          id: editID!,
          description:
              descriptionController.text.trim().capitalizeFirstLetter(),
          address: address ?? '',
          cityID: selectedCity?.id ?? 0,
          latitude: _selectedPoint?.latitude ?? 0,
          longitude: _selectedPoint?.longitude ?? 0,
          price: double.tryParse(priceController.text.trim()) ?? 0,
          serviceSubcategoryID: _selectedSubCategory?.id ?? 0,
          startLeaseDate: fromDateTime ?? DateTime.now(),
          images: selectedImages,
          title: headerController.text.trim().capitalizeFirstLetter());
      return data;
    } on Exception catch (e) {
      return false;
    }
  }

  void clearEndTime() {
    toDate = null;
    toTime = null;
    toDateTime = null;
    notifyListeners();
  }

  void toggleEndTime(bool? newValue) {
    isEndTimeEnabled = newValue;
    if (newValue == false) {
      clearEndTime();
    }
    notifyListeners();
  }

  int? calculateHoursDifference() {
    if (fromDate != null &&
        fromTime != null &&
        toDate != null &&
        toTime != null) {
      fromDateTime = DateTime(
        fromDate!.year,
        fromDate!.month,
        fromDate!.day,
        fromTime!.hour,
        fromTime!.minute,
      );
      toDateTime = DateTime(
        toDate!.year,
        toDate!.month,
        toDate!.day,
        toTime!.hour,
        toTime!.minute,
      );

      final totalHoursDifference =
          toDateTime!.difference(fromDateTime!).inHours;

      return totalHoursDifference;
    }

    return 0;
  }

  bool checkDateTime(DateTime? dateTime) {
    if (dateTime != null) {
      if (dateTime.isBefore(fromDateTime!)) {
        return false;
      }
    }
    return true;
  }
}
