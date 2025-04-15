import 'package:eqshare_mobile/src/core/presentation/widgets/app_generic_dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';

class SingleSelectionSubCategoryDropDownButtonWithSearch
    extends StatelessWidget {
  final Future<List<SubCategory>>? future;
  final SubCategory? selectedItem;
  final void Function(SubCategory?) onChanged;
  const SingleSelectionSubCategoryDropDownButtonWithSearch(
      {super.key,
      required this.future,
      this.selectedItem,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SubCategory>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppGenericDropdownSearch<SubCategory>(
            enabled: false,
            items: const [],
            selectedItem: selectedItem,
            onChanged: (SubCategory? subCategory) {},
            itemAsString: (SubCategory category) => category.name ?? '',
            hintText: 'Выберите категорию...',
          );
        }
        final categories = snapshot.data ?? [];
        categories.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppGenericDropdownSearch<SubCategory>(
              enabled: !(snapshot.connectionState == ConnectionState.none ||
                  snapshot.hasError ||
                  categories.isEmpty),
              items: categories,
              selectedItem: selectedItem,
              onChanged: onChanged,
              itemAsString: (SubCategory category) => category.name ?? '',
              hintText: 'Выберите категорию...',
            ),
          ],
        );
      },
    );
  }
}
