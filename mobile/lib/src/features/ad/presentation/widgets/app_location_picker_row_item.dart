import 'package:eqshare_mobile/src/core/presentation/widgets/app_menu_row_widget.dart';
import 'package:eqshare_mobile/src/features/main/location/select_job_place_location_screen.dart';
import 'package:flutter/material.dart';

class AppLocationPickerRowItem extends StatelessWidget {
  final Function(Map<String, dynamic>) onLocationSelected;
  final String? selectedAddress;
  final String hintText;

  const AppLocationPickerRowItem({
    super.key,
    required this.onLocationSelected,
    required this.selectedAddress,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return AppMenuRowWidget(
        textStyle: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.normal),
        onTap: () async {
          Map<String, dynamic>? result = await Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return MapPickerWidget();
                },
                transitionDuration: Duration.zero, // Отключаем анимацию
                reverseTransitionDuration:
                    Duration.zero, // Отключаем обратную анимацию
              ));
          if (result != null) {
            onLocationSelected(result);
          }
        },
        menuRowData: AppMenuRowData(
            text: selectedAddress != null ? selectedAddress! : hintText,
            icon: Icons.location_on_outlined));
  }
}
