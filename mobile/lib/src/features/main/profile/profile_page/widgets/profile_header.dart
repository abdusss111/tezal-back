import 'package:eqshare_mobile/src/core/presentation/services/app_bottom_sheet_service.dart';
import 'package:eqshare_mobile/src/core/presentation/services/image_picker_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_image_network_widget.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/rating_with_star_widget.dart';
import 'package:eqshare_mobile/src/core/res/app_images.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/widgets/edit_name_bottom_sheet.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileController profileController;

  const ProfileHeader({
    super.key,
    required this.profileController,
  });

  @override
  Widget build(BuildContext context) {
    final userModeText =
    getUserModeText(profileController.appChangeNotifier.userMode);

    return SizedBox(
        height: 120,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  final data = await ImageService.pickImage(context,
                      openScreenType: OpenScreenType.bottomSheet,
                      imageQuality: 5);
                  if (data != null && context.mounted) {
                    await profileController.patchUserImage(context, data);
                  }
                },
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: AppImageNetworkWidget(
                    imageUrl: profileController.user?.customUrlImage ?? profileController.user?.urlImage ?? '',
                    width: 80,
                    height: 80,
                    key: UniqueKey(), // 🔥 Обновляем UI после загрузки фото
                    imagePlaceholder: AppImages.profilePlaceholder,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () => AppBottomSheetService
                                    .showAppMaterialModalBottomSheet(
                                  context,
                                  EditNameBottomSheet(
                                      profileController: profileController),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: FittedBox(
                                        child: Text(
                                          profileController
                                              .getFormattedName()
                                              .isEmpty
                                              ? 'Напишите имя'
                                              : profileController
                                              .getFormattedName(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: Icon(
                                        size: 22,
                                        Icons.edit,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              if (profileController
                                  .appChangeNotifier.userMode ==
                                  UserMode.driver ||
                                  profileController
                                      .appChangeNotifier.userMode ==
                                      UserMode.owner)
                                RatingWithStarWidget(
                                  rating: profileController.user?.rating,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            '$userModeText  ${profileController.user?.owner ?? ''}',
                            style: Theme.of(context).textTheme.titleLarge),
                        Text('${profileController.user?.phoneNumber}',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  String getUserModeText(UserMode? userMode) {
    switch (userMode) {
      case UserMode.driver:
        return 'Водитель';
      case UserMode.owner:
        return 'Бизнес';
      default:
        return 'Клиент';
    }
  }
}
