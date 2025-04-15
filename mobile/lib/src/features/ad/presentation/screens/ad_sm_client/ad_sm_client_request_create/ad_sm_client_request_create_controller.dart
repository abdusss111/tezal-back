import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:eqshare_mobile/src/core/data/services/network/api_client/user_profile_api_client.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/core/res/app_images.dart';
import 'package:eqshare_mobile/src/core/res/extensions/string_extensions.dart';

import 'package:eqshare_mobile/src/features/requests/data/repository/equipment_request_repository_impl.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/sm_request_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../../../../../core/data/services/storage/token_provider_service.dart';
import '../../../../../../core/presentation/routing/app_route.dart';
import '../../../../../main/profile/profile_page/profile_controller.dart';

class AdSMClientRequestCreateController extends AppSafeChangeNotifier {
  bool isLoading = true;
  bool isLoadingInProgres = false;
  bool isContentEmpty = false;

  final TextEditingController descriptionController = TextEditingController();
  final _requestApiClient = SMRequestRepositoryImpl();
  final equipmentRepoImp = EquipmentRequestRepositoryImpl();

  final List<User> _workers = [];
  final _workersApiClient = UserProfileApiClient();

  List<User> get workers => List.unmodifiable(_workers.toList());

  Future<void> loadUserMode(BuildContext context) async {
    final token = await TokenService().getToken();
    if (token == null) {
      return;
    }

    final payload = TokenService().extractPayloadFromToken(token);

    AppChangeNotifier().updateProfileData(payload);
  }

  Future<Response?> _uploadAdClientRequest(
      {required String adClientId,
      required String type,
      String? executorId}) async {
    String url = '';
    Object data = {};

    final payload = await _requestApiClient.getPayload();
    if (type == 'AdSM') {
      url = '${ApiEndPoints.baseUrl}/client_request'; // TODO check
      data = {
        'ad_client_id': int.tryParse(adClientId),
        'comment': descriptionController.text.trim().capitalizeFirstLetter(),
      };
    } else {
      print('its equip::::::::');
      url = '${ApiEndPoints.baseUrl}/equipment/request_ad_equipment_client';
      data = {
        'ad_equipment_client_id': int.tryParse(adClientId),
        'description':
            descriptionController.text.trim().capitalizeFirstLetter(),
        'executor_id': int.parse(payload.sub ?? '1'),
        // TODO тут происваивал 1 и так проверял при постройке кнопки  Это костыль пока не понятно для чего нужен был этот айди в бек
      };
    }

    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = await TokenService().getToken();
    headers['Authorization'] = 'Bearer $token';
    try {
      final queryParameters = {
        'status': 'CREATED',
      };

      final response = await Dio().post(
        url,
        queryParameters: queryParameters,
        data: data,
        options: Options(
          headers: headers,
        ),
      );
      debugPrint(response.statusMessage.toString());
      if (response.statusCode == 200) {
        return response;
      } else {
        BotToast.showText(text: 'Error');
        return null;
      }
    } on DioException catch (error) {
      log(error.toString());
      rethrow;
    } catch (_) {
      throw 'Something Went Wrong';
    }
  }

  void _onSuccessfulRequestSend(BuildContext context) {
    AppDialogService.showSuccessDialog(
      context,
      title: 'Ваш заказ успешно отправлен!',
      onPressed: () {
        // Navigator.pushNamedAndRemoveUntil(
        //   context,
        //   AppRouteNames.navigation,
        //   (route) => false,
        // );
        context.pop();
        context.pop();
      },
      buttonText: 'Ок',
    );
  }

  Future<String?> onSendPressed(
      BuildContext context, String adClientId, String type) async {
    AppDialogService.showLoadingDialog(context);

    try {
      Response? response =
          await _uploadAdClientRequest(adClientId: adClientId, type: type);
      debugPrint(response?.statusCode.toString() ?? '');
      if (context.mounted) {
        // Navigator.pop(context);
        context.pop();
        if (response?.statusCode == 200) {
          _onSuccessfulRequestSend(context);
          return response?.data['id'].toString();
        }
      }
      return null;
    } on Exception catch (e) {
      log(e.toString(), name: 'error adSMClientDetail upload from driver');
      return null;
    }
  }

