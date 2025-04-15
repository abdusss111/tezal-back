import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/string_format_helper.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_snack_bar.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/data/services/storage/token_provider_service.dart';
import '../../../../../core/presentation/widgets/app_primary_button.dart';
import '../../../../auth/presentation/auth.dart';

class Worker {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final int? id;

  Worker({this.firstName, this.lastName, this.phoneNumber, this.id});

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      id: json['id'],
    );
  }
}

void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Успешно!'),
      content: const Text('Вы успешно отправили запрос на добавление.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Закрыть модалку
            Navigator.of(context).pop(); // Вернуться на предыдущий экран
          },
          child: const Text('Назад'),
        ),
      ],
    ),
  );
}

class MyWorkersListSearchScreen extends StatefulWidget {
  const MyWorkersListSearchScreen({super.key});

  @override
  State<MyWorkersListSearchScreen> createState() =>
      _MyWorkersListSearchScreenState();
}

class _MyWorkersListSearchScreenState extends State<MyWorkersListSearchScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  late Future<Worker?>? _searchResult;
  final FlutterNativeContactPicker _contactPicker =
      FlutterNativeContactPicker();

  Future<String?> postWorkerRequest({required int? workerId}) async {
    final token = await TokenService().getToken();
    if (token == null) {
      debugPrint('Token is null');
      return 'Ошибка авторизации';
    }
    final payload = TokenService().extractPayloadFromToken(token);
    final url = '${ApiEndPoints.baseUrl}/owner/${payload.sub}/send_worker';

    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final data = {'worker_id': workerId};

      final response = await Dio().post(
        url,
        data: data,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return null; // Успех
      } else {
        return 'Неизвестная ошибка';
      }
    } on DioException catch (error) {
      debugPrint('DioException caught!');
      debugPrint('Status code: ${error.response?.statusCode}');
      debugPrint('Response data: ${error.response?.data}');

      final responseData = error.response?.data;

      if ([400, 422, 500].contains(error.response?.statusCode)) {
        if (responseData is Map<String, dynamic>) {
          final errorMessage = (responseData['error'] ?? '').toString().toLowerCase().trim();
          debugPrint('Ошибка сервера: $errorMessage');

          if (errorMessage == 'you already owned this driver') {
            return 'Этот водитель уже работает в вашем бизнесе';
          } else if (errorMessage == 'driver request is pending') {
            return 'Запрос на добавление этого водителя уже на рассмотрении';
          } else {
            return 'Ошибка: $errorMessage';
          }
        } else {
          debugPrint('Неожиданная структура данных: ${responseData.toString()}');
          return 'Неизвестная ошибка формата';
        }
      }

      return 'Что-то пошло не так. Попробуйте ещё раз.';
    } catch (e) {
      debugPrint('Неизвестная ошибка: $e');
      return 'Неизвестная ошибка';
    }
  }



  void showSuccessDialog(BuildContext context) {
    AppDialogService.showSuccessDialog(
      context,
      title: 'Водитель успешно добавлен!',
      onPressed: () {
        // Navigator.pop(context);
        // Navigator.pop(context);
        context.pop();
        context.pop();
        context.pushReplacementNamed(AppRouteNames.myWorkersList);
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ChangeNotifierProvider(
        //       create: (_) => MyWorkersListController(),
        //       child: const MyWorkersListScreen(),
        //     ),
        //   ),
        // );
      },
      buttonText: 'Мои водители',
    );
  }

  Future<Worker?> _fetchData(String searchText) async {
    final phone = '7${searchText.replaceAll(RegExp(r'\D'), '')}';
    final token = await TokenService().getToken();
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(
      Uri.parse(
          '${ApiEndPoints.baseUrl}/user?phone_number=%2B$phone&can_driver=true'),
      headers: headers,
    );
    debugPrint(response.body.toString());

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData =
          json.decode(utf8.decode(response.bodyBytes));
      if (responseData['users'].isEmpty) return null;
      return Worker.fromJson(responseData['users'][0]);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    _searchResult = Future.value(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Введите номер водителя'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: PhoneNumberField(controller: _searchController),
                    ),
                    IconButton(
                      onPressed: () async {
                        Contact? contact = await _contactPicker.selectContact();
                        if (contact?.phoneNumbers?.first != null) {
                          final phone =
                              '${contact?.phoneNumbers?.first.replaceAll(RegExp(r'\D'), '')}';
                          setState(() {
                            _searchController.text =
                                StringFormatHelper.formatPhoneNumber(phone);
                          });
                        }
                      },
                      icon: Icon(
                        Icons.account_circle_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              AppPrimaryButtonWidget(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      _searchResult = _fetchData(_searchController.text);
                    });
                    debugPrint(_searchController.text);
                  }
                },
                text: 'Поиск водителя в системе',
                buttonType: ButtonType.elevated,
              ),
              const SizedBox(height: 8.0),
              FutureBuilder<Worker?>(
                future: _searchResult,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const AppCircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    debugPrint(snapshot.error.toString());
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final Worker? worker = snapshot.data;
                    if (_searchController.text.isEmpty) {
                      return const Center(child: Text(''));
                    } else if (worker == null) {
                      return const Center(
                          child: Text('По номеру телефона не найден водитель'));
                    } else {
                      return Column(
                        children: [
                          const SizedBox(height: 16.0),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    '${worker.firstName ?? ''} ${worker.lastName ?? ''}',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    worker.phoneNumber ?? '',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8.0),
                                  AppPrimaryButtonWidget(
                                    onPressed: () async {
                                      AppDialogService.showLoadingDialog(context);

                                      final result = await postWorkerRequest(workerId: snapshot.data!.id);

                                      if (!context.mounted) return;
                                      context.pop(); // Закрыть диалог загрузки

                                      if (result == null) {
                                        showSuccessDialog(context);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          AppSnackBar.showErrorSnackBar(result), // Выводим текст ошибки, полученной от сервера
                                        );
                                      }
                                    },
                                    textColor: Colors.white,
                                    text: 'Отправить запрос на добавление',
                                    icon: Icons.send,
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
