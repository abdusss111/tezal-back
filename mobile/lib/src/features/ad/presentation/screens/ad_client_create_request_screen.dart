import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/models/payload/payload.dart';
import 'package:eqshare_mobile/src/core/data/services/network/api_client/user_profile_api_client.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/res/app_images.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/global_widgets/global_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// [adID] айди самого объявление
class AdClientCreateRequestScreen extends StatefulWidget {
  final Payload payload;

  final Future<bool> Function(String, int) onPressedCreateRequest;

  const AdClientCreateRequestScreen(
      {super.key, required this.onPressedCreateRequest, required this.payload});

  @override
  State<AdClientCreateRequestScreen> createState() =>
      _AdClientCreateRequestScreenState();
}

class _AdClientCreateRequestScreenState
    extends State<AdClientCreateRequestScreen> {
  final descriptionController = TextEditingController();
  final workersApiClient = UserProfileApiClient();

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> showCallOptions() async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.account_box_rounded),
              title: const Text('Назначить себе'),
              onTap: () async {
                AppDialogService.showLoadingDialog(context);
                final result = await widget.onPressedCreateRequest(
                    descriptionController.text, int.parse(widget.payload.sub!));
                if (context.mounted) {
                  onSuccessDialog(result, context);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_rounded),
              title: const Text('Назначить одному из моих водителей'),
              onTap: () async {
                _showModal();
              },
            ),
          ],
        );
      },
    );
  }

  void _showModal() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return GlobalFutureBuilder(
            buildWidget: (users) {
              final workerList = users;
              if (workerList == null || workerList.isEmpty) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: const Center(
                    child: Text('Нет данных о водителей'),
                  ),
                );
              }
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  children: [
                    ListTile(
                      leading: IconButton(
                        onPressed: () {
                          // Navigator.of(context).pop();
                          context.pop();
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      title: const Text('Ваши водители'),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: workerList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final worker = workerList[index];
                          return GestureDetector(
                            onTap: () async {
                              AppDialogService.showLoadingDialog(context);
                              final result =
                                  await widget.onPressedCreateRequest(
                                      descriptionController.text, worker.id!);

                              if (context.mounted) {
                                onSuccessDialog(result, context);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Image.asset(
                                    AppImages.profilePlaceholder,
                                    width: 50,
                                    height: 50,
                                  ),
                                  const SizedBox(width: 28),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        '${worker.firstName ?? ''} ${worker.lastName ?? ''}',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(worker.phoneNumber ?? ''),
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
                      ),
                    ),
                  ],
                ),
              );
            },
            future: workersApiClient.getMyWorkers(widget.payload.sub!));
      },
    );
  }

  void onSuccessDialog(bool result, BuildContext context) {
    if (result) {
      AppDialogService.showSuccessDialog(context, title: 'Успешно отправлено',
          onPressed: () {
        context.pop();
        context.pop();
      }, buttonText: 'Назад');
    } else {
      AppDialogService.showNotValidFormDialog(context, 'Попробуйте позднее');
    }
  }

  Column buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          maxLines: 3,
          controller: descriptionController,
          decoration: InputDecoration(
            hintText: 'Введите описание заказа',
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Заказ клиенту'),
          leading: IconButton(
            // onPressed: () => Navigator.pop(context),
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('Детали заказа:',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                buildDescription(),
                const SizedBox(height: 16),
                AppPrimaryButtonWidget(
                    onPressed: () async {
                      if (widget.payload.aud == 'DRIVER') {
                        if (descriptionController.text.isNotEmpty) {
                          AppDialogService.showLoadingDialog(context);
                          final result = await widget.onPressedCreateRequest(
                              descriptionController.text,
                              int.parse(widget.payload.sub!));
                          if (!context.mounted) return;
                          context.pop();

                          onSuccessDialog(result, context);
                        }
                      } else {
                        await showCallOptions();
                      }
                    },
                    textColor: Colors.white,
                    text: AppChangeNotifier().userMode == UserMode.client ||
                            AppChangeNotifier().userMode == UserMode.guest
                        ? 'Отправить заказ'
                        : 'Принять заказ'),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ));
  }
}
