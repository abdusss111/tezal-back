import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';

class RequestItemClass {
  final String title;
  final AllServiceTypeEnum type;
  final int id;
  final double? priceForHour;
  final String? orderAmount;
  final String startLeaseDate;
  final String? endLeaseDate;
  final String? createDate;
  final String subcategory;
  final String status;
  final String address;
  final String? finishAddress;
  final int ownerID;
  final User? executorUser;



  final bool isRequestExecution;

  RequestItemClass(
      {this.priceForHour,
      this.finishAddress,
      this.orderAmount,
      this.endLeaseDate,
      this.createDate,
      this.executorUser,
      required this.ownerID,
      this.isRequestExecution = false,
      required this.title,
      required this.subcategory,
      required this.startLeaseDate,
      required this.type,
      required this.status,
      required this.id,
      required this.address});

  RequestItemClass copyWith({
    double? priceForHour,
    String? finishAddress,
    String? orderAmount,
    String? endLeaseDate,
    String? createDate,
    int? ownerID,
    bool? isRequestExecution,
    String? title,
    String? subcategory,
    String? startLeaseDate,
    AllServiceTypeEnum? type,
    String? status,
    int? id,
    String? address,
  }) {
    return RequestItemClass(
      priceForHour: priceForHour ?? this.priceForHour,
      finishAddress: finishAddress ?? this.finishAddress,
      orderAmount: orderAmount ?? this.orderAmount,
      endLeaseDate: endLeaseDate ?? this.endLeaseDate,
      createDate: createDate ?? this.createDate,
      ownerID: ownerID ?? this.ownerID,
      isRequestExecution: isRequestExecution ?? this.isRequestExecution,
      title: title ?? this.title,
      subcategory: subcategory ?? this.subcategory,
      startLeaseDate: startLeaseDate ?? this.startLeaseDate,
      type: type ?? this.type,
      status: status ?? this.status,
      id: id ?? this.id,
      address: address ?? this.address,
    );
  }
}
