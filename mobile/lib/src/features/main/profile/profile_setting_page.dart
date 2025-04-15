import 'dart:developer';
import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_theme_provider.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_menu_row_widget.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_snack_bar.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/page_wrapper.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/get_widget.dart';
import 'package:eqshare_mobile/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:eqshare_mobile/src/features/auth/presentation/widgets/app_primary_text_field_ali.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/widgets/my_feedback.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/widgets/my_notifications_row_item.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/widgets/privacy_policy_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfileSettingPage extends StatefulWidget {
  const ProfileSettingPage({super.key});

  @override
  State<ProfileSettingPage> createState() => _ProfileSettingPageState();
}

class _ProfileSettingPageState extends State<ProfileSettingPage> {
  bool isTrackingEnabled = false;

  @override
  void initState() {
    super.initState();
    // Получаем текущее состояние геопозиции при загрузке страницы
    final controller = Provider.of<ProfileController>(context, listen: false);
    // controller.getLocationStatus();
  }

  // void toggleLocationTracking(bool value, ProfileController controller) async {
  //   // Сохраняем состояние в контроллере
  //   await controller.sendLocationStatus(value);

  //   if (value) {
  //     await bg.BackgroundGeolocation.start();
  //     log('Location tracking enabled');
  //   } else {
  //     await bg.BackgroundGeolocation.stop();
  //     log('Location tracking disabled');
  //   }
  // }

  final authRepositoryImpl = AuthRepositoryImpl();
  final textEditingController = TextEditingController();

  Builder addUserEmailButton(ProfileController controller) {
    return Builder(builder: (context) {
      final email =
          controller.user?.email != null && controller.user!.email!.isNotEmpty
              ? controller.user!.email!
              : 'Укажите свою почту';

      if (controller.user != null &&
          controller.user!.email != null &&
          controller.user!.email!.isNotEmpty) {
        textEditingController.text = controller.user!.email!;
      }

      return AppMenuRowWidget(
        onTap: () async {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          AppPrimaryTextFieldAli(
                            keyboardType: TextInputType.emailAddress,
                            readOnly: controller.user != null,
                            controller: textEditingController,
                            hintText: 'Укажите вашу почту',
                          ),
                          const SizedBox(height: 10),
                          AppPrimaryButtonWidget(
                            onPressed: () async {
                              await controller
                                  .putUserEmail(
                                      email: textEditingController.text)
                                  .then((value) {
                                textEditingController.clear();
                                if (!value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    AppSnackBar.showErrorSnackBar(
                                        'Попробуйте позже, что то пошло не так'),
                                  );
                                }
                                Navigator.pop(context);
                              });
                            },
                            textColor: Colors.white,
                            text: 'Подтвердить',
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        menuRowData: AppMenuRowData(text: email, icon: Icons.mail),
      );
    });
  }

  AppMenuRowWidget deleteButton() {
    return AppMenuRowWidget(
      onTap: () async {
        AppDialogService.showActionDialog(context,
            title: 'Действительно хотите удалить аккаунт?',
            onPressed: () async {
          AppDialogService.showLoadingDialog(context);
          try {
            await authRepositoryImpl.deleteUserAccount();
            if (mounted) context.pop();

            await TokenService().setToken(null);
            AppChangeNotifier().unnull();
            ThemeManager.instance.updateTheme(context, null);
            context.goNamed(AppRouteNames.navigation, extra: {'index': 0});
          } catch (e) {
            if (mounted) {
              // ScaffoldMessenger.of(context)
              //     .showSnackBar(snackBar(text: 'Повторите позже'));
              ScaffoldMessenger.of(context).showSnackBar(
                AppSnackBar.showErrorSnackBar('Повторите позже'),
              );
              context.pop();
              context.pop();
            } else {
              if (mounted) {
                context.pop();
              }
            }
            log('Error on deleteUser: $e');
          }
        });
      },
      menuRowData:
          const AppMenuRowData(text: 'Удалить аккаунт', icon: Icons.delete),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки профиля'),
        centerTitle: true,
      ),
      body: Consumer<ProfileController>(
        builder: (context, controller, _) {
          return PageWrapper(
              child: Container(
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white, // Фон контейнера
                    borderRadius: BorderRadius.circular(16), // Скруглённые углы
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16,),
                      AppMenuRowWidget(
                        onTap: () async {
                          context.pushNamed(AppRouteNames.subscribeForAds);
                        },
                        menuRowData: const AppMenuRowData(
                          text: 'Подписаться на объявления',
                          icon: Icons.shop_2,
                        ),
                      ),
                      AdDivider(),
                      PrivacyPolicyItem(
                          privacy_policy:
                              controller.appChangeNotifier.userMode),
                      AdDivider(),

                      MyNotificationsRowItem(profileController: controller),
                      AdDivider(),

                      MyFeedbackItem(profileController: controller),
                      AdDivider(),

                      Padding(
                        padding:
                            const EdgeInsets.only(left: 8, top: 4, bottom: 4),
                        child: Text(
                          'Настройки аккаунта',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      
                      const Padding(
                        padding: EdgeInsets.only(left: 8, right: 12),
                        child: Divider(color: Colors.grey),
                      ),
                      AppMenuRowWidget(
                        onTap: () async {
                          context
                              .pushNamed(AppRouteNames.updateOrChangePassword);
                        },
                        menuRowData: const AppMenuRowData(
                          text: 'Изменить пароль',
                          icon: Icons.password,
                        ),
                      ),
                      AdDivider(),

                      deleteButton(),
                      AdDivider(),

                      addUserEmailButton(controller),
                      AdDivider(),


                      // Location Tracking Toggle
                      // Padding(
                      //   padding: const EdgeInsets.all(16.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         'Включить отслеживание локации',
                      //         style: Theme.of(context).textTheme.bodyLarge,
                      //         softWrap: true,
                      //       ),
                      //       Switch(
                      //         value: controller.isLocationTrackingEnabled,
                      //         inactiveTrackColor:
                      //             Colors.grey, // Make it highly visib
                      //         onChanged: (value) =>
                      //             toggleLocationTracking(value, controller),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    
                    ],
                  )));
        },
      ),
    );
  }
}
