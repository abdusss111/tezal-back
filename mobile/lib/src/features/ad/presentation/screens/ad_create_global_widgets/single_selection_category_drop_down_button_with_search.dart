import 'package:eqshare_mobile/src/core/presentation/widgets/app_generic_dropdown_search.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:flutter/material.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';


class SingleSelectionCategoryDropDownButtonWithSearch extends StatelessWidget {
  final Future<List<Category>>? future;
  final Category? selectedItem;
  final void Function(Category?) onChanged;
  const SingleSelectionCategoryDropDownButtonWithSearch(
      {super.key,
      required this.future,
      this.selectedItem,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppGenericDropdownSearch<Category>(
            enabled: false,
            items: const [],
            selectedItem: selectedItem,
            onChanged: (Category? subCategory) {},
            itemAsString: (Category category) => category.name ?? '',
            hintText: 'Выберите категорию...',
          );
        }
        final categories = snapshot.data ?? [];
        // categories.insert(0, Category(name: DefaultNames.allCategories.name,id: 0));
        categories.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppGenericDropdownSearch<Category>(
              enabled: !snapshot.hasError,
              items: categories,
              selectedItem: selectedItem,
              onChanged: onChanged,
              itemAsString: (category) => category.name ?? '',
              hintText: 'Выберите категорию...',
            ),
          ],
        );
      },
    );
  }
}
