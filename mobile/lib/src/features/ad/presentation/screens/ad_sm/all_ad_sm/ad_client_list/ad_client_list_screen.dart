import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_list_search_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ad_client_list_controller.dart';
import 'ad_client_list_widget.dart';

class AdClientListScreen extends StatelessWidget {
  final int? subCategoryId;
  final String? subCategoryName;
  final int? typeId;
  final String? typeName;
  final String? selectedServiceType;
  final bool showAdditionalAdWidget;

  const AdClientListScreen({
    super.key,
    required this.typeId,
    required this.typeName,
    required this.subCategoryId,
    required this.subCategoryName,
    required this.selectedServiceType,
    required this.showAdditionalAdWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const AdListSearchAppBar(),
          body: ChangeNotifierProvider.value(
            value: Provider.of<AdClientListController>(context, listen: false)
              ..setupAds(
                  serviceTypeEnum:
                      getServiceTypeEnumFromString(selectedServiceType)),
            child: AdClientListWidget(
                subCategoryId: subCategoryId,
                subCategoryName: subCategoryName,
                typeId: typeId,
                showAdditionalAdWidget: showAdditionalAdWidget,
                typeName: typeName,
                selectedServiceType: selectedServiceType),
          ),
        ),
      ],
    );
  }
}
