import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_dimensions.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:separated_row/separated_row.dart';

class ApproveOrCancelButtons extends StatelessWidget {
  final Future<bool> Function() approve;
  final Future<bool> Function() cancel;

  const ApproveOrCancelButtons(
      {super.key, required this.approve, required this.cancel});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return SafeArea(child: Padding(
        padding: AppDimensions.footerActionButtonsPadding,
        child: SeparatedRow(
            separatorBuilder: (context, int index) => const SizedBox(
                  width: AppDimensions.footerActionButtonsSeparatorWidth,
                ),
            children: [
              Expanded(
                child: AppPrimaryButtonWidget(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    textColor: Theme.of(context).primaryColor,
                    borderColor: Theme.of(context).primaryColor,
                    onPressed: () async {
                      AppDialogService.showLoadingDialog(context);
                      bool result = await cancel();
                      if (result && context.mounted) {
                        AppDialogService.showSuccessDialog(context,
                            title: 'Отменено', onPressed: () {
                          context.pop();
                          context.pop();
                        }, buttonText: 'Назад');
                      }
                    },
                    text: 'Отменить'),
              ),
              Expanded(
                child: AppPrimaryButtonWidget(
                    onPressed: () async {
                      if (AppChangeNotifier().userMode == UserMode.owner) {
                        showCallOptions(context, assign: (String userId) async {
                          return await approve();
                        });
                      } else {
                        AppDialogService.showLoadingDialog(context);
                        bool result = await approve();
                        if (result && context.mounted) {
                          AppDialogService.showSuccessDialog(context,
                              title: 'Принято', onPressed: () {
                            context.pop();
                            context.pop();
                          }, buttonText: 'Назад');
                        }
                      }
                    },
                    textColor: Colors.white,
                    text: 'Согласовать'),
              ),
            ]),
      ));
    });
  }
}
