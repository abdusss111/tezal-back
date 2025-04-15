import 'dart:io';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/repositories/app_general_repo.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_api_client.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/sm_request_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import 'package:eqshare_mobile/src/core/res/extensions/string_extensions.dart';

import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import '../../../../../../../core/data/models/cities/city/city_model.dart';

import '../../../../../../../core/data/services/storage/token_provider_service.dart';

class AdSMClientCreateController extends AppSafeChangeNotifier {
  bool? isEndTimeEnabled = false;
  DateTime? fromDate;
  DateTime? fromDateTime;
  TimeOfDay? fromTime;
  DateTime? toDate;
  DateTime? toDateTime;
  TimeOfDay? toTime;
  LatLng? _selectedPoint;

  String? _address;

  String? get address => _address;
  Future<void> getADClient(int id) async {
    final ad = await adApiClient.getAdSMClientDetail(id.toString());
    descriptionController.text = ad?.description ?? '';
    headerController.text = ad?.headline ?? '';
    priceController.text = (ad?.price ?? 0).toString();
    _selectedPoint = LatLng(ad?.latitude ?? 0, ad?.longitude ?? 0);
    _selectedCity = City(id: ad?.city?.id ?? 0, name: ad?.city?.name ?? '');
    _selectedSubCategory = ad?.type;
    if (_selectedSubCategory?.mainCategoryID != null) {
      try {
        log('Пробуем загрузить категорию по ID: ${_selectedSubCategory!.mainCategoryID}');
        _selectedCategory = await adApiClient
            .getSMCategoryWithID(_selectedSubCategory!.mainCategoryID)
            .timeout(const Duration(seconds: 5));
        log('Категория успешно загружена: ${_selectedCategory?.name}');
      } catch (e) {
        log('Ошибка при загрузке категории: $e');
      }
    } else {
      log('mainCategoryID у подкатегории отсутствует!');
    }

    _address = ad?.address;

    fromDateTime =
        DateTimeUtils().formatDateFromyyyyMMddTHHmmssSSSSSSSS(ad?.startDate);
    fromDate = fromDateTime;
    fromTime = TimeOfDay.fromDateTime(fromDateTime ?? DateTime.now());
    if (ad?.endDate != null && ad!.endDate is String) {
      try {
        isEndTimeEnabled = true;
        toDateTime = DateTimeUtils().formatDateFromyyyyMMddTHHmmssSSSSSSSS(ad.endDate);
        toDate = toDateTime;
        toTime = TimeOfDay.fromDateTime(toDateTime!);
      } catch (e) {
        log('Ошибка при парсинге endDate: $e');
      }
    }

    // networkImages= ad?.
    isLoading = false;
    notifyListeners();
  }

  LatLng? get selectedPoint => _selectedPoint;

  final adrepo = SMRequestRepositoryImpl();
  final adApiClient = AdApiClient();

  final int? editID;
  AdSMClientCreateController({this.editID}) {
    _init();
  }

  void _init() async {
    if (editID != null) {
      await getADClient(editID!);
    } else {
      isLoading = false;
      notifyListeners();
    }
  }

