import 'package:eqshare_mobile/src/core/presentation/widgets/app_menu_row_widget.dart';
import 'package:flutter/material.dart';

class AppDetailLocationRow extends StatelessWidget {
  const AppDetailLocationRow(this.addressText, {super.key});

  final String? addressText;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: AppMenuRowWidget(
          onTap: () => () {},
          textStyle: Theme.of(context).textTheme.bodyMedium,
          menuRowData: AppMenuRowData(
              text: addressText ?? 'Адрес', icon: Icons.location_on_outlined),
        ));
  }
}
