// import 'package:flutter/material.dart';

// class AppNavigator extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final initialRoute = appNavigation.initialRoute(true);

//     return Navigator(
//       initialRoute: initialRoute,
//       onGenerateRoute: (settings) {
//         final routeName = settings.name;
//         final routeBuilder = appNavigation.routes[routeName];

//         if (routeBuilder != null) {
//           return MaterialPageRoute(
//             builder: (context) => routeBuilder(context),
//             settings: settings,
//           );
//         }

//         // Handle unknown routes here
//         return MaterialPageRoute(
//           builder: (context) => Scaffold(
//             appBar: AppBar(
//               title: Text('Error'),
//             ),
//             body: Center(
//               child: Text('Route not found'),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
