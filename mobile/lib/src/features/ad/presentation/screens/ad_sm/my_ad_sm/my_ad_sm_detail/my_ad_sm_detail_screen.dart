import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_detail_location_row.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_dimensions.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_model/ad_specialized_machinery.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_interacted_list/ad_sm_interacted_list.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/my_ad_sm/my_ad_sm_detail/edit_my_ad_sm_detail_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/my_ad_sm/my_ad_sm_detail/edit_my_ad_sm_detail_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/utils/parameters_utils.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/get_widget.dart';
import 'package:eqshare_mobile/src/features/main/location/detail_map_screen.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/specialized_machinery_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:separated_row/separated_row.dart';

import 'my_ad_sm_detail_controller.dart';

class MyAdSMDetailScreen extends StatefulWidget {
  final String adId;

  const MyAdSMDetailScreen({
    super.key,
    required this.adId,
  });

  @override
  State<MyAdSMDetailScreen> createState() => _MyAdSMDetailScreenState();
}

class _MyAdSMDetailScreenState extends State<MyAdSMDetailScreen> {
  late MyAdSMDetailController controller;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    await Provider.of<MyAdSMDetailController>(context, listen: false)
        .loadDetails(context);
  }

  @override
  void initState() {
    controller = Provider.of<MyAdSMDetailController>(context, listen: false);

    super.initState();
  }

  AppBar appBar(MyAdSMDetailController newController) {
    return AppBar(
      title: const Text('Спецтехника'),
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back_ios_new),
      ),
    );
  }

  Column _buildContent(
    MyAdSMDetailController controller,
    AdSpecializedMachinery? adDetail,
    AdSmInteractedList? adSmInteractedList,
    BuildContext context,
  ) {
    return Column(children: [
      Expanded(
          child: Padding(
        padding: EdgeInsets.only(top: 5.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Фон контейнера
                      borderRadius:
                          BorderRadius.circular(16), // Скруглённые углы
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(-1, -1), // Смещение вверх и влево
                          blurRadius: 5, // Радиус размытия
                          color: Color.fromRGBO(
                              0, 0, 0, 0.04), // Чёрный цвет с 4% прозрачностью
                        ),
                        BoxShadow(
                          offset: Offset(1, 1), // Смещение вниз и вправо
                          blurRadius: 5, // Радиус размытия
                          color: Color.fromRGBO(
                              0, 0, 0, 0.04), // Чёрный цвет с 4% прозрачностью
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        AdDetailPhotosWidget(
                            imageUrls: controller.adDetails?.urlFoto ?? []),
                        const SizedBox(height: 4),
    Padding(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child:
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildAdSMHeader(adDetail),
                              const SizedBox(height: 8),
                              AdDetailPriceWidget(
                                price: adDetail?.price.toString(),
                              ),
                              const SizedBox(height: 4),
                               Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AdDivider(),
                                    AdDescriptionOnlyWidget(
                                        description:
                                            adDetail?.description ?? ''),
                                    const Padding(
                                        padding: EdgeInsets.all(1),
                                        child: AdDivider()),
                                    const SizedBox(height: 8),
                                    SpecializedMachineryInfoWidget(
                                      urlFoto: null,
                                      name: adDetail?.name,
                                      brand: adDetail?.brand?.name,
                                      subCategory: adDetail?.type?.name,
                                      price: null,
                                      city: adDetail?.city?.name,
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.all(0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Row(
                                            children: [
                                              Text('Общие характеристики',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16)),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          ...adDetail?.params
                                                  ?.toJson()
                                                  .entries
                                                  .map((entry) {
                                                if (entry.value != null &&
                                                    entry.key !=
                                                        'ad_specialized_machinery_id') {
                                                  return ParametersUtils
                                                      .formatParameter(
                                                          entry.key,
                                                          entry.value);
                                                } else {
                                                  return const SizedBox
                                                      .shrink();
                                                }
                                              }).toList() ??
                                              <Widget>[],
                                          const SizedBox(height: 20),
                                          AppDetailLocationRow(
                                              controller.adDetails?.address),
                                          HalfScreenMapWidget(
                                            latitude:
                                                controller.adDetails?.latitude,
                                            longitude:
                                                controller.adDetails?.longitude,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                            ])),
                        _buildActionsButtons(controller)
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ))
    ]);
  }

  Text buildAdSMHeader(AdSpecializedMachinery? adDetail) {
    return Text(
      adDetail?.name ?? '',
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildActionsButtons(MyAdSMDetailController controller) {
    return Padding(
      padding: AppDimensions.footerActionButtonsPadding,
      child: SeparatedRow(
        children: [
          _buildDeleteButton(),
          _buildEditButton(),
        ],
        separatorBuilder: (context, index) => const SizedBox(
            width: AppDimensions.footerActionButtonsSeparatorWidth),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return AdDeleteButton(delete: () async {
      await controller.onDeleteTap();
    });
  }

  Widget _buildEditButton() {
    return AdEditButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChangeNotifierProvider(
            create: (context) => EditMyAdSmDetailController(
                adSpecializedMachinery: controller.adDetails!),
            child: const EditMyAdSmDetailScreen(),
          );
        }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyAdSMDetailController>(
      builder: (context, controller, _) {
        final adDetail = controller.adDetails;
        final adSmInteractedList = controller.adSmInteractedList;
        return Scaffold(
            appBar: appBar(controller),
            body: !controller.isLoading
                ? _buildContent(
                    controller, adDetail, adSmInteractedList, context)
                : const AppCircularProgressIndicator());
      },
    );
  }
}
