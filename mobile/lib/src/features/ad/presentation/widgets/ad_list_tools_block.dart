import 'package:eqshare_mobile/src/core/res/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';

class AdListToolsBlock extends StatefulWidget {
  final String title;
  final String totalLabel;
  final Function() onFilterTap;
  final Function() onSortTap;
  final Function() onViewTap;
  final int total;
  final bool isBlockType;
  final SortAlgorithmEnum? sortAlgorithm; // <-- Сделали необязательным

  const AdListToolsBlock({
    super.key,
    required this.title,
    required this.total,
    required this.totalLabel,
    required this.onFilterTap,
    required this.onSortTap,
    required this.onViewTap,
    required this.isBlockType,
    this.sortAlgorithm, // <-- Теперь можно передавать null
  });

  @override
  State<AdListToolsBlock> createState() => _AdListToolsBlockState();
}

class _AdListToolsBlockState extends State<AdListToolsBlock> {
  late bool _isGridView;

  @override
  void initState() {
    super.initState();
    _isGridView = widget.isBlockType;
  }

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
    widget.onViewTap();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            offset: Offset(-1, -1),
            blurRadius: 5,
            color: Color.fromRGBO(0, 0, 0, 0.04),
          ),
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 5,
            color: Color.fromRGBO(0, 0, 0, 0.04),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          '${widget.total} ${widget.totalLabel}',
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            VerticalDivider(
              width: 0,
              thickness: 0.5,
              color: Colors.grey.shade200,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: GestureDetector(
                onTap: widget.onSortTap,
                child: Icon(
                  widget.sortAlgorithm == SortAlgorithmEnum.ascPrice ||
                      widget.sortAlgorithm == SortAlgorithmEnum.ascCreatedAt
                      ? CupertinoIcons.sort_up // Стрелка вверх
                      : CupertinoIcons.sort_down, // Стрелка вниз
                  size: 28.0,
                  color: AppColors.appOwnerPrimaryColor,
                ),
              ),
            ),
            VerticalDivider(
              width: 0,
              thickness: 0.5,
              color: Colors.grey.shade200,
            ),
            GestureDetector(
              onTap: widget.onFilterTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: const Icon(
                  CupertinoIcons.slider_horizontal_3,
                  size: 28.0,
                  color: AppColors.appOwnerPrimaryColor,
                ),
              ),
            ),
            VerticalDivider(
              width: 0,
              thickness: 0.5,
              color: Colors.grey.shade200,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: GestureDetector(
                onTap: _toggleView,
                child: Icon(
                  _isGridView ? Icons.list : Icons.grid_on_rounded,
                  size: 28.0,
                  color: AppColors.appOwnerPrimaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
