import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/models/brand/brand.dart';
import 'package:eqshare_mobile/src/core/data/repositories/app_general_repo.dart';
import 'package:eqshare_mobile/src/core/data/models/cities/city/city_model.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/utils/create_ad_or_request_enum.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_construction_materials_repository.dart';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';

class AdConstructionCreateScreenController extends AppSafeChangeNotifier {
  final adServiceRepo = AdConstructionMaterialsRepository();

  var key = UniqueKey();

  final TextEditingController priceController = TextEditingController();

  final int? getEditAd;

  final CreateAdOrRequestEnum requestEnum;

  Future<List<Category>>? getCategory;
  Future<List<SubCategory>>? getSubCategoryFuture;
  Future<List<City>>? getCityFuture;

  AdConstructionCreateScreenController(
      {this.getEditAd, required this.requestEnum}) {
    init();
  }

  void init() async {
    if (getEditAd != null) {
      await _initGetEditValue(getEditAd ?? 0);
    } else {
      _isLoading = false;
      notifyListeners();
    }
    getCategory = adServiceRepo.getAdConstrutionListCategory();
    getSubCategoryFuture =
        adServiceRepo.getConstructionMaterialListSubCategory(categoryID: null);
    getCityFuture = AppGeneralRepo().getCities();
  }

  Future<void> _initGetEditValue(int adID) async {
    if (requestEnum == CreateAdOrRequestEnum.ad) {
      final ad = await adServiceRepo.getAdConstructionMaterialDetailForClient(
          adID: adID.toString());
      title = ad?.title ?? '';
      description = ad?.description ?? '';
      price = (ad?.price ?? '').toString();
      selectedSubCategory = ad?.constructionMaterialSubCategory;
      selectedCategory = await adServiceRepo.getAdConstrutionCategoryWithID(
          selectedSubCategory?.mainCategoryID ?? 0);
      brand = ad?.constructionMaterialBrand;
      address = ad?.address;
      latLng = LatLng(ad?.latitude ?? 0, ad?.longitude ?? 0);
      city = City(id: ad?.city?.id ?? 0, name: ad?.city?.name ?? '');
      networkImages = ad?.urlFoto ?? [];
    } else {
      final ad =
          await adServiceRepo.getAdConstructionMaterialDetailForDriverOrOwner(
              adID: adID.toString());
      title = ad?.title ?? '';
      description = ad?.description ?? '';
      price = (ad?.price ?? '').toString();
      selectedSubCategory = ad?.constructionMaterialSubCategory;
      selectedCategory = await adServiceRepo.getAdConstrutionCategoryWithID(
          selectedSubCategory?.mainCategoryID ?? 0);
      brand = ad?.constructionMaterialBrand;
      address = ad?.address;
      latLng = LatLng(ad?.latitude ?? 0, ad?.longitude ?? 0);
      city = City(id: ad?.city?.id ?? 0, name: ad?.city?.name ?? '');
      pickedDatetime = ad?.startLeaseDate;
      if (ad?.endLeaseDate != null) {
        endedDatetime = ad?.endLeaseDate;
        isEndTimeEnabled = true;
      }
      networkImages = ad?.urlFoto ?? [];
    }
    _isLoading = false;
    notifyListeners();
  }

  void onChange() {
    notifyListeners();
  }

  void changeisprice(String value) {
    price = value;
    notifyListeners();
  }

  void changeTitle(String value) {
    title = value;
    notifyListeners();
  }

  void changeDescription(String value) {
    description = value;
    notifyListeners();
  }

  List<String> selectedImages = [];
  List<String> networkImages = [];

  Future<List<SubCategory>>? getSubCategory() {
    return adServiceRepo.getConstructionMaterialListSubCategory(
        categoryID: selectedCategory?.id);
  }

  bool isEndTimeEnabled = false;
  DateTime? pickedDatetime;
  DateTime? endedDatetime;

  String? address;
  Category? selectedCategory;
  SubCategory? selectedSubCategory;
  City? city;
  LatLng? latLng;
  Brand? brand;

  String title = '';
  String description = '';

  String price = '';

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  void changeisEndTimeEnabled() {
    isEndTimeEnabled = !isEndTimeEnabled;
    endedDatetime = null;
    notifyListeners();
  }

  // Присвоение значения адресу и уведомление слушателей
  void changeAddress(String? newAddress) {
    address = newAddress;
    notifyListeners();
  }

// Присвоение значения категории и уведомление слушателей
  void changeSelectedCategory(Category? newCategory) {
    if (selectedCategory != newCategory) {
      selectedSubCategory = null;
    }
    selectedCategory = newCategory;
    key = UniqueKey();
    notifyListeners();
  }

// Присвоение значения подкатегории и уведомление слушателей
  void changeSelectedSubCategory(SubCategory? newSubCategory) {
    selectedSubCategory = newSubCategory;
    notifyListeners();
  }

// Присвоение значения города и уведомление слушателей
  void changeCity(City? newCity) {
    city = newCity;
    notifyListeners();
  }

// Присвоение значения координат и уведомление слушателей
  void changeLatLng(LatLng? newLatLng) {
    latLng = newLatLng;
    notifyListeners();
  }

// Присвоение значения бренда и уведомление слушателей
  void changeBrand(Brand? newBrand) {
    brand = newBrand;
    notifyListeners();
  }

// Переключение состояния isEndTimeEnabled и уведомление слушателей
  void toggleIsEndTimeEnabled() {
    isEndTimeEnabled = !isEndTimeEnabled;
    notifyListeners();
  }

// Установка выбранной даты и уведомление слушателей
  void changePickedDatetime(DateTime? dateTime) {
    pickedDatetime = dateTime;
    notifyListeners();
  }

// Установка даты окончания и уведомление слушателей
  void changeEndedDatetime(DateTime? dateTime) {
    endedDatetime = dateTime;
    notifyListeners();
  }

