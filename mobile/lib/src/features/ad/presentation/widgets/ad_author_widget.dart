import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/get_core_widgets.dart';
import 'package:eqshare_mobile/src/core/res/app_images.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/get_widget.dart';
import 'package:flutter/material.dart';

class AdAuthorWidget extends StatelessWidget {
  const AdAuthorWidget(
      {super.key,
      this.firstName,
      this.lastName,
      this.userImageLink,
      this.phoneNumber,
      this.id = '160'});
  final String? firstName;
  final String? userImageLink;

  final String? lastName;
  final String? id;
  final String? phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
      child: GestureDetector(
        onTap: () {
          router.pushNamed(AppRouteNames.userScreen,
              pathParameters: {'slug': id ?? ''});
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Автор объявления',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8,),
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // Фон контейнера
                borderRadius: BorderRadius.circular(8), // Скруглённые углы
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
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppImageNetworkWidget(
                      imageUrl: userImageLink,
                      imagePlaceholder: AppImages.profilePlaceholder,
                      width: 50,
                      height: 50,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                                maxLines: 2,
                                '${(firstName != null && firstName!.isNotEmpty) ? firstName : 'Неизвестный клиент'} ${(lastName != null && lastName!.isNotEmpty) ? lastName : ''}',
                                style: Theme.of(context).textTheme.bodyLarge),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(0),
                              child: Divider(color: Colors.grey.shade100)),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: InkWell(
                              onTap: () {
                                if (phoneNumber != null &&
                                    phoneNumber!.length > 5) {
                                  CallOptionsFunctions()
                                      .onCallPressed(context, phoneNumber);
                                }
                              },
                              child: Text(phoneNumber ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: Colors.orangeAccent)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
