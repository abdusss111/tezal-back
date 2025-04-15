import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CheckUserNavigationService {
  // Проверка навигации пользователя
  bool checkUserNavigation(
      {required LatLng userPosition,
      required List<LatLng> polylineCoordinates,
      required LatLng nextRoutePoint,
      required double userHeading,
      required double thresholdDistance,
      required double thresholdDirection}) {
    // Проверка на отклонение от маршрута
    if (_checkIfOffRoute(
        userPosition, polylineCoordinates, thresholdDistance)) {
      return true; // Пользователь отклонился от маршрута
    }

    // Проверка на изменение направления
    // if (_checkIfDirectionChanged(
    //     userPosition, nextRoutePoint, userHeading, thresholdDirection)) {
    //   return true; // Направление изменилось
    // }

    // Можно добавить дополнительные проверки здесь, если это необходимо

    return false; // Пользователь на маршруте и направление не изменилось
  }

  double _getDistance(LatLng userPosition, LatLng routePoint) {
    // Функция для вычисления расстояния между двумя точками
    return Geolocator.distanceBetween(userPosition.latitude,
        userPosition.longitude, routePoint.latitude, routePoint.longitude);
  }

  bool _checkIfOffRoute(
      LatLng userPosition, List<LatLng> polylineCoordinates, double threshold) {
    if (polylineCoordinates.isEmpty) {
      return false;
    }
    for (var routePoint in polylineCoordinates) {
      double distance = _getDistance(userPosition, routePoint);
      if (distance <= threshold) {
        return false; // Пользователь на маршруте
      }
    }
    return true; // Пользователь отклонился от маршрута
  }

  bool _checkIfDirectionChanged(LatLng userPosition, LatLng nextRoutePoint,
      double userHeading, double threshold) {
    double routeHeading =
        getBearingBetweenCoordinates(userPosition, nextRoutePoint);
    final abs = (userHeading - routeHeading).abs();
    return abs > threshold; // Проверка на изменение направления
  }

  double getBearingBetweenCoordinates(LatLng start, LatLng end) {
    // Функция для вычисления угла (азимута) между двумя точками
    double lat1 = start.latitude * (pi / 180);
    double lon1 = start.longitude * (pi / 180);
    double lat2 = end.latitude * (pi / 180);
    double lon2 = end.longitude * (pi / 180);
    double dLon = lon2 - lon1;

    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    double bearing = atan2(y, x) * (180 / pi);
    return (bearing + 360) % 360;
  }
}
