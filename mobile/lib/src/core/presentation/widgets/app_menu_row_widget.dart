import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppMenuRowData {
  final IconData? icon;
  final String? iconSvgAsset;
  final int? count;
  final String text;

  const AppMenuRowData({
    required this.text,
    this.iconSvgAsset,
    this.icon,
    this.count,
  });
}

class AppMenuRowWidget extends StatelessWidget {
  final AppMenuRowData menuRowData;
  final VoidCallback onTap;
  final TextStyle? textStyle;

  const AppMenuRowWidget({
    super.key,
    required this.menuRowData,
    required this.onTap,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 6,
            vertical: AppChangeNotifier().userMode == UserMode.client ? 6 : 2),
        child: Column(
          children: [
            Row(
              children: [
                menuRowData.icon != null
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width * 0.085,
                        height: MediaQuery.of(context).size.height * 0.048,
                        child: Icon(
                          menuRowData.icon,
                          size: 32,
                        ),
                      )
                    : const SizedBox(),
                menuRowData.iconSvgAsset != null
                    ? SvgPicture.asset(
                        menuRowData.iconSvgAsset ?? '',
                      )
                    : const SizedBox(),
                const SizedBox(width: 18),
                Expanded(
                  child: Text(menuRowData.text,
                      style:
                          textStyle ?? Theme.of(context).textTheme.titleLarge),
                ),
                if (menuRowData.count != null) Text('${menuRowData.count}'),
                const Icon(
                  Icons.chevron_right_rounded,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
