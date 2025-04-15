import 'package:eqshare_mobile/src/core/presentation/widgets/app_generic_dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:eqshare_mobile/src/core/data/models/brand/brand.dart';



class SingleSelectionBrandDropDownWithSearch extends StatelessWidget {
  final Future<List<Brand>>? future;
  final Brand? selectedItem;
  final void Function(Brand?) onChanged;
  const SingleSelectionBrandDropDownWithSearch(
      {super.key,
      required this.future,
      this.selectedItem,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Brand>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppGenericDropdownSearch<Brand>(
            enabled: false,
            items: const [],
            selectedItem: selectedItem,
            onChanged: (Brand? brand) {},
            itemAsString: (Brand brand) => brand.name ?? '',
            hintText: 'Выберите бренд...',
          );
        }
        final categories = snapshot.data ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppGenericDropdownSearch<Brand>(
              enabled: !snapshot.hasError,
              items: categories,
              selectedItem: selectedItem,
              onChanged: onChanged,
              itemAsString: ( brand) => brand.name ?? '',
              hintText: 'Выберите бренд...',
            ),
          ],
        );
      },
    );
  }
}
