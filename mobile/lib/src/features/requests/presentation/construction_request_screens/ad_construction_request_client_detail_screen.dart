import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_detail_location_row.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_client_model.dart/ad_construction_client_model.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_header_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_photos_widget.dart';
import 'package:eqshare_mobile/src/features/main/location/detail_map_screen.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/construction_request/construction_request_client/construction_request_client_model.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/ad_constructions_request_repository.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/ali_widgets/approve_or_cancel_buttons.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/ad_request_created_user_card_widget.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/specialized_machinery_info_widget.dart';

import 'package:eqshare_mobile/src/global_widgets/global_future_builder_with_payload.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AdConstructionRequestClientDetailScreen extends StatefulWidget {
  final String requestId;
  final AdConstructionsRequestRepository adConstructionsRequestRepository;
  const AdConstructionRequestClientDetailScreen(
      {super.key,
      required this.requestId,
      required this.adConstructionsRequestRepository});

  @override
  State<AdConstructionRequestClientDetailScreen> createState() =>
      _AdConstructionRequestClientDetailScreenState();
}

class _AdConstructionRequestClientDetailScreenState
    extends State<AdConstructionRequestClientDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Заказ'),
        centerTitle: true,
      ),
      body: GlobalFutureBuilderWithPayload(
        futureForDriverOrOwner: widget.adConstructionsRequestRepository
            .getClientRequestDetailAwaitsApprovedFromDriverOrOwner(
                adServiceRequestID: widget.requestId.toString()),
        futureForClient: widget.adConstructionsRequestRepository
            .getClientRequestDetailAwaitsApprovedFromDriverOrOwner(
                adServiceRequestID: widget.requestId.toString()),
        buildWidgetForClient: (request, payload) {
          final adConstructionClientModel = request!.adConstructionClientModel;
          return body(adConstructionClientModel, request, needButton: true);
        },
        buildWidgetForDriverOrOwner: (request, payload) {
          final adConstructionClientModel = request!.adConstructionClientModel;
          return body(adConstructionClientModel, request);
        },
      ),
    );
  }

  Column body(AdConstructionClientModel? adConstructionClientModel,
      ConstructionRequestClientModel request,
      {bool needButton = false}) {
        
    return Column(children: [
      Expanded(
        child: ListView(
          children: [
            AdDetailPhotosWidget(
              imageUrls: adConstructionClientModel?.urlFoto ?? <String>[],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
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
                        ? request.executorUser?.firstName
                        : request.adConstructionClientModel?.user?.firstName,
                    userSecondName: AppChangeNotifier().payload?.aud == 'CLIENT'
                        ? request.executorUser?.lastName
                        : request.adConstructionClientModel?.user?.lastName,
                    userContacts: AppChangeNotifier().payload?.aud == 'CLIENT'
                        ? request.executorUser?.phoneNumber
                        : request.adConstructionClientModel?.user?.phoneNumber,
                    isAssinged: request.userId !=
                        int.parse(AppChangeNotifier().payload?.sub ?? ''),
                    assingedUserFirstName: request.user?.firstName,
                    assingedUSerLastName: request.user?.lastName,
                    assingedUserContacts: request.user?.phoneNumber,
                  ),
                  const SizedBox(height: 8),
                  SpecializedMachineryInfoWidget(
                    titleText: AppChangeNotifier().userMode == UserMode.client
                        ? 'Информация о объявление'
                        : 'Информация о материале',
                    title: adConstructionClientModel?.title,
                    userName:
                        '${adConstructionClientModel?.user?.firstName} ${adConstructionClientModel?.user?.lastName}',
                    subCategory: adConstructionClientModel
                        ?.constructionMaterialSubCategory?.name
                        ?.toString(),
                    price: (adConstructionClientModel?.price ?? 0.0).toInt(),
                    createdTime:
                        adConstructionClientModel?.createdAt.toString(),
                    startedTime:
                        adConstructionClientModel?.startLeaseDate.toString(),
                    endedTime:
                        adConstructionClientModel?.endLeaseDate.toString(),
                    city: adConstructionClientModel?.city?.name,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Адрес объекта ${kDebugMode ? '' : ""}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  AppDetailLocationRow(adConstructionClientModel?.address),
                  HalfScreenMapWidget(
                    latitude: adConstructionClientModel?.latitude?.toDouble(),
                    longitude: adConstructionClientModel?.longitude?.toDouble(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      if (needButton && request.status == RequestStatus.CREATED.name && request.deletedAt == null  )
        ApproveOrCancelButtons(
          approve: () async {
            final data = await widget.adConstructionsRequestRepository
                .approveDriverOrOwnerRequestFromClientAccount(
                    widget.requestId.toString());
            return data;
          },
          cancel: () async {
            final data = await widget.adConstructionsRequestRepository
                .cancelDriverOrOwnerRequestsWhereAuthorFromClientAccount(
                    widget.requestId.toString());
            return data;
          },
        )
    ]);
  }
}
