import 'dart:developer';

import 'package:eqshare_mobile/src/features/ad/data/models/ad_client_interacted_model/ad_client_interacted.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_dimensions.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_interacted_list/ad_service_interacted.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_client_model/ad_client.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm_client/my_ad_sm_client/ad_sm_client_create/ad_sm_client_create_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm_client/my_ad_sm_client/ad_sm_client_create/ad_sm_client_create_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/my_ad_screens/widgets/show_caller_model_for_client_request.dart';

import 'package:eqshare_mobile/src/features/main/location/detail_map_screen.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/sm_request_repository_impl.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';
import 'package:separated_row/separated_row.dart';

import '../../../ad_sm/my_ad_sm/my_ad_sm_detail/my_ad_sm_detail_screen.dart';
import 'my_ad_sm_client_detail_controller.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/widgets/get_widget.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/get_core_widgets.dart';

class MyAdSMClientDetailScreen extends StatefulWidget {
  final String adId;

  const MyAdSMClientDetailScreen({
    super.key,
    required this.adId,
  });

  @override
  State<MyAdSMClientDetailScreen> createState() =>
      _MyAdSMClientDetailScreenState();
}

class _MyAdSMClientDetailScreenState extends State<MyAdSMClientDetailScreen> {
  late MyAdSMClientDetailController controller;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await Provider.of<MyAdSMClientDetailController>(context, listen: false)
        .loadDetails(context);
    if (!mounted) return;
    await Provider.of<MyAdSMClientDetailController>(context, listen: false)
        .loadInteractedDetails(context);
  }

  @override
  void initState() {
    controller = MyAdSMClientDetailController(widget.adId);

    super.initState();
  }

  Column _buildContent(
    MyAdSMClientDetailController controller,
    AdClient? adDetail,
    List<AdClientInteracted>? adClientInteractedList,
    BuildContext context,
  ) {
    final adClientInteracted = adClientInteractedList;
    final String? adStatus = controller.adDetails?.status;
    List<String?> imageUrls = controller.adDetails?.documents
            ?.map((document) => document.shareLink)
            .toList() ??
        [];
    log(imageUrls.toString(), name: 'ImageUrl :');
    return Column(children: [
      Expanded(
        child: ListView(
          children: [
            AdDetailPhotosWidget(
              imageUrls: imageUrls,
            ),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    adDetail?.headline ?? '',
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
                  if (adDetail?.deletedAt != null)
                    const Text(
                      'Статус',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  if (adDetail?.deletedAt != null) const SizedBox(height: 8),
                  if (adDetail?.deletedAt != null) const Text('Удалено'),
                  if (adDetail?.deletedAt != null) const SizedBox(height: 8),
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
                    adDetail?.type?.name ?? '',
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
                  adClientInteracted?.isNotEmpty == true
                      ? AdInteractedListView(
                          adClientInteracted: adClientInteracted,
                        )
                      : const SizedBox(),
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

  Widget _buildActionButtons(String? adStatus, int id) {
    return Padding(
      padding: AppDimensions.footerActionButtonsPadding,
      child: SeparatedRow(
        children: [
          if (adStatus == 'CREATED') _buildFinishButton(),
          AdEditButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ChangeNotifierProvider(
                    create: (context) => AdSMClientCreateController(editID: id),
                    child: const AdSMClientCreateScreen());
              }));
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
              getAdClientInteracted: controller.getAdClientInteracted(),
              deleteAd: () async {
            controller.onDeleteTap().then((value) {
              if (mounted) {
                context.pop();
              }
            });
          }, sendRentRequest: (user) {
            return _sendRequestToServer(
                controller.adId, (user?.id ?? 0).toString());
          });
        },
        text: 'Завершить',
      ),
    );
  }

  Future<void> _sendRequestToServer(String adClientId, String userId) async {
    try {
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
      final response = await SMRequestRepositoryImpl()
          .postClientRequestForceApprove(adId: adClientId, userId: userId);

      // if (mounted) Navigator.pop(context);
      if (mounted) context.pop();

      if (response?.statusCode == 200) {
        if (mounted) {
          AppDialogService.showSuccessDialog(
            context,
            title: 'Заказ успешно подтвержден',
            onPressed: () {
              context.pop();
              context.pop();
              context.pop();
              context.pop(true);
            },
            buttonText: 'Мои объявления',
          );
        }
        debugPrint('Заказ успешно подтвержден');
      } else {
        if (mounted) {
          context.pop();
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Ошибка при отправке заказа: ${response?.statusCode}')));
        }
        debugPrint('Ошибка при отправке заказа: ${response?.statusCode}');
      }
    } catch (e) {
      debugPrint('Ошибка при отправке заказа: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyAdSMClientDetailController>(
      builder: (context, controller, _) {
        final adDetail = controller.adDetails;
        final adClientInteractedList = controller.adClientInteractedList;

        return Scaffold(
            appBar: AppBar(
              title: const Text('Объявление'),
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
            ),
            body: !controller.isLoading
                ? _buildContent(
                    controller, adDetail, adClientInteractedList, context)
                : const AppCircularProgressIndicator());
      },
    );
  }
}

class AdInteractedListView extends StatelessWidget {
  final List<AdClientInteracted>? adClientInteracted;
  final List<AdServiceInteracted>? adServiceInteracted;

  const AdInteractedListView({
    super.key,
    this.adClientInteracted,
    this.adServiceInteracted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            'Вам звонили с этих номеров:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          ListView.builder(
            itemCount: adServiceInteracted != null
                ? adServiceInteracted?.length
                : adClientInteracted != null
                    ? adClientInteracted?.length
                    : 0,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final adServiceInteractedItem = adServiceInteracted?[index];
              final adClientInteractedItem = adClientInteracted?[index];
              final adInteractedListTile = adServiceInteractedItem != null
                  ? ListTile(
                      subtitle: Text(
                        adServiceInteractedItem.user?.phoneNumber ?? '',
                      ),
                      title: Text(
                        '${adServiceInteractedItem.user?.firstName ?? ''} ${adServiceInteractedItem.user?.lastName ?? ''}',
                      ),
                    )
                  : adClientInteractedItem != null
                      ? ListTile(
                          title: Text(
                            adClientInteractedItem.user?.phoneNumber ?? '',
                            style: const TextStyle(fontSize: 14),
                          ),
                        )
                      : const SizedBox();
              return Column(
                children: [
                  adInteractedListTile,
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
