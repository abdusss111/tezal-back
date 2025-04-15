import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/features/global_search/widgets/global_search_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdListSearchAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const AdListSearchAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: () {
          // Navigator.pop(context);
          context.pop();
        },
      ),
      title: const Row(
        children: [
          Expanded(child: GlobalSearchFieldWidget()),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            Navigator.of(context).popUntil(
              ModalRoute.withName(AppRouteNames.navigation),
            );
          },
        )
      ],
    );
  }
}
