import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/presentation/services/image_picker_service.dart';

import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_snack_bar.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/core/res/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../../../core/data/services/storage/token_provider_service.dart';
import '../../../../../../../core/presentation/routing/app_route.dart';

class AdSMRequestCreateController extends AppSafeChangeNotifier {
  bool? isEndTimeEnabled = false;
  DateTime? fromDate;
  DateTime? fromDateTime;
  TimeOfDay? fromTime;
  DateTime? toDate;
  DateTime? toDateTime;
  TimeOfDay? toTime;
  final TextEditingController descriptionController = TextEditingController();
  File? selectedImage;
  List selectedImages = ['place_holder'];
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

  bool isValid() {
    return descriptionController.text.isNotEmpty &&
            address != null &&
            address!.isNotEmpty &&
            fromDate != null &&
            fromTime != null &&
            isEndTimeEnabled!
        ? (toDate != null && toTime != null)
        : true;
  }

  void handleLocationSelected(Map<String, dynamic> result) {
    selectedPoint = result['selectedPoint'] as LatLng?;
    address = result['address'] as String?;
    notifyListeners();
  }

  Future<bool> _uploadAdSMRequest(
      {required File? file,
      required String adSMId,
      required double adSMPrice}) async {
    final url = '${ApiEndPoints.baseUrl}/smr/';

    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = await TokenService().getToken();
    headers['Authorization'] = 'Bearer $token';
    try {
      final formData = FormData.fromMap({
        'ad_specialized_machinery_id': adSMId,
        if (fromDateTime != null)
          'start_lease_at': DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS'Z'")
              .format(fromDateTime!),
        if (toDateTime != null)
          'end_lease_at': DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS'Z'")
              .format(toDateTime!),
        'description':
            descriptionController.text.trim().capitalizeFirstLetter(),
        'address': address,
        'latitude': selectedPoint?.latitude,
        'longitude': selectedPoint?.longitude,
      });
      for (int i = 0; i < selectedImages.length; i++) {
        if (selectedImages[i] == 'place_holder') continue;
        File imageFile = File(selectedImages[i]);
        formData.files.add(MapEntry(
          'foto',
          await MultipartFile.fromFile(imageFile.path),
        ));
      }

      if (fromDateTime != null && toDateTime != null) {
        final additionalEntries = {
          'count_hour': calculateHoursDifference().toString(),
          'order_amount':
              (calculateHoursDifference() ?? 0 * adSMPrice ~/ 24).toString(),
        };
        formData.fields.addAll(additionalEntries.entries
            .map((entry) => MapEntry<String, String>(entry.key, entry.value)));
      }
      final queryParameters = {
        'status': 'CREATED',
      };

      final response = await Dio().post(
        url,
        queryParameters: queryParameters,
        data: formData,
        options: Options(
          headers: headers,
        ),
      );
      debugPrint(response.statusCode.toString());
      debugPrint(response.data.toString());
      if (response.statusCode == 200) {
        var map = response.data as Map;
        debugPrint('success');
        if (map['status'] == 'Successfully sended') {
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
        debugPrint(e.response?.data.toString() ?? 'NULL');
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

  void toggleEndTime(bool? newValue) {
    isEndTimeEnabled = newValue;
    if (newValue == false) clearEndTime();
    notifyListeners();
  }

  void clearEndTime() {
    toDate = null;
    toTime = null;
    toDateTime = null;
    notifyListeners();
  }

  Future<void> showFirstDateTimePicker(BuildContext context) async {
    final pickedFromDate = await DateTimeUtils.showAppDatePicker(context);
    if (pickedFromDate != null) {
      if (!context.mounted) return;
      final pickedFromTime = await DateTimeUtils.showAppTimePicker(context);
      if (pickedFromTime != null) {
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

  void removeImage(int index) {
    selectedImages.removeAt(index);
    notifyListeners();
  }

  Future<void> onSelectImageButtonPressed(BuildContext context) async {
    if (selectedImages.length - 1 < 5) {
      final selectedImage = await ImageService.pickImage(context);
      if (selectedImage != null) {
        selectedImages.add(selectedImage.path);
        notifyListeners();
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Достигнут максимальный предел'),
            content: const Text('Вы можете выбрать до 5 изображений.'),
            actions: [
              TextButton(
                onPressed: () {
                  // Navigator.pop(context);
                  context.pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
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

        if (pickedToDateTime.isAfter(pickedFromDateTime)) {
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

  void _onSuccessfulRequest(BuildContext context) {
    AppDialogService.showSuccessDialog(
      context,
      title: 'Ваш заказ успешно отправлен!',
      onPressed: () {
        // Navigator.pushNamedAndRemoveUntil(
        //   context,
        //   AppRouteNames.navigation,
        //   (route) => false,
        // );
        context.go(
          '/' + AppRouteNames.navigation,
        );
      },
      buttonText: 'Ок',
    );
  }

  onSendPressed(BuildContext context, String adSMId, double adSMPrice) async {
    AppDialogService.showLoadingDialog(context);

    await _uploadAdSMRequest(
      file: selectedImage,
      adSMId: adSMId,
      adSMPrice: adSMPrice,
    );
    if (context.mounted) {
      // Navigator.pop(context);
      context.pop();
      _onSuccessfulRequest(context);
    }
  }
}
