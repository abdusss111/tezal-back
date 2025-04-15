import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_detail_location_row.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_client_model/ad_service_client_model.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_header_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_photos_widget.dart';
import 'package:eqshare_mobile/src/features/main/location/detail_map_screen.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/service_request/service_request_client/service_request_client_model.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/ad_service_request_repository.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/ali_widgets/approve_or_cancel_buttons.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/ad_request_created_user_card_widget.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/specialized_machinery_info_widget.dart';
import 'package:eqshare_mobile/src/global_widgets/global_future_builder_with_payload.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AdServiceRequestClientDetailScreen extends StatefulWidget {
  final AdServiceRequestRepository adServiceRequestRepository;
  final String requestID;
  const AdServiceRequestClientDetailScreen(
      {super.key,
      required this.adServiceRequestRepository,
      required this.requestID});

  @override
  State<AdServiceRequestClientDetailScreen> createState() =>
      _AdServiceRequestClientDetailScreenState();
}

class _AdServiceRequestClientDetailScreenState
    extends State<AdServiceRequestClientDetailScreen> {
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

  Text buildPriceText(String? price) {
    return Text(
      getPriceWithHint(price),
      // 'Цена: ${price ?? ''} т/час',.,
      style: const TextStyle(fontSize: 16),
    );
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
            .getClientRequestDetailAwaitsApprovedFromDriverOrOwner(
                adServiceRequestID: widget.requestID),
        futureForDriverOrOwner: widget.adServiceRequestRepository
            .getClientRequestDetailAwaitsApprovedFromDriverOrOwner(
                adServiceRequestID: widget.requestID),
        buildWidgetForClient: (request, payload) {
          final ad = request!.adClient;
          return body(request, ad, needButton: true);
        },
        buildWidgetForDriverOrOwner: (request, payload) {
          final ad = request!.adClient;
          return body(request, ad);
        },
      ),
    );
  }

  Column body(ServiceRequestClientModel request, AdServiceClientModel? ad,
      {bool needButton = false}) {
    return Column(children: [
      Expanded(
        child: ListView(
          children: [
            AdDetailPhotosWidget(
              imageUrls: request.adClient?.urlFoto ?? <String>[],
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
                    userFirstName:
                        AppChangeNotifier().userMode == UserMode.client
                            ? request.executor?.firstName
                            : request.adClient?.user?.firstName,
                    userSecondName:
                        AppChangeNotifier().userMode == UserMode.client
                            ? request.executor?.lastName
                            : request.adClient?.user?.lastName,
                    userContacts:
                        AppChangeNotifier().userMode == UserMode.client
                            ? request.executor?.phoneNumber
                            : request.adClient?.user?.phoneNumber,
                    isAssinged:request.userId != int.parse(AppChangeNotifier().payload?.sub ?? ''),
                    assingedUSerLastName: request.user?.lastName,
                    assingedUserFirstName: request.user?.firstName,
                    assingedUserContacts: request.user?.phoneNumber,
                  ),
                  const SizedBox(height: 8),
                  SpecializedMachineryInfoWidget(
                    titleText: 'Информация об услуге',
                    title: ad?.title,
                    userName: '${ad?.user?.firstName} ${ad?.user?.lastName}',
                    subCategory: ad?.subcategory?.name?.toString(),
                    price: (ad?.price ?? 0.0).toInt(),
                    createdTime: ad?.createdAt,
                    startedTime: ad?.startLeaseDate,
                    endedTime: ad?.endLeaseDate,
                    city: ad?.city?.name,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Адрес объекта ${kDebugMode ? '' : ""}',
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
      if (needButton && request.status == RequestStatus.CREATED.name  && request.deletedAt== null )
        ApproveOrCancelButtons(
          approve: () async {
            bool result = await widget.adServiceRequestRepository
                .approveDriverOrOwnerRequestFromClient(widget.requestID);
            return result;
          },
          cancel: () async {
            bool result = await widget.adServiceRequestRepository
                .cancelDriverOrOwnerRequestFromClient(widget.requestID);
            return result;
          },
        )
    ]);
  }
}
