import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_detail_location_row.dart';
import 'package:eqshare_mobile/src/core/res/app_images.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_header_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_photos_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_price_widget.dart';
import 'package:eqshare_mobile/src/features/main/location/detail_map_screen.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/request_execution_list/request_execution.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/request_execution_repository.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/widgets/build_request_items_button.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/ad_request_created_user_card_widget.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/ad_small_request_info_widget.dart';
import 'package:eqshare_mobile/src/global_widgets/global_future_builder.dart';
import 'package:flutter/material.dart';

class ConstructionRequestExecutionDetailScreen extends StatefulWidget {
  final String requestId;
  const ConstructionRequestExecutionDetailScreen(
      {super.key, required this.requestId});

  @override
  State<ConstructionRequestExecutionDetailScreen> createState() =>
      _ConstructionRequestExecutionDetailScreenState();
}

class _ConstructionRequestExecutionDetailScreenState
    extends State<ConstructionRequestExecutionDetailScreen> {
  var mode = UserMode.guest;

  Future<String> getUserMode() async {
    final token = await TokenService().getToken();
    mode = UserMode.guest;
    if (token == null) {
      const userMode = UserMode.guest;
      mode = userMode;
    } else {
      final payload = TokenService().extractPayloadFromToken(token);
      var userMode = UserMode.guest;

      switch (payload.aud) {
        case TokenService.driverAudience:
          userMode = UserMode.driver;
        case TokenService.ownerAudience:
          userMode = UserMode.owner;
        case TokenService.clientAudience:
          userMode = UserMode.client;
        default:
          userMode = UserMode.guest;
      }
      mode = userMode;
    }

    return mode.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Заказ'),
        centerTitle: true,
      ),
      body: GlobalFutureBuilder<RequestExecution?>(
        future: RequestExecutionRepository()
            .getRequestExecutionDetail(requestID: widget.requestId.toString()),
        buildWidget: (requestExecution) {
          final constructionMaterial =
              requestExecution?.constructionRequesttModel;

          String? title;
          int? price;
          String? category;
          String? city;
          String? brand;
          String? date;
          String? description;

          List<String>? images = requestExecution?.urlFoto;

          if (requestExecution!.src!.contains('CLIENT')) {
            title = requestExecution.constructionRequestClientModel
                ?.adConstructionClientModel?.title;
            price = requestExecution.constructionRequestClientModel
                ?.adConstructionClientModel?.price;
            category = requestExecution
                .constructionRequestClientModel
                ?.adConstructionClientModel
                ?.constructionMaterialSubCategory
                ?.name;

            city = requestExecution.constructionRequestClientModel
                ?.adConstructionClientModel?.city?.name;

            brand = requestExecution.constructionRequestClientModel
                ?.adConstructionClientModel?.constructionMaterialBrand?.name;
            date = requestExecution.constructionRequestClientModel
                ?.adConstructionClientModel?.createdAt
                .toString();
            description =
                requestExecution.constructionRequestClientModel?.description;
          } else {
            title = requestExecution
                .constructionRequesttModel?.adConstructionModel?.title;
            price = requestExecution
                .constructionRequesttModel?.adConstructionModel?.price;
            category = requestExecution.constructionRequesttModel
                ?.adConstructionModel?.constructionMaterialSubCategory?.name;
            city = requestExecution
                .constructionRequesttModel?.adConstructionModel?.city?.name;

            brand = requestExecution.constructionRequesttModel
                ?.adConstructionModel?.constructionMaterialBrand?.name;
            date = requestExecution
                .constructionRequesttModel?.adConstructionModel?.createdAt
                .toString();
          }

          return Column(children: [
            Expanded(
              child: ListView(
                children: [
                  AdDetailPhotosWidget(imageUrls: images ?? [],imagePlaceholder: AppImages.imagePlaceholder),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AdDetailHeaderWidget(
                          titleText: requestExecution.title,
                        ),
                        const SizedBox(height: 8),
                        price != null
                            ? AdDetailPriceWidget(
                                price: price.toString(),
                              )
                            : const SizedBox(),
                        const SizedBox(height: 16),
                        AdRequestCreatedUserCardWidget(
                          createdTime: requestExecution.createdAt.toString(),
                          endedTime: requestExecution.workEndAt.toString(),
                          startedTime: requestExecution.startLeaseAt.toString(),
                          forClient:
                              AppChangeNotifier().userMode == UserMode.client,
                          userFirstName:
                              AppChangeNotifier().userMode == UserMode.client
                                  ? requestExecution.driver?.firstName
                                  : requestExecution.client?.firstName,
                          userSecondName:
                              AppChangeNotifier().userMode == UserMode.client
                                  ? requestExecution.driver?.lastName
                                  : requestExecution.client?.lastName,
                          userContacts:
                              AppChangeNotifier().userMode == UserMode.client
                                  ? requestExecution.driver?.phoneNumber
                                  : requestExecution.client?.phoneNumber,
                        ),
                        const SizedBox(height: 8),
                        AdSmallRequestInfoWidget(
                            titleText: 'Информация о материале',
                            brand: brand,
                            title: title,
                            dateTime: date,
                            subCategory: category ?? 'Не указан',
                            price: (price ?? 0.0).toInt(),
                            city: city),
                        const SizedBox(height: 16),
                        const Text(
                          'Адрес объекта',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        AppDetailLocationRow(requestExecution.finishAddress ??
                            constructionMaterial?.address),
                        HalfScreenMapWidget(
                          latitude: requestExecution.latitude ??
                              requestExecution.finishLatitude,
                          longitude: requestExecution.longitude ??
                              requestExecution.finishLongitude,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            BuildRequestItemsButton(
              requestExecution: requestExecution,
              requestExecutionRepository: RequestExecutionRepository(),
              onpressed: (key) {
                setState(() {});
              },
            )
          ]);
        },
      ),
    );
  }
}
