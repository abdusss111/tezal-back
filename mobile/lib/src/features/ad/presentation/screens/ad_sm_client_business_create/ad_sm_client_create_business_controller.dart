import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';

import 'package:eqshare_mobile/src/core/data/services/network/api_client/user_profile_api_client.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_snack_bar.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/core/res/extensions/string_extensions.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_api_client.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/sm_request_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/data/models/cities/city/city_model.dart';

import '../../../../../core/data/services/storage/token_provider_service.dart';

import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';

class AdSmClientCreateBusinessController extends AppSafeChangeNotifier {
  bool? isEndTimeEnabled = false;
  DateTime? fromDate;
  DateTime? fromDateTime;
  TimeOfDay? fromTime;
  DateTime? toDate;
  DateTime? toDateTime;
  TimeOfDay? toTime;
  LatLng? _selectedPoint;
  String price = '';

  ServiceTypeEnum? serviceType = ServiceTypeEnum.MACHINARY;

  final adRepo = SMRequestRepositoryImpl();

  void changeValue() {
    notifyListeners();
  }

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

  void setPrice(String? value) {
    price = value ?? price;
    notifyListeners();
  }

  TextEditingController headerController = TextEditingController();
  TextEditingController clientNameController = TextEditingController();
  TextEditingController clientPhoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  bool isLoading = true;

  Future<List<SubCategory>> futureSubCategories = Future.value([]);
  final _workersApiClient = UserProfileApiClient();

  City? _selectedCity;
  Category? _selectedCategory;
  User? _selectedUser;
  SubCategory? _selectedSubCategory;

  File? selectedImage;
  List selectedImages = ['place_holder'];

  late List<City> cities = [];
  late List<Category> categories = [];
  late List<SubCategory> subCategories = [];
  late List<User> workers = [];

  City? get selectedCity => _selectedCity;

  Category? get selectedCategory => _selectedCategory;

  User? get selectedWorker => _selectedUser;

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

  void setSelectedWorker(User? newValue) {
    _selectedUser = newValue;
    notifyListeners();
  }

  void setServiceType(ServiceTypeEnum? newValue) {
    serviceType = newValue;
    notifyListeners();
  }

  void setSelectedSubCategory(SubCategory? newValue) {
    _selectedSubCategory = newValue;
    notifyListeners();
  }

  Future<List<Category>> fetchCategories() {
    return AdApiClient().getSMCategoryList();
  }

  void fetchSubCategories(String categoryId) {
    futureSubCategories = AdApiClient().getSmSubCategoryList(categoryId);
    notifyListeners();
  }

  Future<List<User>> loadMyWorkers(BuildContext context) async {
    final _workers = <User>[];
    try {
      final token = await TokenService().getToken();
      if (token == null) return [];
      if (!context.mounted) return [];

      final payload = TokenService().extractPayloadFromToken(token);
      final users = await _workersApiClient.getMyWorkers(
        payload.sub ?? '1',
      );
      if (users != null) {
        _workers.addAll(users);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('$e');
    }
    return _workers;
  }

  Future<List<User>> fetchMyWorkers() async {
    final token = await TokenService().getToken();
    if (token == null) return [];

    final payload = TokenService().extractPayloadFromToken(token);
    final users = await _workersApiClient.getMyWorkers(
      payload.sub ?? '1',
    );
    return users ?? [];
  }

  void handleLocationSelected(Map<String, dynamic> result) {
    selectedPoint = result['selectedPoint'] as LatLng?;
    address = result['address'] as String?;
    notifyListeners();
  }

  Future<bool> uploadAdClient() async {
    final url = '${ApiEndPoints.baseUrl}/re/without_the_client';
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = await TokenService().getToken();
    headers['Authorization'] = 'Bearer $token';

    try {
      final Map<String, dynamic> base = {
        'title': headerController.text.trim().capitalizeFirstLetter(),
        'wtc_full_name_client': clientNameController.text.trim(),
        'wtc_phone_number': clientPhoneController.text.trim(),
        'assigned': selectedWorker?.id ?? 0,
        'driver_id': selectedWorker?.id ?? 0,
        'start_lease_at': fromDateTime != null
            ? DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS'Z'")
                .format(fromDateTime!)
            : null,
        'end_lease_at': toDateTime != null
            ? DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS'Z'")
                .format(toDateTime!)
            : null,
        'finish_address': address ?? '',
        'finish_latitude': selectedPoint?.latitude ?? 0,
        'finish_longitude': selectedPoint?.longitude ?? 0,
        'src': serviceType?.name,
      };

      // Convert the base map to JSON
      final String baseJson = jsonEncode(base);

      final formData = FormData.fromMap({
        'base': baseJson,
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

      if (response.statusCode == 200) {
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
        throw e.response?.data.toString() ?? 'Error';
      } else {
        throw 'Unknown error';
      }
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

        bool isValidTimeOfDay = pickedToTime.hour > fromTime!.hour ||
            (pickedToTime.hour == fromTime!.hour &&
                pickedToTime.minute > fromTime!.minute);

        if (isValidTimeOfDay &&
            pickedToDateTime.isAfter(pickedFromDateTime) &&
            pickedToTime != fromTime) {
          toDate = pickedToDate;
          toTime = pickedToTime;
          toDateTime = pickedToDateTime;
          notifyListeners();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              AppSnackBar.showErrorSnackBar(
                  'Время начала должен быть раньше, чем время окончания работы'));
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
