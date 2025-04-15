import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_model/ad_equipment.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_header_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_photos_widget.dart';
import 'package:eqshare_mobile/src/features/main/location/detail_map_screen.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/equipment_request/equipment_client_request_model/request_ad_equipment_client.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/equipment_request/equipment_request_model/request_ad_equipment.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/equipment_request_repository_impl.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/ali_widgets/approve_or_cancel_buttons.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/ad_request_created_user_card_widget.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/specialized_machinery_info_widget.dart';
import 'package:eqshare_mobile/src/global_widgets/global_future_builder_with_payload.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/presentation/widgets/app_detail_location_row.dart';
import '../../../../../main/profile/profile_page/profile_controller.dart';
import 'equipment_created_request_detail_controller.dart';

class EquipmentCreatedRequestDetailScreen extends StatefulWidget {
  final String requestId;

  const EquipmentCreatedRequestDetailScreen({
    super.key,
    required this.requestId,
  });

  @override
  State<EquipmentCreatedRequestDetailScreen> createState() =>
      _EquipmentCreatedRequestDetailScreenState();
}

class _EquipmentCreatedRequestDetailScreenState
    extends State<EquipmentCreatedRequestDetailScreen> {
  late EquipmentCreatedRequestDetailController controller;
  final requestApiClient = EquipmentRequestRepositoryImpl();

  @override
  void initState() {
    controller = EquipmentCreatedRequestDetailController(widget.requestId);

    super.initState();
  }

  Future<String> getUserMode() async {
    final result = await controller.getUserModeInController();
    controller.setupWorkers(context);

    return result;
  }

  Column buildAdSMBrand(String? brand) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Бренд',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          brand ?? '',
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }


  Column buildAdSMCategory(String? category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Категория',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          category ?? '',
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Column buildAdSMCity(String? description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Город',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          description ?? '',
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Text buildAdSMHeader(String? description) {
    return Text(
      description ?? '',
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
    );
  }

  Column buildAdSMDescription(String? comment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Описание',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          comment ?? '',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Future<RequestAdEquipmentClient?> fetchData() async {
    final requestDetails = await requestApiClient
        .getRequestAdEquipmentClientDetail(requestId: widget.requestId);
    await getUserMode();

    return requestDetails;
  }

  String getStatusTextForRequest(String status) {
    switch (status) {
      case 'CANCELED':
        return 'Отменен';
      case 'CREATED':
        if (AppChangeNotifier().payload!.aud != ('CLIENT')) {
          return 'На утверждении клиента';
        } else {
          return 'На утверждении водителя';
        }
      default:
        return 'Неизвестный статус';
    }
  }

  Column body(RequestAdEquipment request, AdEquipment? ad,
      {bool needButton = false}) {
        
    return Column(children: [
      Expanded(
        child: ListView(
          children: [
            AdDetailPhotosWidget(
              imageUrls: request.urlFoto ?? <String>[],
            ),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdDetailHeaderWidget(
                    titleText: request.description ?? '',
                  ),
                  const SizedBox(height: 16),
                  AdRequestCreatedUserCardWidget(
                    startedTime: request.startLeaseAt,
                    endedTime: request.endLeaseAt,
                    createdTime: request.createdAt.toString(),
                    isClientRequest: !needButton,
                    forClient:
                        (AppChangeNotifier().userMode == UserMode.client),
                    userFirstName: AppChangeNotifier().payload?.aud == 'CLIENT'
                        ? request.executor?.firstName
                        : request.adEquipment?.user?.firstName,
                    userSecondName: AppChangeNotifier().payload?.aud == 'CLIENT'
                        ? request.executor?.lastName
                        : request.adEquipment?.user?.lastName,
                    userContacts: AppChangeNotifier().payload?.aud == 'CLIENT'
                        ? request.executor?.phoneNumber
                        : request.adEquipment?.user?.phoneNumber,
                  ),
                  const SizedBox(height: 8),
                  SpecializedMachineryInfoWidget(
                    urlFoto: request.adEquipment?.urlFoto,
                    titleText: 'Информация о оборудование',
                    title: ad?.title,
                    forClient: (AppChangeNotifier().userMode == UserMode.client),
                    userName: '${request.user?.firstName} ${request.user?.lastName}',
                    subCategory: ad?.subcategory?.name?.toString(),
                    price: (ad?.price ?? 0.0).toInt(),
                    createdTime: ad?.createdAt.toString(),
                    city: ad?.city?.name,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Адрес объекта',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  AppDetailLocationRow(ad?.address),
                  HalfScreenMapWidget(
                    latitude: ad?.latitude?.toDouble(),
                    longitude: ad?.longitude?.toDouble(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      if (needButton && request.status == RequestStatus.CREATED.name  && request.deletedAt == null )
        ApproveOrCancelButtons(
          approve: () async {
            final result = await requestApiClient.postEquipmentRequestApprove(
              requestId: widget.requestId,
            );
            if (result?.statusCode == 200) {
              return true;
            }
            return false;
          },
          cancel: () async {
            final result = await requestApiClient.postEquipmentRequestCancel(
                requestId: widget.requestId);
            if (result?.statusCode == 200) {
              return true;
            }
            return false;
          },
        )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Заказ',
          ),
          elevation: 20.0,
          leading: IconButton(
            onPressed: () {
              // Navigator.pop(context);
              context.pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: GlobalFutureBuilderWithPayload(
            futureForClient:
                requestApiClient.getEquipmentRequestDetail(widget.requestId),
            futureForDriverOrOwner:
                requestApiClient.getEquipmentRequestDetail(widget.requestId),
            buildWidgetForDriverOrOwner: (data, payload) {
              final adEquipment = data!.adEquipment;
              return body(data, adEquipment, needButton: true);
            },
            buildWidgetForClient: (request, payload) {
              final adEquipment = request?.adEquipment;
              return body(request!, adEquipment, needButton: false);
            }));
  }
}
