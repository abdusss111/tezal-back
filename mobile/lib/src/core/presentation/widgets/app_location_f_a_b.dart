import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/features/main/location/bloc/sm_list_map_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppLocationFAB extends StatelessWidget {
  final String? heroTag;

  const AppLocationFAB({super.key, this.heroTag});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SmListMapBloc, SmListMapState>(
      builder: (context, state) {
        // Проверяем, готово ли состояние для перехода на карту
        final isButtonEnabled = state.categories.isNotEmpty || state is SMADMapListState ||
            state is EQADMapListState ||
            state is CMADMapListState ||
            state is SVMADMapListState;

        return FloatingActionButton.extended(
          heroTag: heroTag,
          elevation: 8.0,
          foregroundColor: Colors.white,
          onPressed: isButtonEnabled
              ? () {
                  context.pushNamed(AppRouteNames.adSMMapList);
                }
              : null, // Кнопка отключена, если данные еще загружаются
          label: const Text('На карте'),
          icon: const Icon(Icons.location_on_outlined),
          backgroundColor: isButtonEnabled
              ? Theme.of(context)
                  .colorScheme
                  .secondary // Дефолтный оранжевый цвет
              : Colors.grey, // Цвет для отключенного состояния
        );
      },
    );
  }
}

// OLD LOGIC

// import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
// import 'package:eqshare_mobile/src/features/main/location/bloc/sm_list_map_bloc.dart';
// import 'package:eqshare_mobile/src/features/main/location/google_map/google_map_screen_controller.dart';
// import 'package:eqshare_mobile/src/features/main/location/google_map/sample_map.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

// class AppLocationFAB extends StatelessWidget {
//   final String? heroTag;

//   const AppLocationFAB({super.key, this.heroTag});

//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton.extended(
//       heroTag: heroTag,
//       elevation: 8.0,
//       foregroundColor: Colors.white,
//       onPressed: () {
//         context.pushNamed(AppRouteNames.adSMMapList);

//         // final blocValue = BlocProvider.of<SmListMapBloc>(context);

//         // Navigator.push(
//         //   context,
//         //   PageRouteBuilder(
//         //     pageBuilder: (context, animation, secondaryAnimation) =>
//         //         BlocProvider.value(
//         //       value: blocValue,
//         //       child: Builder(
//         //         builder: (context) {
//         //           // Проверяем тип состояния
//         //           if (blocValue.state is! SMADMapListState) {
//         //             return Center(
//         //                 child:
//         //                     CircularProgressIndicator()); // Показываем индикатор загрузки
//         //           }

//         //           // Получаем данные из состояния
//         //           final adSpecializedMachinery =
//         //               (blocValue.state as SMADMapListState)
//         //                   .adSpecializedMachinery;

//         //           return ChangeNotifierProvider(
//         //             create: (context) => GoogleMapScreenController(
//         //               data: adSpecializedMachinery,
//         //             ),
//         //             child: GoogleMapClustering(),
//         //           );
//         //         },
//         //       ),
//         //     ),
//         //     transitionDuration: Duration.zero, // Отключаем анимацию
//         //     reverseTransitionDuration:
//         //         Duration.zero, // Отключаем обратную анимацию
//         //   ),
//         // );

//         // Navigator.pushNamed(context, AppRouteNames.adSMMapList);
//       },
//       label: const Text('На карте'),
//       icon: const Icon(Icons.location_on_outlined),
//     );
//   }
// }
