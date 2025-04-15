import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_detail_location_row.dart';
import 'package:eqshare_mobile/src/core/res/app_images.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_header_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_photos_widget.dart';
import 'package:eqshare_mobile/src/features/main/location/detail_map_screen.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';

import 'package:eqshare_mobile/src/features/requests/data/repository/equipment_request_repository_impl.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/widgets/build_request_items_button.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/ad_request_created_user_card_widget.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/ad_small_request_info_widget.dart';
import 'package:eqshare_mobile/src/global_widgets/global_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EquipmentRequestExecutionDetailScreen extends StatefulWidget {
  final String requestID;

  const EquipmentRequestExecutionDetailScreen({
    super.key,
    required this.requestID,
  });

  @override
  State<EquipmentRequestExecutionDetailScreen> createState() =>
      _ServiceRequestExecutionDetailScreenState();
}

class _ServiceRequestExecutionDetailScreenState
    extends State<EquipmentRequestExecutionDetailScreen> {
  final adServiceRequestRepository = EquipmentRequestRepositoryImpl();
  var key = GlobalKey();

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
              final data = requestExecution;

              double? price = 0;
              String? adress;
              String? city;
              String? brand;
              String? category;
              String? title;
              String? date;

              List<String>? images = requestExecution?.urlFoto;

              if (data?.src == 'EQ') {
                final clientRequest = data?.requestAdEquipment;
                price = (clientRequest?.adEquipment?.price ?? 0).toDouble();
                category = clientRequest?.adEquipment?.subcategory?.name;
                adress = clientRequest?.adEquipment?.address;
                title = clientRequest?.adEquipment?.title;
                city = clientRequest?.adEquipment?.city?.name;
                brand = clientRequest?.adEquipment?.brand?.name;
                date = clientRequest?.adEquipment?.createdAt.toString();
              } else {
                final clientRequest = data?.requestAdEquipmentClient;
                price = clientRequest?.adEquipmentClient?.price ?? 0;
                category = clientRequest
                    ?.adEquipmentClient?.equipmentSubcategory?.name;

                adress = clientRequest?.adEquipmentClient?.address;
                title = clientRequest?.adEquipmentClient?.title;
                date = clientRequest?.adEquipmentClient?.createdAt.toString();
              }

              return Column(children: [
                Expanded(
                  child: ListView(
                    children: [
                      AdDetailPhotosWidget(
                          imageUrls: images ?? [],
                          imagePlaceholder: AppImages.imagePlaceholder),
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
                              startedTime:
                                  requestExecution?.startLeaseAt.toString(),
                              forClient: AppChangeNotifier().userMode ==
                                  UserMode.client,
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
                                titleText: 'Информация о оборудование',
                                brand: brand,
                                dateTime: date,
                                title: title,
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
                            ),
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
