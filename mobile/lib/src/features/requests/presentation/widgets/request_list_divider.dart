import 'package:eqshare_mobile/src/core/res/theme/app_colors.dart';
import 'package:flutter/material.dart';

class RequestListDivider extends StatelessWidget {
  const RequestListDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppColors.dividerListViewColor,
    );
  }
}
