import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_detail_location_row.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_model/ad_constrution_model.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_header_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_photos_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_price_widget.dart';
import 'package:eqshare_mobile/src/features/main/location/detail_map_screen.dart';

import 'package:eqshare_mobile/src/features/requests/data/models/construction_request/construction_request/construction_request_model.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/ad_constructions_request_repository.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/ali_widgets/approve_or_cancel_buttons.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/ad_request_created_user_card_widget.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/specialized_machinery_info_widget.dart';

import 'package:eqshare_mobile/src/global_widgets/global_future_builder_with_payload.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AdConstructionRequestDetailScreen extends StatefulWidget {
  final String requestId;
  final AdConstructionsRequestRepository adConstructionsRequestRepository;
  const AdConstructionRequestDetailScreen(
      {super.key,
      required this.requestId,
      required this.adConstructionsRequestRepository});

  @override
  State<AdConstructionRequestDetailScreen> createState() =>
      _AdConstructionRequestDetailScreenState();
}

class _AdConstructionRequestDetailScreenState
    extends State<AdConstructionRequestDetailScreen> {
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
            .getDriverRequestDetailAwaitsApprovedFromClient(
                adServiceRequestID: widget.requestId.toString()),
        futureForClient: widget.adConstructionsRequestRepository
            .getDriverRequestDetailAwaitsApprovedFromClient(
                adServiceRequestID: widget.requestId.toString()),
        buildWidgetForClient: (request, payload) {
          final adConstructionClientModel = request!.adConstructionModel;
          return body(request, adConstructionClientModel);
        },
        buildWidgetForDriverOrOwner: (request, payload) {
          final adConstructionClientModel = request!.adConstructionModel;
          return body(request, adConstructionClientModel, isCanApprove: true);
        },
      ),
    );
  }

  Column body(ConstructionRequestModel request,
      AdConstrutionModel? adConstructionClientModel,
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
                  adConstructionClientModel?.price != null
                      ? AdDetailPriceWidget(
                          price: adConstructionClientModel?.price.toString(),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 16),
                  AdRequestCreatedUserCardWidget(
                    createdTime: request.createdAt,
                    isClientRequest: !isCanApprove,
                    startedTime: !isCanApprove
                        ? request.startLeaseAt
                        : request.startLeaseAt,
                    endedTime:
                        !isCanApprove ? request.endLeaseAt : request.endLeaseAt,
                    forClient: AppChangeNotifier().payload?.aud == 'CLIENT',
                    userFirstName:
                        !isCanApprove ? request.executorUser?.firstName : request.user?.firstName,
                    userSecondName:
                        !isCanApprove ? request.executorUser?.lastName : request.user?.lastName,
                    userContacts: !isCanApprove
                        ? request.executorUser?.phoneNumber
                        :  request.user?.phoneNumber,
                  ),
                  const SizedBox(height: 8),
                  SpecializedMachineryInfoWidget(
                    urlFoto: request.adConstructionModel?.urlFoto,
                    titleText: 'Информация о материале',
                    title: adConstructionClientModel?.title,
                    subCategory: adConstructionClientModel
                        ?.constructionMaterialSubCategory?.name
                        ?.toString(),
                    price: (adConstructionClientModel?.price ?? 0.0).toInt(),
                    createdTime:
                        adConstructionClientModel?.createdAt.toString(),
                    city: adConstructionClientModel?.city?.name,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Адрес объекта ${kDebugMode ? '' : ""}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  AppDetailLocationRow(adConstructionClientModel?.address),
                  HalfScreenMapWidget(
                    latitude: request.latitude?.toDouble(),
                    longitude: request.longitude?.toDouble(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      if (isCanApprove && request.status == RequestStatus.CREATED.name &&  request.deletedAt == null )
        ApproveOrCancelButtons(
          approve: () async {
            final data = await widget.adConstructionsRequestRepository
                .approveClientRequestFromDriverOrOwner(
                    widget.requestId.toString());
            return data;
          },
          cancel: () async {
            final data = await widget.adConstructionsRequestRepository
                .cancelClientRequestsWhereAuthorFromAccountDriverOrOwner(
                    widget.requestId.toString());
            return data;
          },
        )
    ]);
  }
}