  void onChange() {
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

  bool isLoading = true;

  Future<List<SubCategory>> futureSubCategories = Future.value([]);

  City? _selectedCity;
  Category? _selectedCategory;
  SubCategory? _selectedSubCategory;
  String? header = '';
  String? desc = '';

  File? selectedImage;
  List<String> selectedImages = [];
  List<String> networkImages = [];

  late List<City> cities = [];
  late List<Category> categories = [];
  late List<SubCategory> subCategories = [];

  City? get selectedCity => _selectedCity;
  Category? get selectedCategory => _selectedCategory;
  SubCategory? get selectedSubCategory => _selectedSubCategory;

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

  void setStartDateTime(DateTime? newValue) {
    fromDateTime = newValue;
    notifyListeners();
  }

  void setEndDateTime(DateTime? newValue) {
    toDateTime = newValue;
    notifyListeners();
  }

  void setEndDateTimeEnabled(bool? newValue) {
    isEndTimeEnabled = newValue;
    notifyListeners();
  }

  void setTitle(String? newValue) {
    header = newValue;
    notifyListeners();
  }

  void setDescription(String? newValue) {
    desc = newValue;
    notifyListeners();
  }

  void setPrice(String? newValue) {
    priceController.text = newValue ?? '';
    notifyListeners();
  }

  void setPoint(LatLng? newValue) {
    _selectedPoint = newValue;
    notifyListeners();
  }

  void setAddress(String? newValue) {
    _address = newValue;
    notifyListeners();
  }

  bool isValidForm() {
    return address?.isNotEmpty == true &&
            priceController.text.isNotEmpty &&
            desc != null &&
            desc!.length > 2 &&
            headerController.text.isNotEmpty &&
            selectedCategory != null &&
            selectedSubCategory != null &&
            isEndTimeEnabled!
        ? fromTime != null
        : true && fromDateTime != null;
  }

  Future<List<City>> fetchCities() {
    return AppGeneralRepo().getCities();
  }

  Future<List<Category>> fetchCategories() {
    return AdApiClient().getSMCategoryList();
  }

  bool checkTimeIsBefore(DateTime? value) {
    if (value != null) {
      if (value.isBefore(fromDateTime!)) {
        return true;
      }
    }
    return false;
  }

  void fetchSubCategories(String categoryId) {
    futureSubCategories = AdApiClient().getSmSubCategoryList(categoryId);
    notifyListeners();
  }

  void handleLocationSelected(Map<String, dynamic> result) {
    selectedPoint = result['selectedPoint'] as LatLng?;
    address = result['address'] as String?;
    notifyListeners();
  }

  Future<bool> uploadAdClient() async {
    final url = '${ApiEndPoints.baseUrl}/ad_client/';
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = await TokenService().getToken();
    headers['Authorization'] = 'Bearer $token';

    final fromDataMap = {
      'headline': headerController.text.trim().capitalizeFirstLetter(),
      'description': descriptionController.text.trim().capitalizeFirstLetter(),
      if (fromDateTime != null)
        'start_date': DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS'Z'")
            .format(fromDateTime!),
      if (toDateTime != null)
        'end_date': DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS'Z'")
            .format(toDateTime!),
      'price': (int.tryParse(priceController.text.trim()) ?? 0).toString(),
      'city_id': selectedCity?.id.toString(),
      'type_id': selectedSubCategory?.id.toString(),
      'latitude': selectedPoint?.latitude,
      'longitude': selectedPoint?.longitude,
      'address': address,
    };
    final formData = FormData.fromMap(fromDataMap);

    log(fromDataMap.toString(), name: 'Name formData: ');

    for (int i = 0; i < selectedImages.length; i++) {
      if (selectedImages[i] == 'place_holder') continue;
      File imageFile = File(selectedImages[i]);

      formData.files.add(MapEntry(
        'documents',
        await MultipartFile.fromFile(imageFile.path),
      ));
    }
    try {
      final Dio dio = Dio();

      // (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      //   final client = HttpClient();
      //   client.badCertificateCallback = (cert, host, port) => true;
      //   return client;
      // };

      final response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: headers,
        ),
      );
      log(response.toString(), name: 'Response');
      if (response.statusCode == 200 || response.statusCode == 500) {
        final map = response.data as Map<String, dynamic>;
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
        if (e.response?.statusCode == 500) {
          return true;
        }
      } else {
        return false;
      }

      log(e.toString());

      return false;
    }
  }

  Future<bool> editAdClient() async {
    final url = '${ApiEndPoints.baseUrl}/ad_client/$editID';
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = await TokenService().getToken();
    headers['Authorization'] = 'Bearer $token';

    final fromDataMap = {
      'headline': headerController.text.trim().capitalizeFirstLetter(),
      'description': descriptionController.text.trim().capitalizeFirstLetter(),
      if (fromDateTime != null)
        'start_date': DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS'Z'")
            .format(fromDateTime!),
      if (toDateTime != null)
        'end_date': DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS'Z'")
            .format(toDateTime!),
      'price': (int.tryParse(priceController.text) ?? 0).toString(),
      'city_id': selectedCity?.id.toString(),
      'type_id': selectedSubCategory?.id.toString(),
      'latitude': selectedPoint?.latitude,
      'longitude': selectedPoint?.longitude,
      'address': address,
    };
    final formData = FormData.fromMap(fromDataMap);

    log(fromDataMap.toString(), name: 'Name formData: ');

    for (int i = 0; i < selectedImages.length; i++) {
      if (selectedImages[i] == 'place_holder') continue;
      File imageFile = File(selectedImages[i]);

      formData.files.add(MapEntry(
        'documents',
        await MultipartFile.fromFile(imageFile.path),
      ));
    }
    try {
      final Dio dio = Dio();
      final response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: headers,
        ),
      );
      log(response.toString(), name: 'Response');
      if (response.statusCode == 200) {
        final map = response.data as Map<String, dynamic>;
        if (map['status'] == 'Successfully added') {
          return true;
        } else {
          return false;
        }
      }
    } on DioException catch (e) {
      log(e.toString());
      throw e.response?.data.toString() ?? 'dd';
    }
    return false;
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

  Future<void> showFirstDateTimePicker(BuildContext context) async {
    final pickedFromDate = await DateTimeUtils.showAppDatePicker(context);
    if (pickedFromDate != null) {
      if (!context.mounted) return;
      final pickedFromTime = await DateTimeUtils.showAppTimePicker(context);
      if (pickedFromTime != null) {
        if (!context.mounted) return;
        fromDate = pickedFromDate;
        fromTime = pickedFromTime;

        fromDateTime = DateTime(
          fromDate!.year,
          fromDate!.month,
          fromDate!.day,
          fromTime!.hour,
          fromTime!.minute,
        );
        notifyListeners();
      }
    }
  }

  Future<void> showSecondDateTimePicker(BuildContext context) async {
    final pickedToDate = await DateTimeUtils.showAppDatePicker(context);
    if (pickedToDate != null) {
      if (!context.mounted) return;
      final pickedToTime = await DateTimeUtils.showAppTimePicker(context);
      if (pickedToTime != null) {
        if (!context.mounted) return;

        final DateTime pickedFromDateTime = DateTime(
          fromDate!.year,
          fromDate!.month,
          fromDate!.day,
          fromTime!.hour,
          fromTime!.minute,
        );
        final DateTime pickedToDateTime = DateTime(
          pickedToDate.year,
          pickedToDate.month,
          pickedToDate.day,
          pickedToTime.hour,
          pickedToTime.minute,
        );

        if (pickedToDateTime.isAfter(pickedFromDateTime) &&
            pickedToTime != fromTime) {
          toDate = pickedToDate;
          toTime = pickedToTime;
          toDateTime = pickedToDateTime;
          notifyListeners();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Время начала должен быть раньше, чем время окончания работы'),
            ),
          );
        }
      }
    }
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
}
