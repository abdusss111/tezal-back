import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/models/payload/payload.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/SharePressed.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/auth_middleware.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_detail_location_row.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/page_wrapper.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_dimensions.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_client_model.dart/ad_construction_client_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_model/ad_constrution_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_construction_materials_repository.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_client_create_request_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_construction/ad_construction_detail_screen_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_construction_request_create_screen.dart';

import 'package:eqshare_mobile/src/features/main/location/detail_map_screen.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/specialized_machinery_info_widget.dart';
import 'package:eqshare_mobile/src/global_widgets/global_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:separated_row/separated_row.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/widgets/get_widget.dart';

class AdConstructionDetailScreen extends StatefulWidget {
  final String id;
  const AdConstructionDetailScreen({super.key, required this.id});

  @override
  State<AdConstructionDetailScreen> createState() =>
      _AdConstructionDetailScreenState();
}

class _AdConstructionDetailScreenState
    extends State<AdConstructionDetailScreen> {
  final adConstructionMaterialsRepository = AdConstructionMaterialsRepository();

  var appLikeButtonWrapperKey = UniqueKey();
  final TextEditingController reportController = TextEditingController();

  late final Future<Payload?> getPayload;

  @override
  initState() {
    super.initState();
    getPayload = Provider.of<AdConstructionDetailScreenController>(context,
            listen: false)
        .getPayload();
  }

  Widget clientDetailBody(AdConstrutionModel? adConstrutionModel) {
    final imageUrls = adConstrutionModel?.urlFoto ?? ['place_holder'];

    return Scaffold(
        appBar: AppBar(
          title: const Text('Строительный материал'),
          leading: const BackButton(),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                SharePressed(widget.id.toString(),
                    '${AppRouteNames.navigation}/${AppRouteNames.adConstructionList}/${AppRouteNames.adConstructionDetail}');
              },
              icon: const Icon(Icons.share),
            ),
            Consumer<AdConstructionDetailScreenController>(
                builder: (context, controller, child) {
              return FutureBuilder<bool>(
                  future: adConstructionMaterialsRepository
                      .isThisFavouriteAdForClient(widget.id),
                  builder: (context, snapshot) {
                    return Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: AppLikeButtonWrapper(
                          isLiked: snapshot.data,
                          key: controller.uniqueKey,
                          onTap: (isTapped) {
                            AuthMiddleware.executeIfAuthenticated(context,
                                () async {
                              if (snapshot.data == true) {
                                await adConstructionMaterialsRepository
                                    .deleteThisAdForClientFavorite(widget.id);
                              } else {
                                await adConstructionMaterialsRepository
                                    .postThisAdForClientFavorite(widget.id);
                              }
                              controller.changeUniqueKeyForLike();
                            });
                          },
                        ));
                  });
            })
          ],
        ),
        body: Consumer<AdConstructionDetailScreenController>(
            builder: (context, value, child) {
          return Column(
            children: [
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: SingleChildScrollView(
                          child: Column(children: [
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white, // Фон контейнера
                                  borderRadius: BorderRadius.circular(
                                      16), // Скруглённые углы
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(
                                          -1, -1), // Смещение вверх и влево
                                      blurRadius: 5, // Радиус размытия
                                      color: Color.fromRGBO(0, 0, 0,
                                          0.04), // Чёрный цвет с 4% прозрачностью
                                    ),
                                    BoxShadow(
                                      offset: Offset(
                                          1, 1), // Смещение вниз и вправо
                                      blurRadius: 5, // Радиус размытия
                                      color: Color.fromRGBO(0, 0, 0,
                                          0.04), // Чёрный цвет с 4% прозрачностью
                                    ),
                                  ],
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Column(children: [
                                  AdDetailPhotosWidget(
                                    imageUrls: imageUrls,
                                  ),
                                  const SizedBox(height: 4),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16,
                                              ),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    AdDetailHeaderWidget(
                                                        titleText:
                                                            adConstrutionModel
                                                                ?.title),
                                                    const SizedBox(height: 8),
                                                    AdDetailPriceWidget(
                                                      price: adConstrutionModel
                                                          ?.price
                                                          .toString(),
                                                      rating: adConstrutionModel
                                                          ?.rating,
                                                    ),
                                                  ])),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const AdDivider(),
                                                const SizedBox(height: 4),
                                                AdDescriptionOnlyWidget(
                                                  description:
                                                      adConstrutionModel
                                                              ?.description ??
                                                          '',
                                                ),
                                                const AdDivider(),
                                                const SizedBox(height: 8),
                                                SpecializedMachineryInfoWidget(
                                                  titleText:
                                                      'Информация об оборудовании',
                                                  name:
                                                      adConstrutionModel?.title,
                                                  brand: adConstrutionModel
                                                      ?.constructionMaterialBrand
                                                      ?.name,
                                                  subCategory: adConstrutionModel
                                                      ?.constructionMaterialSubCategory
                                                      ?.name,
                                                  city: adConstrutionModel
                                                      ?.city?.name,
                                                ),
                                                const SizedBox(height: 8),
                                              ],
                                            ),
                                          ),
                                          AdAuthorWidget(
                                            id: adConstrutionModel?.user?.id
                                                .toString(),
                                            userImageLink: adConstrutionModel
                                                ?.user?.urlImage,
                                            firstName: adConstrutionModel
                                                ?.user?.firstName,
                                            lastName: adConstrutionModel
                                                ?.user?.lastName,
                                            phoneNumber: adConstrutionModel
                                                ?.user?.phoneNumber,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  AppDetailLocationRow(
                                      adConstrutionModel?.address),
                                  Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: HalfScreenMapWidget(
                                        latitude: adConstrutionModel?.latitude,
                                        longitude:
                                            adConstrutionModel?.longitude,
                                      )),
                                  const SizedBox(height: 20),
                                  SendReportButton(
                                      id: widget.id,
                                      sendReport:
                                          adConstructionMaterialsRepository
                                              .sendReport),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                  )
                                ]))),
                        PageWrapper(
                            child: Column(
                          children: [
                            ...recommendationAds(context,
                                getRecommendationAds:
                                    value.getRecommendationAds,
                                retryAds: value.retryAds,
                                adID: int.parse(value.adID.toString()))
                          ],
                        )),
                      ])))),
              Padding(
                padding: AppDimensions.callButtonPadding,
                child: SeparatedRow(
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    width: AppDimensions.footerActionButtonsSeparatorWidth,
                  ),
                  children: [
                    Expanded(
                        child: AdCallButton(
                            phoneNumber:
                                adConstrutionModel?.user?.phoneNumber)),
                    Expanded(
                      child: AppPrimaryButtonWidget(
                          buttonType: ButtonType.filled,
                          onPressed: () {
                            AuthMiddleware.executeIfAuthenticated(
                                context,
                                () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AdRequestCreateScreen(
                                              adID: adConstrutionModel!.id
                                                  .toString(),
                                              adPrice: adConstrutionModel.price!
                                                  .toDouble(),
                                              approveThisUserPostToDriver: (
                                                  {required adID,
                                                  required adPrice,
                                                  required address,
                                                  required description,
                                                  required latLng,
                                                  pickedEndTime,
                                                  required pickedImages,
                                                  required pickedStart}) async {
                                                final result =
                                                    await adConstructionMaterialsRepository
                                                        .createRequestFromUserToDriverOrOwner(
                                                            adID: adID,
                                                            adPrice:
                                                                adPrice.toInt(),
                                                            address: address,
                                                            description:
                                                                description,
                                                            latLng: latLng,
                                                            pickedImages:
                                                                pickedImages,
                                                            pickedStart:
                                                                pickedStart);
                                                return result;
                                              },
                                            ))));
                          },
                          textColor: Colors.white,
                          text: AppChangeNotifier().userMode ==
                                      UserMode.client ||
                                  AppChangeNotifier().userMode == UserMode.guest
                              ? 'Отправить заказ'
                              : 'Принять заказ'),
                    ),
                  ],
                ),
              ),
            ],
          );
        }));
  }

  Widget driverOrOwnerDetailBody(
      Payload? payload, AdConstructionClientModel? adConstructionClientModel) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Объявление'),
          leading: const BackButton(),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                SharePressed(widget.id.toString(),
                    '${AppRouteNames.navigation}/${AppRouteNames.adConstructionClientList}/${AppRouteNames.adConstructionClientDetail}');
              },
              icon: const Icon(Icons.share),
            ),
            Consumer<AdConstructionDetailScreenController>(
                builder: (context, controller, child) {
              return FutureBuilder<bool>(
                  future: adConstructionMaterialsRepository
                      .isFovoriteForDriver(widget.id),
                  builder: (context, snapshot) {
                    return AppLikeButtonWrapper(
                      isLiked: snapshot.data,
                      key: controller.uniqueKey,
                      onTap: (isTapped) {
                        AuthMiddleware.executeIfAuthenticated(context,
                            () async {
                          if (snapshot.data == true) {
                            await adConstructionMaterialsRepository
                                .deleteFavoriteFromDriver(widget.id);
                          } else {
                            await adConstructionMaterialsRepository
                                .postFavoriteFromDriver(widget.id);
                          }
                          // setState(() {
                          //   appLikeButtonWrapperKey = UniqueKey();
                          // });
                          controller.changeUniqueKeyForLike();
                        });
                      },
                    );
                  });
            })
          ],
        ),
        body: Consumer<AdConstructionDetailScreenController>(
            builder: (context, value, child) {
          return Column(
            children: [
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: SingleChildScrollView(
                          child: Column(
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Фон контейнера
                                    borderRadius: BorderRadius.circular(
                                        16), // Скруглённые углы
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(
                                            -1, -1), // Смещение вверх и влево
                                        blurRadius: 5, // Радиус размытия
                                        color: Color.fromRGBO(0, 0, 0,
                                            0.04), // Чёрный цвет с 4% прозрачностью
                                      ),
                                      BoxShadow(
                                        offset: Offset(
                                            1, 1), // Смещение вниз и вправо
                                        blurRadius: 5, // Радиус размытия
                                        color: Color.fromRGBO(0, 0, 0,
                                            0.04), // Чёрный цвет с 4% прозрачностью
                                      ),
                                    ],
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Column(children: [
                                    AdDetailPhotosWidget(
                                        imageUrls: adConstructionClientModel
                                                ?.urlFoto ??
                                            []),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AdDetailHeaderWidget(
                                                  titleText:
                                                      adConstructionClientModel
                                                              ?.title ??
                                                          ''),
                                              AdDetailPriceWidget(
                                                  price:
                                                      adConstructionClientModel
                                                          ?.price
                                                          .toString()),
                                              AdDescriptionClientWidget(
                                                descriptionText:
                                                    adConstructionClientModel
                                                            ?.description ??
                                                        '',
                                                category: adConstructionClientModel
                                                    ?.constructionMaterialSubCategory
                                                    ?.name,
                                                createdAt:
                                                    adConstructionClientModel
                                                        ?.createdAt
                                                        .toString(),
                                                startDate:
                                                    adConstructionClientModel
                                                        ?.startLeaseDate
                                                        .toString(),
                                                endDate:
                                                    adConstructionClientModel
                                                        ?.endLeaseDate
                                                        .toString(),
                                              ),
                                            ],
                                          )),
                                    ),
                                    AdAuthorWidget(
                                      userImageLink: adConstructionClientModel
                                          ?.user?.urlImage,
                                      id: adConstructionClientModel?.user?.id
                                          .toString(),
                                      firstName: adConstructionClientModel
                                          ?.user?.firstName,
                                      lastName: adConstructionClientModel
                                          ?.user?.lastName,
                                      phoneNumber: adConstructionClientModel
                                          ?.user?.phoneNumber,
                                    ),
                                    AppDetailLocationRow(
                                        adConstructionClientModel?.address),
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: HalfScreenMapWidget(
                                          latitude: adConstructionClientModel
                                              ?.latitude,
                                          longitude: adConstructionClientModel
                                              ?.longitude,
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                    ),
                                    SendReportButton(
                                        id: widget.id,
                                        sendReport: (
                                            {required String adID,
                                            required int reportReasonID,
                                            required String reportText}) {
                                          final data =
                                              adConstructionMaterialsRepository
                                                  .sendReport(
                                                      adID: (adID),
                                                      reportText: reportText,
                                                      reportReasonID:
                                                          reportReasonID);
                                          return data;
                                        }),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                    )
                                  ]))),
                          PageWrapper(
                              child: Column(
                            children: [
                              ...recommendationAds(context,
                                  getRecommendationAds:
                                      value.getRecommendationAds,
                                  retryAds: value.retryAds,
                                  adID: int.parse(value.adID.toString()))
                            ],
                          ))
                        ],
                      )))),
              Padding(
                padding: AppDimensions.callButtonPadding,
                child: SeparatedRow(
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    width: AppDimensions.footerActionButtonsSeparatorWidth,
                  ),
                  children: [
                    Expanded(
                        child: AdCallButton(
                            phoneNumber:
                                adConstructionClientModel?.user?.phoneNumber ??
                                    '')),
                    Expanded(
                      child: AppPrimaryButtonWidget(
                          buttonType: ButtonType.filled,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AdClientCreateRequestScreen(
                                    onPressedCreateRequest: (
                                      value,
                                      executorID,
                                    ) async {
                                      final result =
                                          await adConstructionMaterialsRepository
                                              .createRequestFromDriverOrOwner(
                                                  value,
                                                  adConstructionClientID:
                                                      adConstructionClientModel!
                                                          .id!,
                                                  payload: payload,
                                                  executorID: executorID);
                                      return result;
                                    },
                                    payload: payload!,
                                  ),
                                ));
                          },
                          textColor: Colors.white,
                          text: AppChangeNotifier().userMode ==
                                      UserMode.client ||
                                  AppChangeNotifier().userMode == UserMode.guest
                              ? 'Отправить заказ'
                              : 'Принять заказ'),
                    ),
                  ],
                ),
              ),
            ],
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdConstructionDetailScreenController>(
        builder: (context, value, child) {
      return GlobalFutureBuilder(
          future: getPayload,
          circularProgressWidget: Material(
              color: Colors.white, child: AppCircularProgressIndicator()),
          buildWidget: (payload) {
            if (value.isLoading) {
              return Material(
                  color: Colors.white, child: AppCircularProgressIndicator());
            }
            if (value.isClient) {
              return clientDetailBody(value.adConstrutionModel);
            } else {
              return driverOrOwnerDetailBody(
                  payload, value.adConstructionClientModel);
            }
          });
    });
  }
}
