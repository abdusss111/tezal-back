// import 'package:eqshare_mobile/src/core/res/theme/app_colors.dart';
// import 'package:flutter/material.dart';

// class AppSearchFieldWidget extends StatefulWidget {
//   final Function(String)? onSearch;

//   const AppSearchFieldWidget({
//     super.key,
//     required this.searchController,
//     this.onSearch,
//     required this.hintText,
//   });

//   final TextEditingController searchController;
//   final String hintText;

//   @override
//   State<AppSearchFieldWidget> createState() => _AppSearchFieldWidgetState();
// }

// class _AppSearchFieldWidgetState extends State<AppSearchFieldWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       onChanged: (value) {
//         widget.onSearch == null ? () {} : widget.onSearch!(value);
//         setState(() {});
//       },
//       controller: widget.searchController,
//       decoration: InputDecoration(
//         fillColor: AppColors.appFormFieldFillColor,
//         filled: true,
//         hintText: widget.hintText,
//         prefixIcon: const Icon(Icons.search),
//         suffixIcon: widget.searchController.text.isNotEmpty
//             ? IconButton(
//                 onPressed: () {
//                   widget.searchController.clear();
//                   if (widget.onSearch != null) {
//                     widget.onSearch!('');
//                   }
//                   setState(() {});
//                 },
//                 icon: const Icon(Icons.clear),
//               )
//             : null,
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(
//             color: Colors.transparent,
//           ),
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(
//             color: Colors.transparent,
//           ),
//         ),
//       ),
//     );
//   }
// }
