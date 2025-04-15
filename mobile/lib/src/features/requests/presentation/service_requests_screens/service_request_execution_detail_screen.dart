import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_detail_location_row.dart';
import 'package:eqshare_mobile/src/core/res/app_images.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_header_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_photos_widget.dart';
import 'package:eqshare_mobile/src/features/main/location/detail_map_screen.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/ad_service_request_repository.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/widgets/build_request_items_button.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/ad_request_created_user_card_widget.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/ad_small_request_info_widget.dart';
import 'package:eqshare_mobile/src/global_widgets/global_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ServiceRequestExecutionDetailScreen extends StatefulWidget {
  final String requestID;

  const ServiceRequestExecutionDetailScreen({
    super.key,
    required this.requestID,
  });

  @override
  State<ServiceRequestExecutionDetailScreen> createState() =>
      _ServiceRequestExecutionDetailScreenState();
}

class _ServiceRequestExecutionDetailScreenState
    extends State<ServiceRequestExecutionDetailScreen> {
  final adServiceRequestRepository = AdServiceRequestRepository();

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
        body: GlobalFutureBuilder(
            future: adServiceRequestRepository.getRequestExecutionDetail(
                requestID: widget.requestID),
            buildWidget: (requestExecution) {
              List<String> images = [];

              String? title;

              double? price;
              String? category;
              String? adress;
              String? brand;
              String? city;
              String? date;

              if (requestExecution?.src == 'SVC_CLIENT') {
                images = requestExecution?.urlFoto ?? [];

                title = requestExecution?.title;

                price = (requestExecution
                            ?.serviceRequestClientModel?.adClient?.price ??
                        0)
                    .toDouble();
                category = requestExecution
                    ?.serviceRequestClientModel?.adClient?.subcategory?.name;
                adress = requestExecution
                    ?.serviceRequestClientModel?.adClient?.address;
                city = requestExecution
                    ?.serviceRequestClientModel?.adClient?.city?.name;
                date = requestExecution
                    ?.serviceRequestClientModel?.adClient?.createdAt;
              } else {
                images = requestExecution?.urlFoto ?? [];
                title = requestExecution?.title;

                price = (requestExecution?.serviceRequestModel?.ad?.price ?? 0)
                    .toDouble();
                category = requestExecution
                    ?.serviceRequestModel?.ad?.subcategory?.name;
                adress = requestExecution?.serviceRequestModel?.ad?.address;
                brand = requestExecution?.serviceRequestModel?.ad?.brand?.name;
                city = requestExecution?.serviceRequestModel?.ad?.city?.name;
                date = requestExecution?.serviceRequestModel?.ad?.createdAt;
              }

              return Column(children: [
                Expanded(
                  child: ListView(
                    children: [
                      AdDetailPhotosWidget(imageUrls: images,imagePlaceholder: AppImages.imagePlaceholder),
                      Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AdDetailHeaderWidget(
                              titleText: requestExecution?.title ?? '',
                            ),
                            const SizedBox(height: 16),
                            AdRequestCreatedUserCardWidget(
                              createdTime:
                                  requestExecution?.createdAt.toString(),
                              endedTime: requestExecution?.workEndAt.toString(),
                              forClient: AppChangeNotifier().userMode ==
                                  UserMode.client,
                              startedTime:
                                  requestExecution?.startLeaseAt.toString(),
                              userFirstName: AppChangeNotifier().userMode ==
                                      UserMode.client
                                  ? requestExecution?.driver?.firstName
                                  : requestExecution?.client?.firstName,
                              userSecondName: AppChangeNotifier().userMode ==
                                      UserMode.client
                                  ? requestExecution?.driver?.lastName
                                  : requestExecution?.client?.lastName,
                              userContacts: AppChangeNotifier().userMode ==
                                      UserMode.client
                                  ? requestExecution?.driver?.phoneNumber
                                  : requestExecution?.client?.phoneNumber,
                            ),
                            const SizedBox(height: 8),
                            AdSmallRequestInfoWidget(
                                titleText: 'Информация об услуге',
                                brand: brand,
                                title: title,
                                dateTime: date,
                                subCategory: category ?? 'Не указан',
                                price: (price).toInt(),
                                city: city),
                            const SizedBox(height: 16),
                            const Text(
                              'Адрес объекта',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            AppDetailLocationRow(
                                requestExecution?.finishAddress ?? adress),
                            HalfScreenMapWidget(
                              latitude: requestExecution?.latitude ??
                                  requestExecution?.finishLatitude,
                              longitude: requestExecution?.longitude ??
                                  requestExecution?.finishLongitude,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                BuildRequestItemsButton(
                  requestExecution: requestExecution,
                  requestExecutionRepository: adServiceRequestRepository,
                  onpressed: (key) {
                    setState(() {});
                  },
                )
              ]);
            }));
  }
}
