import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_detail_location_row.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_client_model/ad_equipment_client.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_header_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_photos_widget.dart';
import 'package:eqshare_mobile/src/features/main/location/detail_map_screen.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/equipment_request/equipment_client_request_model/request_ad_equipment_client.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/equipment_request_repository_impl.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/ali_widgets/approve_or_cancel_buttons.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/ad_request_created_user_card_widget.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/specialized_machinery_info_widget.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/models/specialized_machinery_request_models/specialized_machinery_request_model/specialized_machinery_request.dart';

class EquipmentClientCreatedRequestDetailScreen extends StatefulWidget {
  final String adId;

  const EquipmentClientCreatedRequestDetailScreen({
    super.key,
    required this.adId,
  });

  @override
  State<EquipmentClientCreatedRequestDetailScreen> createState() =>
      _EquipmentClientCreatedRequestDetailScreenState();
}

class _EquipmentClientCreatedRequestDetailScreenState
    extends State<EquipmentClientCreatedRequestDetailScreen> {
  void showApproveDialog(String text) {
    AppDialogService.showSuccessDialog(
      context,
      buttonText: 'Мои заказы',
      title: text,
      onPressed: () {
        context.pop();
        context.pop();
      },
    );
  }

  Future<List<dynamic>?> getRequestAdEquipmentClientDetail() async {
    final payload = await EquipmentRequestRepositoryImpl().getPayload();
    final data = await EquipmentRequestRepositoryImpl()
        .getRequestAdEquipmentClientDetail(requestId: widget.adId);
    return [data, payload];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Заказ к объявлению',
          ),
          leading: IconButton(
            onPressed: () {
              // Navigator.pop(context);
              context.pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: FutureBuilder(
            future: getRequestAdEquipmentClientDetail(),
            builder: (context, snapsot) {
              if (snapsot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapsot.hasError) {
                return const Center(child: Text('Error'));
              } else if (snapsot.data == null) {
                return const Center(child: Text('NUll'));
              }
              final clientRequest =
                  snapsot.data?[0] as RequestAdEquipmentClient?;

              return body(clientRequest!, clientRequest.adEquipmentClient,
                  needButton: AppChangeNotifier().userMode == UserMode.client);
            }));
  }


  Column body(RequestAdEquipmentClient request, AdEquipmentClient? ad,
      {bool needButton = false}) {
        
    return Column(children: [
      Expanded(
        child: ListView(
          children: [
            AdDetailPhotosWidget(
              imageUrls: request.adEquipmentClient?.urlFoto ?? <String>[],
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
                    createdTime: request.createdAt.toString(),
                    isClientRequest: !needButton,
                    forClient:
                        (AppChangeNotifier().userMode == UserMode.client),
                    userFirstName: AppChangeNotifier().payload?.aud == 'CLIENT'
                        ? request.executor?.firstName
                        : request.adEquipmentClient?.user?.firstName,
                    userSecondName: AppChangeNotifier().payload?.aud == 'CLIENT'
                        ? request.executor?.lastName
                        : request.adEquipmentClient?.user?.lastName,
                    userContacts: AppChangeNotifier().payload?.aud == 'CLIENT'
                        ? request.executor?.phoneNumber
                        : request.adEquipmentClient?.user?.phoneNumber,
                    isAssinged: request.userId !=
                        int.parse(AppChangeNotifier().payload?.sub ?? '0'),
                    assingedUserFirstName: request.user?.firstName,
                    assingedUSerLastName: request.user?.lastName,
                    assingedUserContacts: request.user?.phoneNumber,
                  ),
                  const SizedBox(height: 8),
                  SpecializedMachineryInfoWidget(
                    titleText: 'Информация о оборудование',
                    title: ad?.title,
                    userName: '${ad?.user?.firstName} ${ad?.user?.lastName}',
                    subCategory: ad?.equipmentSubcategory?.name?.toString(),
                    price: (ad?.price ?? 0.0).toInt(),
                    createdTime: ad?.createdAt.toString(),
                    startedTime: ad?.startLeaseDate,
                    endedTime: ad?.endLeaseDate,
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
            final result = await EquipmentRequestRepositoryImpl()
                .postEquipmentClientRequestApprove(requestId: widget.adId);

            if (result?.statusCode == 200) {
              return true;
            }
            return false;
          },
          cancel: () async {
            final result = await EquipmentRequestRepositoryImpl()
                .postEquipmentClientRequestCancel(requestId: widget.adId);

            if (result?.statusCode == 200) {
              return true;
            }
            return false;
          },
        )
    ]);
  }

  Column buildAdSMBrand(SpecializedMachineryRequest? adDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Бренд',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          adDetail?.description ?? '',
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

 

  Column buildAdSMCategory(SpecializedMachineryRequest? adDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Категория',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          adDetail?.description ?? '',
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Column buildAdSMCity(SpecializedMachineryRequest? adDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Город',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          adDetail?.description ?? '',
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
