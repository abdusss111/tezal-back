import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';




String getStatusText(String status) {
  switch (status) {
    case "CREATED": 
    return 'В ожидании подтверждение';
    case 'AWAITS_START':
      return 'В ожидании начала';
    case 'APPROVED':
      return 'В ожидании начала';
    case 'ON_ROAD':
      return 'В пути';
    case 'WORKING':
      return 'В работе';
    case 'PAUSE':
      return 'Приостановлен';
    case 'FINISHED':
      return 'Завершено';
    default:
      return 'Неизвестный статус';
  }
}



List<AdListRowData> getSortData(List<AdListRowData> data, {required SortAlgorithmEnum sortType}) {
  switch (sortType) {
    case SortAlgorithmEnum.ascCreatedAt:
      data.sort((a, b) {
        // Преобразуйте строки даты в DateTime объекты
        DateTime? dateA = a.createdAt != null
            ? DateTimeUtils().formatDateFromyyyyMMddTHHmmssSSSSSSSS(a.createdAt!)
            : null;
        DateTime? dateB = b.createdAt != null
            ? DateTimeUtils().formatDateFromyyyyMMddTHHmmssSSSSSSSS(b.createdAt!)
            : null;

        if (dateA != null && dateB != null) {
          return dateA.compareTo(dateB);
        } else if (dateA != null) {
          return -1; // Если dateA не null, он должен быть раньше
        } else if (dateB != null) {
          return 1; // Если dateB не null, он должен быть раньше
        } else {
          return 0; // Если оба null, не изменяем порядок
        }
      });
      break;

    case SortAlgorithmEnum.ascPrice:
      data.sort((a, b) {
        double? priceA = a.price;
        double? priceB = b.price;

        if (priceA != null && priceB != null) {
          return priceA.compareTo(priceB);
        } else if (priceA != null) {
          return -1; // Если priceA не null, он должен быть раньше
        } else if (priceB != null) {
          return 1; // Если priceB не null, он должен быть раньше
        } else {
          return 0; // Если оба null, не изменяем порядок
        }
      });
      break;

    case SortAlgorithmEnum.descPrice:
      data.sort((a, b) {
        double? priceA = a.price;
        double? priceB = b.price;

        if (priceA != null && priceB != null) {
          return priceB.compareTo(priceA); // Для убывающего порядка
        } else if (priceA != null) {
          return -1; // Если priceA не null, он должен быть раньше
        } else if (priceB != null) {
          return 1; // Если priceB не null, он должен быть раньше
        } else {
          return 0; // Если оба null, не изменяем порядок
        }
      });
      break;
    case SortAlgorithmEnum.descCreatedAt:
     data.sort((a, b) {
        // Преобразуйте строки даты в DateTime объекты
        DateTime? dateA = a.createdAt != null
            ? DateTimeUtils().formatDateFromyyyyMMddTHHmmssSSSSSSSS(a.createdAt!)
            : null;
        DateTime? dateB = b.createdAt != null
            ? DateTimeUtils().formatDateFromyyyyMMddTHHmmssSSSSSSSS(b.createdAt!)
            : null;

        if (dateA != null && dateB != null) {
          return dateB.compareTo(dateA);
        } else if (dateA != null) {
          return -1; // Если dateA не null, он должен быть раньше
        } else if (dateB != null) {
          return 1; // Если dateB не null, он должен быть раньше
        } else {
          return 0; // Если оба null, не изменяем порядок
        }
      });
      break;
  }

  return data;
}


