import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_detail_location_row.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_model/ad_service_model.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_header_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_photos_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_price_widget.dart';
import 'package:eqshare_mobile/src/features/main/location/detail_map_screen.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/service_request/service_request/service_request_model.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/ad_service_request_repository.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/ali_widgets/approve_or_cancel_buttons.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/ad_request_created_user_card_widget.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/specialized_machinery_info_widget.dart';
import 'package:eqshare_mobile/src/global_widgets/global_future_builder_with_payload.dart';
import 'package:flutter/material.dart';

class AdServiceRequestDetailScreen extends StatefulWidget {
  final AdServiceRequestRepository adServiceRequestRepository;
  final String requestID;
  const AdServiceRequestDetailScreen(
      {super.key,
      required this.adServiceRequestRepository,
      required this.requestID});

  @override
  State<AdServiceRequestDetailScreen> createState() =>
      _AdServiceRequestDetailScreenState();
}

class _AdServiceRequestDetailScreenState
    extends State<AdServiceRequestDetailScreen> {
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

  String statusText(String status) {
    switch (status) {
      case 'CANCELED':
        return 'Отменен';
      case 'CREATED':
        return 'На утверждении клиента';
      default:
        return 'Неизвестный статус';
    }
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Заказ'),
        centerTitle: true,
      ),
      body: GlobalFutureBuilderWithPayload(
        futureForClient: widget.adServiceRequestRepository
            .getDriverRequestDetailAwaitsApprovedFromClient(
                adServiceRequestID: widget.requestID),
        futureForDriverOrOwner: widget.adServiceRequestRepository
            .getDriverRequestDetailAwaitsApprovedFromClient(
                adServiceRequestID: widget.requestID),
        buildWidgetForClient: (request, payload) {
          final ad = request!.ad;
          return body(request, ad);
        },
        buildWidgetForDriverOrOwner: (request, payload) {
          final ad = request!.ad;
          return body(request, ad, isCanApprove: true);
        },
      ),
    );
  }

  Column body(ServiceRequestModel request, AdServiceModel? ad,
      {bool isCanApprove = false}) {
    return Column(children: [
      Expanded(
        child: ListView(
          children: [
            AdDetailPhotosWidget(
              imageUrls: request.imagesUrl ?? <String>[],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdDetailHeaderWidget(
                    titleText: request.description ?? '',
                  ),
                  const SizedBox(height: 8),
                  ad?.price != null
                      ? AdDetailPriceWidget(
                          price: ad?.price.toString(),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 16),
                  AdRequestCreatedUserCardWidget(
                    createdTime: request.createdAt,
                    startedTime: !isCanApprove
                        ? request.startLeaseAt
                        : request.startLeaseAt,
                    endedTime:
                        !isCanApprove ? request.endLeaseAt : request.endLeaseAt,
                    forClient: AppChangeNotifier().payload?.aud == 'CLIENT',
                    userFirstName:
                        AppChangeNotifier().userMode == UserMode.client
                            ? request.executor?.firstName
                            : request.user?.firstName,
                    userSecondName:
                        AppChangeNotifier().userMode == UserMode.client
                            ? request.executor?.lastName
                            : request.user?.lastName,
                    userContacts:
                        AppChangeNotifier().userMode == UserMode.client
                            ? request.executor?.phoneNumber
                            : request.user?.phoneNumber,
                  ),
                  const SizedBox(height: 8),
                  SpecializedMachineryInfoWidget(
                    urlFoto: request.ad?.urlFoto,
                    titleText: 'Информация об услуге',
                    title: ad?.title,
                    subCategory: ad?.subcategory?.name?.toString(),
                    price: (ad?.price ?? 0.0).toInt(),
                    createdTime: ad?.createdAt,
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
      if (isCanApprove &&
          request.status == RequestStatus.CREATED.name &&
          request.deletedAt == null)
        ApproveOrCancelButtons(cancel: () async {
          bool result = await widget.adServiceRequestRepository
              .cancelClientRequestFromDriverOrOwner(widget.requestID);
          return result;
        }, approve: () async {
          bool result = await widget.adServiceRequestRepository
              .approveClientRequestFromDriverOrOwner(widget.requestID);
          return result;
        })
    ]);
  }
}
