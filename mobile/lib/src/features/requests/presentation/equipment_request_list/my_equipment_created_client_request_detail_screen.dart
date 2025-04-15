import 'package:dio/dio.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_detail_location_row.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_description_widget2.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_header_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_photos_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_price_widget.dart';
import 'package:eqshare_mobile/src/features/main/location/detail_map_screen.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/equipment_request/equipment_client_request_model/request_ad_equipment_client.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/equipment_request/equipment_request_model/request_ad_equipment.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/equipment_request_repository_impl.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/specialized_machinery_info_widget.dart';
import 'package:eqshare_mobile/src/global_widgets/global_future_builder_with_payload.dart';
import 'package:flutter/material.dart';

class MyEquipmentCreatedClientRequestDetailScreen extends StatefulWidget {
  const MyEquipmentCreatedClientRequestDetailScreen(
      {super.key, required this.requestId});
  final String requestId;

  @override
  State<MyEquipmentCreatedClientRequestDetailScreen> createState() =>
      _MyEquipmentCreatedClientRequestDetailScreenState();
}

class _MyEquipmentCreatedClientRequestDetailScreenState
    extends State<MyEquipmentCreatedClientRequestDetailScreen> {
  final equipmentRepoImp = EquipmentRequestRepositoryImpl();

  final dio = Dio();

  Future<RequestAdEquipmentClient?>
      getDriverOrOwnerRequestInAwaitsForApprove() async {
    final data = equipmentRepoImp.getRequestAdEquipmentClientDetail(
        requestId: widget.requestId);
    return data;
  }

  Future<RequestAdEquipment?>
      getClientequestInAwaitsForApprove() async {
    final data =
        equipmentRepoImp.getEquipmentRequestDetail(widget.requestId);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: GlobalFutureBuilderWithPayload(
        futureForClient: getClientequestInAwaitsForApprove(),
        futureForDriverOrOwner: getDriverOrOwnerRequestInAwaitsForApprove(),
        buildWidgetForDriverOrOwner: (data, payload) {
          final adEquipment = data?.adEquipmentClient;
          return Column(children: [
            Expanded(
              child: ListView(
                children: [
                  AdDetailPhotosWidget(
                    imageUrls: adEquipment?.urlFoto ?? <String>[],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AdDetailHeaderWidget(
                          titleText: adEquipment?.description ?? '',
                        ),
                        const SizedBox(height: 8),
                        adEquipment?.price != null
                            ? AdDetailPriceWidget(
                                price: adEquipment!.price.toString(),
                              )
                            : const SizedBox(),
                        const SizedBox(height: 16),
                        AdDescriptionWidget2(
                          createdTime: adEquipment?.createdAt,
                          endedTime: adEquipment?.endLeaseDate,
                          startedTime: adEquipment?.startLeaseDate,
                          userFirstName: adEquipment?.user?.firstName,
                          userSecondName: adEquipment?.user?.lastName,
                          userContacts: adEquipment?.user?.phoneNumber,
                        ),
                        const SizedBox(height: 8),
                        SpecializedMachineryInfoWidget(
                          titleText: 'Информация об оборудовании',
                          urlFoto: adEquipment?.urlFoto,
                          name: adEquipment?.title,
                          brand:
                                  'Не указан',
                          subCategory: adEquipment?.equipmentSubcategory?.name ??
                              'Не указан',
                          price:
                              (adEquipment?.price ?? 0.0).toInt(),
                          city: adEquipment?.city?.name,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Адрес объекта',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        AppDetailLocationRow(adEquipment?.address),
                        HalfScreenMapWidget(
                          latitude: adEquipment?.latitude,
                          longitude: adEquipment?.longitude,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]);
        },
        buildWidgetForClient: (data, payload) {
          final adEquipment = data;

          return Column(children: [
            Expanded(
              child: ListView(
                children: [
                  AdDetailPhotosWidget(
                    imageUrls: adEquipment?.adEquipment?.urlFoto ?? <String>[],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AdDetailHeaderWidget(
                          titleText: adEquipment?.description ?? '',
                        ),
                        const SizedBox(height: 8),
                        adEquipment?.orderAmount != null
                            ? AdDetailPriceWidget(
                                price: adEquipment!.orderAmount,
                              )
                            : const SizedBox(),
                        const SizedBox(height: 16),
                        AdDescriptionWidget2(
                          createdTime: adEquipment?.createdAt,
                          endedTime: adEquipment?.endLeaseAt,
                          startedTime: adEquipment?.startLeaseAt,
                          userFirstName: adEquipment?.user?.firstName,
                          userSecondName: adEquipment?.user?.lastName,
                          userContacts: adEquipment?.user?.phoneNumber,
                        ),
                        const SizedBox(height: 8),
                        SpecializedMachineryInfoWidget(
                          titleText: 'Информация об оборудовании',
                          urlFoto: adEquipment?.urlFoto,
                          name: adEquipment?.adEquipment?.title,
                          brand:
                              adEquipment?.adEquipment?.brand?.name ??
                                  'Не указан',
                          subCategory: adEquipment
                                  ?.adEquipment?.subcategory?.name ??
                              'Не указан',
                          price:
                              (adEquipment?.adEquipment?.price ?? 0.0).toInt(),
                          city: adEquipment?.city?.name,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Адрес объекта',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        AppDetailLocationRow(adEquipment?.address),
                        HalfScreenMapWidget(
                          latitude: adEquipment?.latitude,
                          longitude: adEquipment?.longitude,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]);
        },
      ),
    );
  }
}
