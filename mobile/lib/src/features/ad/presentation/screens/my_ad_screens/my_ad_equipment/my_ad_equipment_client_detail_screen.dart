import 'package:eqshare_mobile/src/core/presentation/widgets/get_core_widgets.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_dimensions.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_client_model/ad_equipment_client.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_model/ad_equipment.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_api_client.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_equipment/ad_equipment_create/ad_equipment_create_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_equipment/ad_equipment_create/ad_equipment_create_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_equipment_client/ad_equipment_client_create/ad_equipment_client_create_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_equipment_client/ad_equipment_client_create/ad_equipment_client_create_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/my_ad_screens/my_ad_equipment/my_ad_equipment_client_detail_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/my_ad_screens/widgets/show_caller_model_for_client_request.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/utils/create_ad_or_request_enum.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/get_widget.dart';
import 'package:eqshare_mobile/src/features/main/location/detail_map_screen.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/requests_widgets.dart';
import 'package:eqshare_mobile/src/global_widgets/global_future_builder.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:separated_row/separated_row.dart';

class MyAdEquipmentClientDetailScreen extends StatefulWidget {
  final String adID;
  final String createAdOrRequestEnum;
  const MyAdEquipmentClientDetailScreen(
      {super.key, required this.adID, required this.createAdOrRequestEnum});

  @override
  State<MyAdEquipmentClientDetailScreen> createState() =>
      _MyAdEquipmentClientDetailScreenState();
}

class _MyAdEquipmentClientDetailScreenState
    extends State<MyAdEquipmentClientDetailScreen> {
  Column _buildContent(
    AdEquipmentClient? adDetail,
    BuildContext context,
  ) {
    final adStatus = adDetail?.status;
    return Column(children: [
      Expanded(
        child: ListView(
          children: [
            AdDetailPhotosWidget(
              imageUrls: adDetail?.urlFoto ?? [],
            ),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    adDetail?.title ?? '',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    getPrice(adDetail?.price.toString()),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Описание',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    adDetail?.description ?? '',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Категория',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    adDetail?.equipmentSubcategory?.name ?? '',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Город',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    adDetail?.city?.name ?? '',
                    style: const TextStyle(fontSize: 14),
                  ),
                  AppDetailLocationRow(adDetail?.address),
                  HalfScreenMapWidget(
                    latitude: adDetail?.latitude,
                    longitude: adDetail?.longitude,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      (adDetail?.deletedAt == null
                  ? true
                  : adDetail!.deletedAt.toString().isEmpty) &&
              (adStatus == 'CREATED' || adStatus == 'FINISHED')
          ? _buildActionButtons(adStatus, adDetail?.id ?? 0)
          : const SizedBox(),
    ]);
  }

  Column _buildContentForDriver(
    AdEquipment? adDetail,
    BuildContext context,
  ) {
    return Column(
      children: [
        Expanded(
          child: ListView(children: [
            AdDetailPhotosWidget(
              imageUrls: adDetail?.urlFoto ?? [],
            ),
            const SizedBox(height: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AdDetailHeaderWidget(titleText: adDetail?.title),
                          const SizedBox(height: 8),
                          AdDetailPriceWidget(price: adDetail?.price.toString(), rating: adDetail?.rating,)
                        ])),
                const SizedBox(height: 4),
                Padding(
                    padding: const EdgeInsets.all(4),
                    child: Divider(color: Colors.grey.shade400)),
                AdDescriptionOnlyWidget(
                    description: adDetail?.description ?? ''),
                Padding(
                    padding: const EdgeInsets.all(4),
                    child: Divider(color: Colors.grey.shade400)),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdDescriptionWidget(
                        descriptionText: adDetail?.description ?? '',
                        adSM: adDetail,
                      ),
                      const SizedBox(height: 8),
                      SpecializedMachineryInfoWidget(
                        titleText: 'Информация об оборудовании',
                        name: adDetail?.title,
                        brand: adDetail?.brand?.name,
                        subCategory: adDetail?.subcategory?.name,
                        city: adDetail?.city?.name,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
            AppDetailLocationRow(adDetail?.address),
            HalfScreenMapWidget(
              latitude: adDetail?.latitude,
              longitude: adDetail?.longitude,
            )
          ]),
        ),
        Padding(
          padding: AppDimensions.footerActionButtonsPadding,
          child: SeparatedRow(
            children: [
              AdDeleteButton(delete: () async {
                await AdApiClient().deleteAdEquipment(widget.adID);
              }),
              AdEditButton(onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                              create: (context) => AdEquipmentCreateController(
                                  editID: adDetail?.id),
                              child: const AdEquipmentCreateScreen(),
                            )));
              })
            ],
            separatorBuilder: (context, index) => const SizedBox(
              width: AppDimensions.footerActionButtonsSeparatorWidth,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(String? adStatus, int id) {
    return Padding(
      padding: AppDimensions.footerActionButtonsPadding,
      child: SeparatedRow(
        children: [
          if (adStatus == 'CREATED') _buildFinishButton(),
          AdEditButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                            create: (context) =>
                                AdEquipmentClientCreateController(editID: id),
                            child: const AdEquipmentClientCreateScreen(),
                          )));
            },
          ),
        ],
        separatorBuilder: (context, index) => const SizedBox(
          width: AppDimensions.footerActionButtonsSeparatorWidth,
        ),
      ),
    );
  }

  Widget _buildFinishButton() {
    return Expanded(
      child: AppPrimaryButtonWidget(
        buttonType: ButtonType.filled,
        backgroundColor: Colors.green,
        onPressed: () {
          ShowCallerModelForClientRequest().showCallerModal(context,
              getAdClientInteracted:
                  Provider.of<MyAdEquipmentClientDetailController>(context,
                          listen: false)
                      .getAdClientInteracted,
              sendRentRequest: (user) async {}, deleteAd: () async {
            Provider.of<MyAdEquipmentClientDetailController>(context,
                    listen: false)
                .onDeleteTap().then((value){
              if(mounted) context.pop();

                });
          });
        },
        text: 'Завершить',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        if (widget.createAdOrRequestEnum ==
            CreateAdOrRequestEnum.request.name) {
          return GlobalFutureBuilder(
              future: AdApiClient().getAdEquipmentClientDetail(widget.adID),
              buildWidget: (data) {
                return Scaffold(
                    appBar: AppBar(
                      title: const Text('Мое объявление'),
                      leading: IconButton(
                        onPressed: () {
                          context.pop();
                        },
                        icon: const Icon(Icons.arrow_back_ios_new),
                      ),
                    ),
                    body: _buildContent(data, context));
              });
        } else {
          return GlobalFutureBuilder(
              future: AdApiClient().getAdEquipmentDetail(widget.adID),
              buildWidget: (data) {
                return Scaffold(
                    appBar: AppBar(
                      title: const Text('Мое объявление'),
                      leading: IconButton(
                        onPressed: () {
                          context.pop(true);
                        },
                        icon: const Icon(Icons.arrow_back_ios_new),
                      ),
                    ),
                    body: _buildContentForDriver(data, context));
              });
        }
      }),
    );
  }
}
