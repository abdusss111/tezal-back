import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';

import 'package:eqshare_mobile/src/core/presentation/widgets/get_core_widgets.dart';
import 'package:eqshare_mobile/src/core/res/app_images.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_client_interacted_model/ad_client_interacted.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/get_widget.dart';

import 'package:flutter/material.dart';

class ShowCallerModelForClientRequest {
  Widget _getWidgetFromValuesSnapshot({
    required AsyncSnapshot<List<AdClientInteracted>?> snapshot,
    required Future<dynamic> Function(User?) sendRentRequest,
    required Future<dynamic> Function() deleteAd,
  }) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const AppCircularProgressIndicator();
    } else if (snapshot.hasError || snapshot.data == null) {
      return const Center(child: Text('Нет данных'));
    } else if (snapshot.data != null) {
      final adClientInteractedList = snapshot.data ?? [];
      return Column(
        children: [
          Expanded(
            child: adClientInteractedList.isNotEmpty
                ? ListView.builder(
                    itemCount: adClientInteractedList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final ad = adClientInteractedList[index];
                      return GestureDetector(
                        onTap: () {
                          _sendRentRequest(context,
                              user: ad.user, sendRentRequest: sendRentRequest);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              AppImageNetworkWidget(
                                imageUrl: ad.user?.urlImage,
                                imagePlaceholder: AppImages.profilePlaceholder,
                                width: 80,
                                height: 80,
                              ),
                              const SizedBox(width: 28),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    ad.user?.firstName ?? '',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(ad.user?.phoneNumber ?? ''),
                                      const SizedBox(width: 28),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const Center(child: Text('Нет данных')),
          ),
          Padding(
              padding: const EdgeInsets.all(5),
              child: AdDeleteButton(
                isExpanded: false,
                delete: () async {
                  await deleteAd();
                },
              ))
        ],
      );
    } else {
      return const Center(child: Text('Нет данных'));
    }
  }

  Future<dynamic> _sendRentRequest(
    BuildContext context, {
    required User? user,
    required Future<dynamic> Function(User?) sendRentRequest,
  }) {
    return AppDialogService.showActionDialog(context,
        title:
            'Выбран водитель\n\n${user?.firstName ?? ''} ${user?.lastName ?? ''}',
        onPressed: () async {
      sendRentRequest(user);
    });
  }

  void showCallerModal(
    BuildContext context, {
    required Future<List<AdClientInteracted>?> getAdClientInteracted,
    required Future<dynamic> Function(User?) sendRentRequest,
    required Future<dynamic> Function() deleteAd,
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SizedBox.fromSize(
          size: Size(double.infinity, MediaQuery.of(context).size.height * 0.7),
          child: FutureBuilder<List<AdClientInteracted>?>(
              future: getAdClientInteracted,
              builder: (context, snapshot) {
                return _getWidgetFromValuesSnapshot(
                    snapshot: snapshot,
                    sendRentRequest: sendRentRequest,
                    deleteAd: deleteAd);
              }),
        );
      },
    );
  }
}
