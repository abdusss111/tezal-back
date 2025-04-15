import 'package:dropdown_search/dropdown_search.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppGenericDropdownSearch<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemAsString;
  final ValueChanged<List<T>?>? onChangedForMultiple;
  final String hintText;
  final Future<List<T>> Function(String)? asyncData;
  final bool isMultiple;
  final List<T> selectedItems;

  final String? emptyBuilderText;
  final bool enabled;

  const AppGenericDropdownSearch({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.itemAsString,
    required this.hintText,
    this.emptyBuilderText,
    required this.enabled,
    this.isMultiple = false,
    this.selectedItems = const [],
    this.onChangedForMultiple,
    this.asyncData,
  });

  @override
  Widget build(BuildContext context) {
    if (isMultiple) {
      return DropdownSearch<T>.multiSelection(
        items: items,
        selectedItems: selectedItems,
        onSaved: onChangedForMultiple,
        onChanged: onChangedForMultiple,
        dropdownDecoratorProps: dropDownDecorationProps(context),
        filterFn: (item, filter) {
          final itemStr =
              itemAsString(item).toLowerCase().replaceAll(RegExp(r'\s+'), '');
          final filterStr = filter.toLowerCase().replaceAll(RegExp(r'\s+'), '');
          return itemStr.contains(filterStr);
        },
        asyncItems: asyncData,
        dropdownBuilder: (context, items) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: items
                      .map((item) => Text(
                          ' ${(item as dynamic).name.toString()}${items.last == item ? '' : ','}',
                          style: Theme.of(context).textTheme.headlineSmall))
                      .toList()),
            ),
          );
        },
        popupProps: PopupPropsMultiSelection.modalBottomSheet(
          itemBuilder: (context, item, isInSelectedItems) {
            return Container(
              color: isInSelectedItems ? Colors.grey[200] : Colors.white,
              child: ListTile(
                title: Text(
                  itemAsString(item),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: isInSelectedItems ? Colors.red : Colors.black,
                      ),
                ),
              ),
            );
          },
          title: Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
            child: Row(
              children: [
                Text(
                  hintText,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.close_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    context.pop();
                  },
                ),
              ],
            ),
          ),
          modalBottomSheetProps: ModalBottomSheetProps(
            backgroundColor: Colors.white,
            isScrollControlled: true,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            elevation: 0,
          ),
          searchFieldProps: const TextFieldProps(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
              hintText: 'Поиск',
            ),
          ),
          emptyBuilder: (context, searchEntry) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(emptyBuilderText ?? 'Не удается найти'),
          ),
          showSearchBox: true,
          fit: FlexFit.tight,
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8 -
                  MediaQuery.of(context).viewInsets.bottom),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: DropdownSearch<T>(
        filterFn: (item, filter) {
          final itemStr =
              itemAsString(item).toLowerCase().replaceAll(RegExp(r'\s+'), '');
          final filterStr = filter.toLowerCase().replaceAll(RegExp(r'\s+'), '');
          return itemStr.contains(filterStr);
        },
        enabled: enabled,
        items: items,
        selectedItem: selectedItem,
        onChanged: onChanged,
        dropdownDecoratorProps: dropDownDecorationProps(context),
        popupProps: selectionPopupProps(context),
        itemAsString: itemAsString,
      ),
    );
  }

  PopupProps<T> selectionPopupProps(BuildContext context) {
    return PopupProps<T>.modalBottomSheet(
      title: Padding(
        padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
        child: Row(
          children: [
            Text(hintText, style: Theme.of(context).textTheme.headlineSmall),
            const Spacer(),
            IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.close_outlined,
                color: Colors.grey,
              ),
              onPressed: () {
                context.pop();
              },
            ),
          ],
        ),
      ),
      modalBottomSheetProps: ModalBottomSheetProps(
        backgroundColor: Colors.white,
        isScrollControlled: true,
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        elevation: 0,
      ),
      searchFieldProps: const TextFieldProps(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
          hintText: 'Поиск',
        ),
      ),
      emptyBuilder: (context, searchEntry) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(emptyBuilderText ?? 'Не удается найти'),
      ),
      showSearchBox: true,
      fit: FlexFit.tight,
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8 -
              MediaQuery.of(context).viewInsets.bottom),
    );
  }

  DropDownDecoratorProps dropDownDecorationProps(BuildContext context) {
    return DropDownDecoratorProps(
      baseStyle: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(fontWeight: FontWeight.normal),
      dropdownSearchDecoration: InputDecoration(
        fillColor: AppColors.appFormFieldFillColor,
        filled: true,
        hintText: selectedItem != null ? null : hintText,
        hintStyle: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.w400),
        contentPadding: const EdgeInsets.fromLTRB(14, 12, 0, 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.appDropdownBorderColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.appDropdownBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.appDropdownBorderColor),
        ),
      ),
    );
  }
}
