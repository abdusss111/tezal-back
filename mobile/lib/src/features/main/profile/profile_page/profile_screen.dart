import 'dart:developer';

import 'package:eqshare_mobile/src/core/presentation/services/app_theme_provider.dart';

import 'package:eqshare_mobile/src/core/presentation/utils/string_format_helper.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_menu_row_widget.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_colors.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/get_widget.dart';
import 'package:eqshare_mobile/src/features/home/location_permission_status_widget.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/widgets/my_ad_equipment_list_row_item.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/widgets/my_construction_list_row_item.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/widgets/my_favorites_row_item.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/widgets/my_service_list_row_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../../main.dart';
import '../../../../core/data/services/storage/token_provider_service.dart';
import '../../../../core/presentation/routing/app_route.dart';
import '../../../../core/presentation/widgets/non_authenticated_widget.dart';
import 'profile_controller.dart';
import 'widgets/my_ad_sm_list_row_item.dart';
import 'widgets/my_drivers_row_item.dart';
import 'widgets/profile_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _switchUserMode(BuildContext context, UserMode userMode) async {
    await Provider.of<ProfileController>(context, listen: false)
        .switchMode(context: context, userMode: userMode);
  }

  final ProfileController profileController = ProfileController(appChangeNotifier: appChangeNotifier);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    log(
        Provider.of<ProfileController>(context, listen: false)
            .isLoading
            .toString(),
        name: 'ISLoadingL ');
    getToken();
  }

  void getToken() async {
    final teoke = await TokenService().getToken();
    log(teoke.toString(), name: 'Token ');
  }

  Future<void> _checkAndRequestLocationPermission(
      ProfileController controller) async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission != LocationPermission.always) {
      final requestedPermission = await Geolocator.requestPermission();
      if (requestedPermission == LocationPermission.denied ||
          requestedPermission != LocationPermission.always) {
        await Geolocator.openAppSettings(); // Открытие настроек приложения
      }
    } else if (permission == LocationPermission.deniedForever ||
        permission != LocationPermission.always) {
      Geolocator.openAppSettings();
    }
  }

  void toggleLocationTracking(bool value, ProfileController controller) async {
    final permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.always) {
      await controller.sendLocationStatus(value);
      HapticFeedback.mediumImpact();
      // if (value) {
      //   await bg.BackgroundGeolocation.start();
      //   log('Location tracking enabled');
      // } else {
      //   await bg.BackgroundGeolocation.stop();
      //   log('Location tracking disabled');
      // }
    } else {
      await _checkAndRequestLocationPermission(controller);
    }
  }

  Widget _buildProfileBody() {
    return Consumer<ProfileController>(
      builder: (context, value, child) {
        log(DateTime.now().toString(), name: 'Date : ');
        final isOwner = value.appChangeNotifier.userMode == UserMode.owner;
        final isDriver = value.appChangeNotifier.userMode == UserMode.driver;
        final bool isAuthenticated = value.appChangeNotifier.payload != null;
        if (isAuthenticated) {
          return Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16, top: 16, bottom: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      ProfileHeader(profileController: value),
                      const SizedBox(
                        height: 16,
                      ),
                      if (isAuthenticated) _buildUserModeButtons(value),
                      const SizedBox(height: 16),
                      Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white, // Фон контейнера
                              borderRadius:
                                  BorderRadius.circular(16), // Скруглённые углы
                              boxShadow: [
                                BoxShadow(
                                  offset:
                                      Offset(-1, -1), // Смещение вверх и влево
                                  blurRadius: 5, // Радиус размытия
                                  color: Color.fromRGBO(0, 0, 0,
                                      0.04), // Чёрный цвет с 4% прозрачностью
                                ),
                                BoxShadow(
                                  offset:
                                      Offset(1, 1), // Смещение вниз и вправо
                                  blurRadius: 5, // Радиус размытия
                                  color: Color.fromRGBO(0, 0, 0,
                                      0.04), // Чёрный цвет с 4% прозрачностью
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                if (isDriver)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 6.0,
                                      right: 6.0,
                                      top: 6.0,
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.085,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.048,
                                            child: LocationPermissionStatus(
                                              iconSize: 32,
                                            )),
                                        const SizedBox(width: 18),
                                        Expanded(
                                          child: Text(
                                            'Отслеживание локации',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                            softWrap: true,
                                          ),
                                        ),
                                        Consumer<ProfileController>(
                                          builder:
                                              (context, profileController, _) {
                                            return FutureBuilder(
                                              future:
                                                  Geolocator.checkPermission(),
                                              builder: (context, snapshot) {
                                                final isPermitted =
                                                    snapshot.data ==
                                                            LocationPermission
                                                                .always ||
                                                        snapshot.data ==
                                                            LocationPermission
                                                                .whileInUse;
                                                return GestureDetector(
                                                  onTap: () =>
                                                      toggleLocationTracking(
                                                          !profileController
                                                              .isLocationTrackingEnabled,
                                                          profileController),
                                                  child: AbsorbPointer(
                                                    child: Switch(
                                                      value: profileController
                                                          .isLocationTrackingEnabled,
                                                      inactiveTrackColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              201,
                                                              201,
                                                              201),
                                                      onChanged: isPermitted
                                                          ? (value) =>
                                                              toggleLocationTracking(
                                                                  value,
                                                                  profileController)
                                                          : null,
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                if (isDriver) AdDivider(),
                                MyFavoritesRowItem(profileController: value),
                                AdDivider(),
                                MyAdSMListRowItem(profileController: value),
                                AdDivider(),
                                MyAdEquipmentListRowItem(
                                    profileController: value),
                                AdDivider(),
                                MyConstructionListRowItem(
                                    profileController: value),
                                AdDivider(),
                                MyServiceListRowItem(profileController: value),
                                if (isOwner) AdDivider(),
                                if (isOwner)
                                  MyDriversRowItem(profileController: value),
                                if (!isDriver) AdDivider(),
                                if (isDriver) AdDivider(),
                                AppMenuRowWidget(
                                  onTap: () {
                                    context.pushNamed(
                                        AppRouteNames.profileSettings);
                                  },
                                  menuRowData: const AppMenuRowData(
                                    text: 'Настройки',
                                    icon: Icons.manage_accounts,
                                  ),
                                ),
                                AdDivider(),
                                AppMenuRowWidget(
                                  onTap: () async {
                                    await StringFormatHelper
                                        .tryOpenWhatsAppWithNumber(
                                            '+77769992242',
                                            infoText:
                                                'Здравствуйте! У меня есть вопрос/предложение по приложению Mezet.');
                                  },
                                  menuRowData: const AppMenuRowData(
                                    text: 'Связаться с поддержкой',
                                    icon: Icons.contact_support_outlined,
                                  ),
                                ),
                              ],
                            )),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return const NonAuthenticatedWidget();
        }
      },
    );
  }

  Widget _buildUserModeButtons(ProfileController controller) {
    final userMode = controller.appChangeNotifier.userMode;
    final isDriver = userMode == UserMode.driver;
    final isOwner = userMode == UserMode.owner;

    final textStyle = Theme.of(context)
        .textTheme
        .labelLarge
        ?.copyWith(color: Colors.white, fontSize: 15);
    const double height = 48;

    return Column(
      children: [
        if (isDriver) ...[
          AppPrimaryButtonWidget(
            height: height,
            backgroundColor: AppColors.appOwnerPrimaryColor,
            onPressed: () => _switchUserMode(context, UserMode.owner),
            text: 'Переключиться в режим бизнеса',
            icon: Icons.arrow_forward_ios_outlined,
            textStyle: textStyle,
          ),
          const SizedBox(height: 6),
        ],
        if (isOwner) ...[
          AppPrimaryButtonWidget(
            height: height,
            backgroundColor: AppColors.appDriverPrimaryColor,
            onPressed: () => _switchUserMode(context, UserMode.driver),
            text: 'Переключиться в режим водителя',
            icon: Icons.arrow_forward_ios_outlined,
            textStyle: textStyle,
          ),
          const SizedBox(height: 6),
        ],
        AppPrimaryButtonWidget(
            height: height,
            backgroundColor: isDriver || isOwner
                ? AppColors.appPrimaryColor
                : AppColors.appDriverPrimaryColor,
            onPressed: () => _switchUserMode(context,
                isDriver || isOwner ? UserMode.client : UserMode.driver),
            text: isDriver || isOwner
                ? 'Переключиться в режим клиента'
                : 'Переключиться в режим водителя',
            icon: Icons.arrow_forward_ios_outlined,
            textStyle: textStyle),
        // const SizedBox(height: 20), // Adding some space from the bottom
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(microseconds: 100)),
      builder: (context, snapshot) => Consumer<ProfileController>(
        builder: (context, controller, _) {
          final bool isAuthenticated =
              controller.appChangeNotifier.payload != null;
          return Builder(builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Профиль'),
                actions: [
                  if (isAuthenticated)
                    IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () async {
                          final shouldLogout = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Выход из аккаунта', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                content: const Text(
                                    'Вы действительно хотите выйти из аккаунта?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(
                                          false); // Пользователь нажал "Нет"
                                    },
                                    child: const Text('Нет'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(true); // Пользователь нажал "Да"
                                    },
                                    child: const Text('Да'),
                                  ),
                                ],
                              );
                            },
                          );

                          if (shouldLogout == true) {
                            await TokenService().setToken(null);
                            if (context.mounted) {
                              ThemeManager.instance.updateTheme(context, null);
                              controller.appChangeNotifier.unnull();
                              controller.unnull();
                              context.pushReplacementNamed(
                                AppRouteNames.navigation,
                              );
                              setState(() {});
                            }
                          }
                        }),
                ],
              ),
              body: controller.isLoading
                  ? const AppCircularProgressIndicator()
                  : _buildProfileBody(),
            );
          });
        },
      ),
    );
  }
}
