import 'package:flutter/material.dart';

class TabWithTotal extends StatelessWidget {
  final String label;
  final int? total;
  const TabWithTotal({
    super.key,
    required this.label,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    String totalText;
    if (total == null || total == 0) {
      totalText = '';
    } else {
      totalText = total.toString();
    }
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              '$label  ',
              textAlign: TextAlign.center,
            ),
          ),
          totalText.isNotEmpty
              ? Center(
                  child: Container(
                    width: 18, 
                    height: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Center(
                      child:
                          // Container(
                          //   width: 5,
                          //   height: 10,
                          //   decoration: BoxDecoration(
                          //     color: Colors.orange,
                          //     borderRadius: BorderRadius.circular(50)
                          //   ),
                          // )
                          Text(
                        totalText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
