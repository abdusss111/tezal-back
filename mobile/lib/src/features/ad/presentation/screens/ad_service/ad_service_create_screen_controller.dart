import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/models/brand/brand.dart';
import 'package:eqshare_mobile/src/core/data/repositories/app_general_repo.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/utils/create_ad_or_request_enum.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import 'package:eqshare_mobile/src/core/data/models/cities/city/city_model.dart';

class AdServiceCreateScreenController extends AppSafeChangeNotifier {
  final CreateAdOrRequestEnum requestEnum;
  final int? getEditID;

  AdServiceCreateScreenController({required this.requestEnum, this.getEditID}) {
    _init();
  }
  final adServiceRepo = AdServiceRepository();

  Future<List<Category>>? getCategory;
  Future<List<SubCategory>>? getSubCategoryFuture;
  Future<List<City>>? getCityFuture;

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  final TextEditingController priceController = TextEditingController();

  List<String> selectedImages = [];

  List<String> networkImages = [];

  bool isEndTimeEnabled = false;
  DateTime? pickedDatetime;
  DateTime? endedDatetime;

  String? address;
  Category? selectedCategory;
  SubCategory? selectedSubCategory;
  City? city;
  LatLng? latLng;
  Brand? brand;
  String price = '';

  String title = '';
  String description = '';

  void _init() {
    if (getEditID != null) {
      _initGetEditValue(getEditID!);
    } else {
      _isLoading = false;
      notifyListeners();
    }
    getCategory = adServiceRepo.getAdServiceListCategory();
    getSubCategoryFuture =
        adServiceRepo.getAdServiceListSubCategory(categoryID: null);
    getCityFuture = AppGeneralRepo().getCities();
  }

  Future<void> _initGetEditValue(int adID) async {
    if (requestEnum == CreateAdOrRequestEnum.ad) {
      final ad = await adServiceRepo.getAdServiceDetailForClient(
          adID: adID.toString());
      title = ad?.title ?? '';
      description = ad?.description ?? '';
      price = (ad?.price ?? '').toString();
      selectedSubCategory = ad?.subcategory;
      selectedCategory = await adServiceRepo
          .getAdServiceCategoryWithID(selectedSubCategory?.mainCategoryID ?? 0);
      address = ad?.address;
      latLng = LatLng(ad?.latitude ?? 0, ad?.longitude ?? 0);
      city = City(id: ad?.city?.id ?? 0, name: ad?.city?.name ?? '');
      networkImages = ad?.urlFoto ?? [];
    } else {
      final ad = await adServiceRepo.getAdServiceDetailForDriverOrOwner(
          adID: adID.toString());
      title = ad?.title ?? '';
      description = ad?.description ?? '';
      price = (ad?.price ?? '').toString();
      selectedSubCategory = ad?.subcategory;
      selectedCategory = await adServiceRepo
          .getAdServiceCategoryWithID(selectedSubCategory?.mainCategoryID ?? 0);
      address = ad?.address;
      latLng = LatLng(ad?.latitude ?? 0, ad?.longitude ?? 0);
      city = City(id: ad?.city?.id ?? 0, name: ad?.city?.name ?? '');
      pickedDatetime = DateTimeUtils()
          .formatDateFromyyyyMMddTHHmmssSSSSSSSS(ad?.startLeaseDate);
      if (ad?.endLeaseDate != null) {
        endedDatetime = DateTimeUtils()
            .formatDateFromyyyyMMddTHHmmssSSSSSSSS(ad?.endLeaseDate);
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

  void changeTitle(String value) {
    title = value;
    notifyListeners();
  }

  void changeDescription(String value) {
    description = value;
    notifyListeners();
  }

  void changeisprice(String value) {
    price = value;
    notifyListeners();
  }

  void changeisEndTimeEnabled() {
    isEndTimeEnabled = !isEndTimeEnabled;
    endedDatetime = null;
    notifyListeners();
  }

  bool checkTimeIsBefore(DateTime? value) {
    if (value != null) {
      if (value.isBefore(pickedDatetime!)) {
        return true;
      }
    }
    return false;
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
        price.isNotEmpty &&
        description.isNotEmpty &&
        title.isNotEmpty &&
        selectedCategory != null &&
        selectedSubCategory != null &&
        pickedDatetime != null &&
        (isEndTimeEnabled ? endedDatetime != null : true);
  }

  bool isValidForForDriverOrOwner() {
    return address?.isNotEmpty == true &&
        price.isNotEmpty &&
        description.isNotEmpty &&
        title.isNotEmpty &&
        selectedCategory != null &&
        selectedSubCategory != null;
  }

  Future<bool> editClientAdService(
      {required String priceText,
      required String descriptionText,
      required String headlineText}) async {
    final value = await adServiceRepo.editClientAdService(
        id: getEditID!,
        description: descriptionText,
        address: address!,
        cityID: city!.id,
        userID: int.parse(AppChangeNotifier().payload?.sub ?? '-1'),
        latitude: latLng!.latitude,
        images: selectedImages,
        longitude: latLng!.longitude,
        endLeaseDate: endedDatetime,
        price: double.tryParse(priceText) ?? 0,
        serviceSubcategoryID: selectedSubCategory!.id!,
        startLeaseDate: pickedDatetime!,
        status: RequestStatus.CREATED.name,
        title: headlineText);

    return value;
  }

  Future<bool> uploadClientAdService(
      {required String priceText,
      required String descriptionText,
      required String headlineText}) async {
    final value = await adServiceRepo.postClientAdService(
        description: descriptionText,
        address: address!,
        cityID: city!.id,
        latitude: latLng!.latitude,
        images: selectedImages,
        longitude: latLng!.longitude,
        endLeaseDate: endedDatetime,
        price: double.tryParse(priceText) ?? 0,
        serviceSubcategoryID: selectedSubCategory!.id!,
        startLeaseDate: pickedDatetime!,
        status: RequestStatus.CREATED.name,
        title: headlineText);

    return value;
  }

  Future<bool> uploadDriverOrOwnerAdService(
      {required String priceText,
      required String descriptionText,
      required String headlineText}) async {
    final result = await adServiceRepo.postDriverOrOwnerAdService(
        description: descriptionText,
        title: headlineText,
        address: address!,
        price: int.tryParse(priceText) ?? 0,
        serviceBrandId: 1, //!!! Почините потом
        serviceSubCategoryID: selectedSubCategory!.id!,
        latitude: latLng!.latitude,
        longitude: latLng!.longitude,
        images: selectedImages,
        cityID: city!.id);
    return result;
  }

  Future<bool> editDriverOrOwnerAdService(
      {required String priceText,
      required String descriptionText,
      required String headlineText}) async {
    final result = await adServiceRepo.updateDriverOrOwnerAdService(
        id: getEditID.toString(),
        userID: int.parse(AppChangeNotifier().payload?.sub ?? '-1'),
        description: descriptionText,
        title: headlineText,
        address: address!,
        price: int.tryParse(priceText) ?? 0,
        serviceBrandId: 1, //!!! Почините потом
        serviceSubCategoryID: selectedSubCategory!.id!,
        latitude: latLng!.latitude,
        longitude: latLng!.longitude,
        images: selectedImages,
        cityID: city!.id);
    return result;
  }
}
