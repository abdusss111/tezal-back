import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import 'package:flutter/material.dart';

class SubscribeForAdsController extends AppSafeChangeNotifier {
  List<SubCategory> selectedSMSubCategory = [];
  List<SubCategory> selectedEQSubCategory = [];
  List<SubCategory> selectedCMSubCategory = [];
  List<SubCategory> selectedSVMSubCategory = [];



  void adForCm(SubCategory category) {
    selectedCMSubCategory.add(category);
    notifyListeners();
  }

  void adForSM(SubCategory category) {
    selectedSMSubCategory.add(category);
    notifyListeners();
  }

  void adForEQ(SubCategory category) {
    selectedEQSubCategory.add(category);
    notifyListeners();
  }

  void adForSVM(SubCategory category) {
    selectedSVMSubCategory.add(category);
    notifyListeners();
  }

  void adForCmList(List<SubCategory> category) {
    selectedCMSubCategory = (category);
    notifyListeners();
  }

  void adForSMList(List<SubCategory> category) {
    selectedSMSubCategory = (category);
    notifyListeners();
  }

  void adForEQList(List<SubCategory> category) {
    selectedEQSubCategory = (category);
    notifyListeners();
  }

  void adForSVMList(List<SubCategory> category) {
    selectedSVMSubCategory = (category);
    notifyListeners();
  }
}