  Future<void> showCallOptions(
      BuildContext context, String adClientId, String type) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.account_box_rounded),
              title: const Text('Назначить себе'),
              onTap: () async {
                await onSendPressed(context, adClientId, type);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_rounded),
              title: const Text('Назначить одному из моих водителей'),
              onTap: () async {
                _showModal(context, adClientId, type);
              },
            ),
          ],
        );
      },
    );
  }

  void _showModal(BuildContext context, String adClientId, String type) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        final workerList = workers;
        if (workerList.isEmpty == true) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: const Center(
              child: Text('Нет данных о водителей'),
            ),
          );
        }
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              ListTile(
                leading: IconButton(
                  onPressed: () {
                    // Navigator.of(context).pop();
                    context.pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                title: const Text('Ваши водители'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: workerList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final worker = workerList[index];
                    return GestureDetector(
                      onTap: () async {
                        AppDialogService.showLoadingDialog(context);

                        Response? response;

                        if (type == 'AdSM') {
                          response = await _uploadAdClientRequest(
                            executorId: worker.id.toString(),
                            adClientId: adClientId,
                            type: type,
                          );
                        }
                        if (context.mounted) {
                          if (type == 'AdSM') {
                            await _onApproveToDriverPress(
                                context,
                                worker.id.toString(),
                                response?.data['id'].toString() ?? 'null');
                          } else {
                            await onPostToDriverEquipment(
                                context,
                                worker.id!,
                                int.parse(adClientId),
                                descriptionController.text);
                            //Это был тут выместо респонс [ali]
                            // adClientId.toString() ?? 'null'); // TODO
                            // То есть на одну спецтехнику можно одного того же водителя можно будет записывать и у него каждый раз будет новый айди
                            // А вот с оборудованием его айдишкой requestId  будет выступать каждый раз сама айди объявление
                            // Например если это объявление оборудование
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Image.asset(
                              AppImages.profilePlaceholder,
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(width: 28),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  '${worker.firstName ?? ''} ${worker.lastName ?? ''}',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(worker.phoneNumber ?? ''),
                                    const SizedBox(width: 28),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> setupWorkers(BuildContext context) async {
    final token = await TokenService().getToken();
    if (token == null) {
      return;
    }
    final payload = TokenService().extractPayloadFromToken(token);
    isLoading = true;
    isContentEmpty = false;

    notifyListeners();
    _workers.clear();

    if (context.mounted) {
      await _loadMyWorkers(context, payload.sub ?? '-1');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> _loadMyWorkers(BuildContext context, String id) async {
    isLoadingInProgres = true;

    try {
      final token = await TokenService().getToken();
      if (token == null) return;
      if (!context.mounted) return;

      final payload = TokenService().extractPayloadFromToken(token);
      final workersResponse = await _workersApiClient.getMyWorkers(
        payload.sub ?? '1',
      );
      if (workersResponse != null) {
        _workers.addAll((workersResponse) as Iterable<User>);
        if (_workers.isEmpty) {
          isContentEmpty = true;
        } else {
          isContentEmpty = false;
        }
        isLoadingInProgres = false;
        notifyListeners();
      }
    } catch (e) {
      isLoadingInProgres = false;
    }
  }

  Future<void> _onApproveToDriverPress(
      BuildContext context, String workerId, String requestId) async {
    http.Response? response =
        (await _requestApiClient.postClientRequestAssignToDriver(
            workerId: workerId, requestId: requestId));

    // if (context.mounted) Navigator.pop(context);
    if (context.mounted) context.pop();
    if (response?.statusCode == 200) {
      if (context.mounted) {
        _showApprovedToDriverDialog(context);
      }
    }
  }

  Future<void> onPostToDriverEquipment(BuildContext context, int workerId,
      int requestId, String description) async {
    final body = {
      "ad_equipment_client_id": requestId,
      "description": description,
      "executor_id": workerId
    };
    http.Response? response =
        (await equipmentRepoImp.postForDriverRequest(body));

    // if (context.mounted) Navigator.pop(context);
    if (context.mounted) context.pop();
    if (response?.statusCode == 200) {
      if (context.mounted) {
        _showApprovedToDriverDialog(context);
      }
    }
  }

  void _showApprovedToDriverDialog(BuildContext context) {
    AppDialogService.showSuccessDialog(
      context,
      title: 'Заказ успешно назначен водителю!',
      onPressed: () {
        while (context.canPop() == true) {
          context.pop();
        }
        context.pushReplacementNamed(
          AppRouteNames.navigation,
          extra: {'index': '0'},
        );
      },
      buttonText: 'Мои заказы',
    );
  }

  Future<void> onButtonPressed(BuildContext context,
      {required String adClientId, required String type}) async {
    if (AppChangeNotifier().userMode == UserMode.driver) {
      onSendPressed(context, adClientId, type);
    } else if (AppChangeNotifier().userMode == UserMode.owner) {
      await showCallOptions(context, adClientId, type);
    }
  }
}
