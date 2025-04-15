import 'package:eqshare_mobile/src/core/presentation/widgets/page_wrapper.dart';
import 'package:flutter/material.dart';

import 'global_search_delegate.dart';

class GlobalSearchFieldWidget extends StatelessWidget {
  final String? searchText;
  const GlobalSearchFieldWidget({
    super.key,
    this.searchText,
  });

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: TextFormField(
          initialValue: searchText,
          readOnly: true,
          onTap: () async {
            await showSearch<String>(
              context: context,
              delegate: GlobalSearchDelegate(
                onSearchChanged: getRecentSearchesLike,
              ),
            );
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintText: 'Поиск по Mezet.online',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
      ),
    ));
  }
}
