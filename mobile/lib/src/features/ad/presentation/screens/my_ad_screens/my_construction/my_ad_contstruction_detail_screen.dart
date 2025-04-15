import 'package:eqshare_mobile/src/core/presentation/widgets/app_detail_location_row.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_dimensions.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_client_interacted_model/ad_client_interacted.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_client_model.dart/ad_construction_client_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_model/ad_constrution_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_construction_materials_repository.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_construction/ad_construction_create_screen/ad_construction_create_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_construction/ad_construction_create_screen/ad_construction_create_screen_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/my_ad_screens/widgets/show_caller_model_for_client_request.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/utils/create_ad_or_request_enum.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/widgets/get_widget.dart';
import 'package:eqshare_mobile/src/features/main/location/detail_map_screen.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/specialized_machinery_info_widget.dart';
import 'package:eqshare_mobile/src/global_widgets/global_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:separated_row/separated_row.dart';

class MyAdContstructionDetailScreen extends StatefulWidget {
  final String adID;
  final String createAdOrRequestEnumName;
  const MyAdContstructionDetailScreen(
      {super.key, required this.adID, required this.createAdOrRequestEnumName});

  @override
  State<MyAdContstructionDetailScreen> createState() =>
      _MyAdContstructionDetailScreenState();
}

class _MyAdContstructionDetailScreenState
    extends State<MyAdContstructionDetailScreen> {
  final repo = AdConstructionMaterialsRepository();

  @override
  initState() {
    super.initState();
    getData = repo.getAdClientInteractedList();
  }

  late final Future<List<AdClientInteracted>> getData;

  Column _buildContent(
    AdConstructionClientModel? adConstructionClientModel,
    BuildContext context,
  ) {
    final adStatus = adConstructionClientModel?.status;

    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              AdDetailPhotosWidget(
                  imageUrls: adConstructionClientModel?.urlFoto ?? []),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdDetailHeaderWidget(
                        titleText: adConstructionClientModel?.title ?? ''),
                    AdDetailPriceWidget(
                        price: adConstructionClientModel?.price.toString()),
                    AdDescriptionClientWidget(
                      descriptionText:
                          adConstructionClientModel?.description ?? '',
                      category: adConstructionClientModel
                          ?.constructionMaterialSubCategory?.name,
                      createdAt:
                          adConstructionClientModel?.createdAt.toString(),
                      startDate:
                          adConstructionClientModel?.startLeaseDate.toString(),
                      endDate:
                          adConstructionClientModel?.endLeaseDate.toString(),
                    ),
                  ],
                ),
              ),
              AppDetailLocationRow(adConstructionClientModel?.address),
              HalfScreenMapWidget(
                latitude: adConstructionClientModel?.latitude,
                longitude: adConstructionClientModel?.longitude,
              ),
            ],
          ),
        ),
        (adConstructionClientModel?.deletedAt == null
                    ? true
                    : adConstructionClientModel!.deletedAt
                        .toString()
                        .isEmpty) &&
                (adStatus == 'CREATED' || adStatus == 'FINISHED')
            ? _buildActionButtons(adStatus, adConstructionClientModel?.id ?? 0)
            : const SizedBox(),
      ],
    );
  }

  Column _buildContentForDriver(
    AdConstrutionModel? adConstrutionModel,
    BuildContext context,
  ) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              AdDetailPhotosWidget(
                imageUrls: adConstrutionModel?.urlFoto ?? [],
              ),
              const SizedBox(height: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                AdDetailHeaderWidget(
                                    titleText: adConstrutionModel?.title),
                                const SizedBox(height: 8),
                                AdDetailPriceWidget(
                                    price:
                                        adConstrutionModel?.price.toString(),
                                        rating: adConstrutionModel?.rating,),
                              ])),
                      const AdDivider(),
                      const SizedBox(height: 4),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AdDescriptionOnlyWidget(
                              description:
                                  adConstrutionModel?.description ?? '',
                            ),
                            const AdDivider(),
                            const SizedBox(height: 8),
                            SpecializedMachineryInfoWidget(
                              titleText: 'Информация об оборудовании',
                              name: adConstrutionModel?.title,
                              brand: adConstrutionModel
                                  ?.constructionMaterialBrand?.name,
                              subCategory: adConstrutionModel
                                  ?.constructionMaterialSubCategory?.name,
                              city: adConstrutionModel?.city?.name,
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              AppDetailLocationRow(adConstrutionModel?.address),
              HalfScreenMapWidget(
                latitude: adConstrutionModel?.latitude,
                longitude: adConstrutionModel?.longitude,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        Padding(
            padding: AppDimensions.footerActionButtonsPadding,
            child: SeparatedRow(
              separatorBuilder: (context, index) => const SizedBox(
                width: AppDimensions.footerActionButtonsSeparatorWidth,
              ),
              children: [
                AdDeleteButton(
                  delete: () async {
                    await repo.deteteMyAd(widget.adID);
                  },
                ),
                _buildEditButton(
                    adConstrutionModel?.id ?? 0, CreateAdOrRequestEnum.ad)
              ],
            )),
      ],
    );
  }

  Widget _buildActionButtons(String? adStatus, int id) {
    return Padding(
      padding: AppDimensions.footerActionButtonsPadding,
      child: SeparatedRow(
        children: [
          if (adStatus == 'CREATED') _buildFinishButton(id),
          _buildEditButton(id, CreateAdOrRequestEnum.request),
        ],
        separatorBuilder: (context, index) => const SizedBox(
          width: AppDimensions.footerActionButtonsSeparatorWidth,
        ),
      ),
    );
  }

  Widget _buildFinishButton(int id) {
    return Expanded(
      child: AppPrimaryButtonWidget(
        buttonType: ButtonType.filled,
        backgroundColor: Colors.green,
        onPressed: () {
          ShowCallerModelForClientRequest().showCallerModal(context,
              getAdClientInteracted: getData,
              sendRentRequest: (user) async {}, deleteAd: () async {
            return repo.deteteMyClientAd(id.toString()).then((value) {
              if (mounted) context.pop();
            });
          });
        },
        text: 'Завершить',
      ),
    );
  }

  Widget _buildEditButton(int id, CreateAdOrRequestEnum requestItem) {
    return AdEditButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                      create: (context) => AdConstructionCreateScreenController(
                          requestEnum: requestItem, getEditAd: id),
                      child: const AdConstructionCreateScreen(),
                    )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (payload) {
        if (widget.createAdOrRequestEnumName ==
            CreateAdOrRequestEnum.request.name) {
          return GlobalFutureBuilder(
              future: repo.getAdConstructionMaterialDetailForDriverOrOwner(
                  adID: widget.adID),
              buildWidget: (data) {
                return Scaffold(
                    appBar: AppBar(
                      title: const Text('Моя заявка'),
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
              future: repo.getAdConstructionMaterialDetailForClient(
                  adID: widget.adID),
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
