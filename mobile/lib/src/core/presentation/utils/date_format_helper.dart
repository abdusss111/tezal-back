import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeUtils {
  static Future<DateTime?> showAppDatePicker(BuildContext context) async {
    return await showDatePicker(
      locale: const Locale('ru'),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );
  }

  static Future<TimeOfDay?> showAppTimePicker(BuildContext context) async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }

  static String formatDateTime(DateTime? dateTime) {
    if (dateTime != null) {
      return DateFormat('HH:mm, dd.MM.yyyy', 'ru_RU').format(dateTime);
    } else {
      return 'Дата и время не указаны';
    }
  }

  static String formatDateTimeFromYYYYmmDD(DateTime? dateTime) {
    DateFormat dateFormat = DateFormat('d MMMM', 'ru_RU'); // "4 августа"
    DateFormat timeFormat = DateFormat('HH:mm', 'ru_RU'); // "14:13"

    log(dateTime.toString(), name: 'DateTime : ');

    // Объединение в нужный формат
    if (dateTime != null) {
      String formattedDate = dateFormat.format(dateTime); // "4 августа"
      String formattedTime = timeFormat.format(dateTime); // "14:13"
      String result = '$formattedDate, $formattedTime';
      log(result.toString(), name: 'result `: ');
      return result;
    } else {
      return 'Дата и время не указаны';
    }
  }

  static String formatDateTimeLabel(DateTime dateTime, TimeOfDay timeOfDay) {
    final dayNames = ['Пон', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    final monthNames = [
      'Янв',
      'Фев',
      'Мар',
      'Апр',
      'Май',
      'Июн',
      'Июл',
      'Авг',
      'Сен',
      'Окт',
      'Ноя',
      'Дек'
    ];

    final dayOfWeek = dayNames[dateTime.weekday - 1];
    final month = monthNames[dateTime.month - 1];
    final day = dateTime.day;
    final year = dateTime.year;
    final hours = timeOfDay.hour.toString().padLeft(2, '0');
    final minutes = timeOfDay.minute.toString().padLeft(2, '0');

    return '$dayOfWeek, $day $month, $year в $hours:$minutes';
  }

  static String formatDateLabel(DateTime? dateTime) {
    if (dateTime != null) {
      // final dayNames = ['Пон', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
      final monthNames = [
        'Янв',
        'Фев',
        'Мар',
        'Апр',
        'Май',
        'Июн',
        'Июл',
        'Авг',
        'Сен',
        'Окт',
        'Ноя',
        'Дек'
      ];

      // final dayOfWeek = dayNames[dateTime.weekday - 1];
      final month = monthNames[dateTime.month - 1];
      final day = dateTime.day;
      final year = dateTime.year;
      final hours = dateTime.hour.toString().padLeft(2, '0');
      final minutes = dateTime.minute.toString().padLeft(2, '0');

      return '$hours:$minutes, $day $month, $year';
    } else {
      return 'Дата и время не указаны';
    }
  }

  static String formatDate(String? dateTimeString) {
    if (dateTimeString == null) return '';
    final dateTime = DateTime.tryParse(dateTimeString);
    return dateTime != null ? DateFormat('dd MMM', 'ru').format(dateTime) : '';
  }

  static String formatTime(String? dateTimeString) {
    if (dateTimeString == null) return '';
    final dateTime = DateTime.tryParse(dateTimeString);
    return dateTime != null ? DateFormat('HH:mm', 'ru').format(dateTime) : '';
  }

  static String formatDatetime(String? dateTimeString) {
    if (dateTimeString == null) return '';
    final dateTime = DateTime.tryParse(dateTimeString);
    return dateTime != null
        ? DateFormat('dd MMM HH:mm', 'ru').format(dateTime)
        : '';
  }

  static String formatDatetime2(DateTime? d) {
    if (d == null) return '';
    return DateFormat('dd MMM HH:mm', 'ru').format(d);
  }

  static String fromStringFormatDateYYMMDD(String dateString) {
    DateFormat inputFormat = DateFormat('yyyy-MM-dd');
    DateFormat outputFormat = DateFormat(DateFormat.ABBR_MONTH_DAY, 'ru');
    DateTime dateTime = inputFormat.parse(dateString.substring(0, 10));
    return outputFormat.format(dateTime);
  }

  static String formatDurationFromNanoSeconds(int nanoseconds) {
    int days = nanoseconds ~/ (1000000000 * 60 * 60 * 24);
    String dayPart = days > 0 ? '$daysд ' : '';
    int hours = (nanoseconds ~/ (1000000000 * 60 * 60)) % 24;
    String hourPart = hours > 0 ? '$hoursч ' : '';
    int minutes = (nanoseconds ~/ (1000000000 * 60)) % 60;
    String minutePart = minutes > 0 ? '$minutesм ' : '';
    // int seconds = (nanoseconds ~/ 1000000000) % 60;
    // String secondPart = seconds > 0 ? '$secondsс' : '';

    return '$dayPart$hourPart$minutePart'.trim();
  }

  static String formatDurationFromMilliSeconds(int milliseconds) {
    int days = milliseconds ~/ (10000 * 60 * 60 * 24);
    String dayPart = days > 0 ? '$daysд ' : '';
    int hours = (milliseconds ~/ (10000 * 60 * 60)) % 24;
    String hourPart = hours > 0 ? '$hoursч ' : '';
    int minutes = (milliseconds ~/ (10000 * 60)) % 60;
    String minutePart = minutes > 0 ? '$minutesм ' : '';
    // int seconds = (nanoseconds ~/ 10000000ф00) % 60;
    // String secondPart = seconds > 0 ? '$secondsс' : '';

    return '$dayPart$hourPart$minutePart'.trim();
  }

  DateTime? formatDateFromyyyyMMddTHHmmssSSSSSSSS(String? dateString) {
    if (dateString == null) {
      return null;
    }
    if (dateString.isEmpty) {
      log(dateString.toString(), name: 'dateString is empty  ');
      log(dateString.toString(), name: 'dateString is empty  ');

      return null;
    }
    if (dateString.contains('null')) {
      return null;
    }
    try {
      // Удалите 'Z' в конце, если она есть, и обработайте оставшуюся строку
      String cleanedDateString = dateString.replaceAll('Z', '');

      // Разберем дату до миллисекунд
      DateTime dateTime =
          DateFormat("yyyy-MM-ddThh:mm").parse(cleanedDateString, true);

      log(dateTime.toString(),
          name:
              'DateTime   DateFormat("yyyy-MM-ddThh:mm").parse(cleanedDateString, true);: ');
      return dateTime;
    } catch (e) {
      log('Error parsing date: $e');
      String cleanedDateString = dateString.replaceAll('Z', '');

      DateTime dateTime =
          DateFormat("yyyy-MM-dd hh:mm").parse(cleanedDateString, true);

      return dateTime;
    }
  }

  String dateFormatWithyyyyMMddTHHmmssSSSSSSSSS(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS'Z'").format(dateTime);
  }

  String dateFormatWithyyyyMMddTHHmmssSSSSSSSSSWithoutZ(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS'").format(dateTime);
  }

  String calculateHoursDifference(DateTime firstDate, DateTime secondDate) {
    final difference = firstDate.difference(secondDate).abs();
    final hours = difference.inHours;
    return '$hours';
  }

  String dateFormatForUpdate(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS").format(dateTime);
  }
}
