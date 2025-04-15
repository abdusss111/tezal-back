import 'package:eqshare_mobile/src/core/presentation/widgets/app_detail_location_row.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_dimensions.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_client_interacted_model/ad_client_interacted.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_client_model/ad_service_client_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_model/ad_service_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_service_repository.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_service/ad_service_create_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_service/ad_service_create_screen_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/my_ad_screens/widgets/show_caller_model_for_client_request.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/utils/create_ad_or_request_enum.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/get_widget.dart';
import 'package:eqshare_mobile/src/features/main/location/detail_map_screen.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/ad_small_info_widget.dart';
import 'package:eqshare_mobile/src/global_widgets/global_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:separated_row/separated_row.dart';

class MyAdServiceDetailScreen extends StatefulWidget {
  final String adID;
  final String createAdOrRequestEnum;
  const MyAdServiceDetailScreen(
      {super.key, required this.adID, required this.createAdOrRequestEnum});

  @override
  State<MyAdServiceDetailScreen> createState() =>
      _MyAdServiceDetailScreenState();
}

class _MyAdServiceDetailScreenState extends State<MyAdServiceDetailScreen> {
  final serviceRepo = AdServiceRepository();

  @override
  initState() {
    super.initState();
    getData = serviceRepo.getAdClientInteractedList();
  }

  late final Future<List<AdClientInteracted>> getData;

  Column _buildContent(
    AdServiceClientModel? adServiceClientModel,
    BuildContext context,
  ) {
    final adStatus = adServiceClientModel?.status;

    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              AdDetailPhotosWidget(
                  imageUrls: adServiceClientModel?.urlFoto ?? []),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdDetailHeaderWidget(
                        titleText: adServiceClientModel?.title ?? ''),
                    AdDetailPriceWidget(
                        price: adServiceClientModel?.price.toString()),
                    AdDescriptionClientWidget(
                      descriptionText: adServiceClientModel?.description ?? '',
                      category: adServiceClientModel?.subcategory?.name,
                      createdAt: adServiceClientModel?.createdAt.toString(),
                      startDate:
                          adServiceClientModel?.startLeaseDate.toString(),
                      endDate: adServiceClientModel?.endLeaseDate.toString(),
                    ),
                  ],
                ),
              ),
              AppDetailLocationRow(adServiceClientModel?.address),
              Expanded(
                child: HalfScreenMapWidget(
                  latitude: adServiceClientModel?.latitude,
                  longitude: adServiceClientModel?.longitude,
                ),
              ),
            ],
          ),
        ),
        (adServiceClientModel?.deletedAt == null
                    ? true
                    : adServiceClientModel!.deletedAt.toString().isEmpty) &&
                (adStatus == 'CREATED' || adStatus == 'FINISHED')
            ? _buildActionButtons(adStatus, id: adServiceClientModel?.id)
            : const SizedBox(),
      ],
    );
  }

  Column _buildContentForDriver(
    AdServiceModel? data,
    BuildContext context,
  ) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              AdDetailPhotosWidget(imageUrls: data?.urlFoto ?? []),
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
                            AdDetailHeaderWidget(titleText: data?.title),
                            const SizedBox(height: 8),
                            AdDetailPriceWidget(price: data?.price.toString(), rating: data?.rating,),
                          ])),
                  const AdDivider(),
                  AdDescriptionOnlyWidget(description: data?.description ?? ''),
                  const AdDivider(),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AdSmallInfoWidget(
                          hintTextForTitleText: 'Дополнительная информация',
                          titleText: 'Информация об услуге',
                          subCategory: data?.subcategory?.name,
                          price: data?.price,
                          city: data?.city?.name,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              AppDetailLocationRow(data?.address),
              const SizedBox(height: 5),
              HalfScreenMapWidget(
                latitude: data?.latitude,
                longitude: data?.longitude,
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
                    await serviceRepo.deleteMyAd(widget.adID);
                  },
                ),
                _editButton(data?.id ?? 0,
                    requestItem: CreateAdOrRequestEnum.ad)
              ],
            )),
      ],
    );
  }

  Widget _buildActionButtons(String? adStatus, {required int? id}) {
    return Padding(
      padding: AppDimensions.footerActionButtonsPadding,
      child: SeparatedRow(
        children: [
          if (adStatus == 'CREATED') _buildFinishButton(id ?? 0),
          _editButton(id ?? 0, requestItem: CreateAdOrRequestEnum.request),
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
              getAdClientInteracted: getData, deleteAd: () {
            return serviceRepo.deleteMyClientAd(id.toString()).then((value) {
              if (mounted) context.pop();
            });
          }, sendRentRequest: (user) async {});
        },
        text: 'Завершить',
      ),
    );
  }

  Widget _editButton(int adID, {required CreateAdOrRequestEnum requestItem}) {
    return AdEditButton(onPressed: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                  create: (context) => AdServiceCreateScreenController(
                      requestEnum: requestItem, getEditID: adID),
                  child: const AdServiceCreateScreen())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        if (widget.createAdOrRequestEnum ==
            CreateAdOrRequestEnum.request.name) {
          return GlobalFutureBuilder(
              future: serviceRepo.getAdServiceDetailForDriverOrOwner(
                  adID: widget.adID),
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
              future:
                  serviceRepo.getAdServiceDetailForClient(adID: widget.adID),
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
