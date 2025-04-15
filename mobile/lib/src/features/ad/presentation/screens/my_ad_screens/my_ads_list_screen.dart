import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/app_ad_grid_view_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/app_ad_list_view_widget.dart';
import 'package:flutter/material.dart';

class MyAdClientListView extends StatefulWidget {
  final List<AdListRowData> ads;
  final Future<void> Function(String, bool) onAdTapped;
  final Function()? onTapCreate;
  final String? addButtonText;

  const MyAdClientListView(
      {super.key,
      required this.ads,
      required this.onAdTapped,
      this.addButtonText,
      this.onTapCreate});

  @override
  State<MyAdClientListView> createState() => _AdClientListViewState();
}

class _AdClientListViewState extends State<MyAdClientListView> {
  bool isGridView = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(top: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(isGridView ? Icons.grid_view : Icons.list),
                  onPressed: () {
                    setState(() {
                      isGridView = !isGridView;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8,),
            Expanded(
              child: isGridView
                  ? AppAdGridViewWidget(
                    isContentEmpty: widget.ads.isEmpty,
                      onAdTap: (id) async {
                        await widget.onAdTapped(
                          widget.ads[id].id.toString(),
                          widget.ads[id].isClientType ?? false,
                        );
                      },
                      adList: widget.ads,
                  )
                  : AppAdListViewWidget(
                      isContentEmpty: widget.ads.isEmpty,
                      widgetImageBoxFit: BoxFit.fill,
                      itemExtent: null,
                      onAdTap: (id) async {
                        await widget.onAdTapped(
                          widget.ads[id].id.toString(),
                          widget.ads[id].isClientType ?? false,
                        );
                      },
                      adList: widget.ads,
                    ),
            ),
            if (widget.onTapCreate != null && widget.addButtonText != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: AppPrimaryButtonWidget(
                  textColor: Colors.white,
                  onPressed: () {
                    widget.onTapCreate!();
                  },
                  text: widget.addButtonText!,
                  icon: Icons.add_circle_outline_outlined,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
