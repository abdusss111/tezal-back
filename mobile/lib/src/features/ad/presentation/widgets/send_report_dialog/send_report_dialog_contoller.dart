import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:flutter/material.dart';

class SendReportDialogContoller extends AppSafeChangeNotifier{
  int? pickedReportId = 0;

  void setReportID(int? value){
    pickedReportId = value;
    notifyListeners();
  }
}