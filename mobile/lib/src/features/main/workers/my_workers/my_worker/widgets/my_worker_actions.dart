import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_call_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../my_worker_controller.dart';

class ActionsContent extends StatelessWidget {
  final int workerId;
  final String phoneNumber;

  const ActionsContent(
      {super.key, required this.workerId, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<MyWorkerController>(context, listen: false);

    return Column(
      children: [
        AppPrimaryButtonWidget(
          text: 'Посмотреть геолокацию',
          onPressed: () {
            // Navigator.pushNamed(context, AppRouteNames.myWorkersOnMap);
            context.pushNamed(
              AppRouteNames.myWorkersOnMap,
              extra: {'workerId': workerId.toString()},
            );
          },
          buttonType: ButtonType.outlined,
        ),
        const SizedBox(height: 10),
        AppPrimaryButtonWidget(
          text: 'Позвонить',
          onPressed: () {
            CallOptionsFunctions().onCallPressed(context, phoneNumber);
          },
          buttonType: ButtonType.outlined,
        ),
        const SizedBox(height: 10),
        AppPrimaryButtonWidget(
          text: 'Написать Whatsapp',
          onPressed: () {
            controller.onWhatsAppPressed(
                context, workerId.toString(), phoneNumber);
          },
          buttonType: ButtonType.outlined,
        ),
        const SizedBox(height: 10),
        AppPrimaryButtonWidget(
          text: 'Удалить водителя',
          textColor: Colors.white,
          onPressed: () async {
            final shouldDelete = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Подтверждение'),
                  content:
                      const Text('Вы уверены, что хотите удалить водителя?'),
                  actions: [
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pop(false), // Cancel
                      child: const Text('Нет'),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pop(true), // Confirm
                      child: const Text('Да'),
                    ),
                  ],
                );
              },
            );

            if (shouldDelete == true) {
              controller.onDeleteTap(context, workerId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Водитель успешно удален.')),
              );
            }
          },
        ),
      ],
    );
  }
}