  bool checkDateTime(DateTime? dateTime) {
    if (dateTime != null) {
      if (dateTime.isBefore(pickedDatetime!)) {
        return false;
      }
    }
    return true;
  }

  void addImages(String imagePath) {
    selectedImages.add(imagePath);
    notifyListeners();
  }

  void removeImages(int index) {
    selectedImages.removeAt(index);
    notifyListeners();
  }

  int? calculateHoursDifference() {
    final totalHoursDifference =
        endedDatetime!.difference(pickedDatetime!).inHours;

    return totalHoursDifference;
  }

  bool isValidForm() {
    return address?.isNotEmpty == true &&
        (priceController.text.isNotEmpty || price.isNotEmpty) &&
        description.isNotEmpty &&
        title.isNotEmpty &&
        selectedCategory != null &&
        selectedSubCategory != null &&
        pickedDatetime != null &&
        (isEndTimeEnabled ? endedDatetime != null : true);
  }

  bool isValidForForDriverOrOwner() {
    return (address != null && address!.isNotEmpty) &&
        (priceController.text.isNotEmpty || price.isNotEmpty) &&
        description.isNotEmpty &&
        title.isNotEmpty &&
        selectedCategory != null &&
        brand != null &&
        latLng != null &&
        selectedSubCategory != null;
  }

  Future<bool> editClientAd({
    required String priceText,
    required String descriptionText,
    required String headlineText,
  }) async {
    final payload = {
      'description': descriptionText,
      'address': address,
      'cityID': city?.id,
      'id': getEditAd,
      'userID': int.tryParse(AppChangeNotifier().payload?.sub ?? '-1'),
      'latitude': latLng?.latitude,
      'longitude': latLng?.longitude,
      'price': double.tryParse(priceController.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0,
      'subcategoryID': selectedSubCategory?.id,
      'startLeaseDate': pickedDatetime?.toIso8601String(),
      'status': RequestStatus.CREATED.name,
      'title': headlineText,
      'images': selectedImages,
    };

    // 🔍 Лог перед отправкой
    print('📦 PATCH PAYLOAD (editClientAd):');
    payload.forEach((key, value) => print('  $key: $value'));

    final value = await adServiceRepo.patchOrEditClientAdConstructionMaterial(
      description: descriptionText,
      address: address!,
      cityID: city!.id,
      id: getEditAd!,
      userID: int.parse(AppChangeNotifier().payload?.sub ?? '-1'),
      latitude: latLng!.latitude,
      longitude: latLng!.longitude,
      price: double.tryParse(priceController.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0,
      subcategoryID: selectedSubCategory!.id!,
      startLeaseDate: pickedDatetime!,
      status: RequestStatus.CREATED.name,
      title: headlineText,
      images: selectedImages,
    );

    return value;
  }

  Future<bool> uploadClientAd(
      {required String priceText,
      required String descriptionText,
      required String headlineText}) async {
    final value = await adServiceRepo.postClientAdConstructionMaterial(
        description: descriptionText,
        address: address!,
        cityID: city!.id,
        latitude: latLng!.latitude,
        images: selectedImages,
        longitude: latLng!.longitude,
        price: double.tryParse(priceController.text) ?? 0,
        subcategoryID: selectedSubCategory!.id!,
        startLeaseDate: pickedDatetime!,
        status: RequestStatus.CREATED.name,
        title: headlineText);

    return value;
  }

  Future<bool> uploadDriverOrOwnerAd(
      {required String priceText,
      required String descriptionText,
      required String headlineText}) async {
    final result = await adServiceRepo.postDriverOrOwnerAdConstructionMaterial(
        description: descriptionText,
        title: headlineText,
        address: address!,
        price: int.tryParse(priceController.text) ?? 0,
        brandId: brand!.id!,
        subCategoryID: selectedSubCategory!.id!,
        latitude: latLng!.latitude,
        longitude: latLng!.longitude,
        images: selectedImages,
        cityID: city!.id);
    return result;
  }

  Future<bool> editDriverOrOwnerAd(
      {required String priceText,
      required String descriptionText,
      required String headlineText}) async {
    final result =
        await adServiceRepo.patchOrEditDriverOrOwnerAdConstructionMaterial(
            description: descriptionText,
            userID: int.parse(AppChangeNotifier().payload?.sub ?? '-1'),
            id: getEditAd!,
            title: headlineText,
            address: address!,
            price: int.tryParse(priceController.text) ?? 0,
            brandId: brand!.id!,
            subCategoryID: selectedSubCategory!.id!,
            latitude: latLng!.latitude,
            longitude: latLng!.longitude,
            images: selectedImages,
            cityID: city!.id);
    return result;
  }
}
