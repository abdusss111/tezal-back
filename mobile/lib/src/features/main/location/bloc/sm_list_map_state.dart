part of 'sm_list_map_bloc.dart';

enum PageStatus { initial, loading, success, failure, loadingMap }

class SmListMapState extends Equatable {
  final PageStatus pageStatus;
  final List<Category> categories;
  final List<SubCategory> subCategories;
  final int idPickedMainCategory;
  final int idPickedSubCategory;
  final ServiceTypeEnum pickedServiceType;

  const SmListMapState(
      {this.pageStatus = PageStatus.initial,
      this.categories = const [],
      this.subCategories = const [],
      this.idPickedMainCategory = 0,
      this.idPickedSubCategory = 0,
      this.pickedServiceType = ServiceTypeEnum.MACHINARY});

  SmListMapState copyWith(
      {PageStatus? pageStatus,
      List<Category>? categories,
      List<SubCategory>? subCategories,
      ServiceTypeEnum? pickedServiceType,
      int? idPickedMainCategory,
      int? idPickedSubCategory}) {
    return SmListMapState(
        pageStatus: pageStatus ?? this.pageStatus,
        categories: categories ?? this.categories,
        subCategories: subCategories ?? this.subCategories,
        idPickedMainCategory: idPickedMainCategory ?? this.idPickedMainCategory,
        idPickedSubCategory: idPickedSubCategory ?? this.idPickedSubCategory,
        pickedServiceType: pickedServiceType ?? this.pickedServiceType);
  }

  @override
  List<Object?> get props => [
        pageStatus,
        categories,
        subCategories,
        idPickedMainCategory,
        idPickedSubCategory,
      ];
}

class SMADMapListState extends SmListMapState {
  final List<AdSpecializedMachinery> adSpecializedMachinery;

  const SMADMapListState({
    super.pageStatus,
    super.categories,
    super.subCategories,
    super.idPickedMainCategory,
    super.idPickedSubCategory,
    super.pickedServiceType,
    required this.adSpecializedMachinery,
  });

  @override
  SMADMapListState copyWith(
      {PageStatus? pageStatus,
      List<Category>? categories,
      List<SubCategory>? subCategories,
      List<AdSpecializedMachinery>? adSpecializedMachinery,
      ServiceTypeEnum? pickedServiceType,
      int? idPickedMainCategory,
      int? idPickedSubCategory}) {
    return SMADMapListState(
        pageStatus: pageStatus ?? this.pageStatus,
        categories: categories ?? this.categories,
        subCategories: subCategories ?? this.subCategories,
        idPickedMainCategory: idPickedMainCategory ?? this.idPickedMainCategory,
        idPickedSubCategory: idPickedSubCategory ?? this.idPickedSubCategory,
        adSpecializedMachinery:
            adSpecializedMachinery ?? this.adSpecializedMachinery,
        pickedServiceType: pickedServiceType ?? this.pickedServiceType);
  }

  @override
  List<Object?> get props => [
        pageStatus,
        categories,
        subCategories,
        idPickedMainCategory,
        idPickedSubCategory,
        adSpecializedMachinery
      ];
}

class EQADMapListState extends SmListMapState {
  final List<AdEquipment> equipments;

  const EQADMapListState(
      {super.pageStatus,
      super.categories,
      super.subCategories,
      super.idPickedMainCategory,
      super.pickedServiceType,
      super.idPickedSubCategory,
      required this.equipments});

  @override
  EQADMapListState copyWith(
      {PageStatus? pageStatus,
      List<Category>? categories,
      List<SubCategory>? subCategories,
      List<AdEquipment>? equipments,
      ServiceTypeEnum? pickedServiceType,
      int? idPickedMainCategory,
      int? idPickedSubCategory}) {
    return EQADMapListState(
        pageStatus: pageStatus ?? this.pageStatus,
        categories: categories ?? this.categories,
        subCategories: subCategories ?? this.subCategories,
        idPickedMainCategory: idPickedMainCategory ?? this.idPickedMainCategory,
        idPickedSubCategory: idPickedSubCategory ?? this.idPickedSubCategory,
        equipments: equipments ?? this.equipments,
        pickedServiceType: pickedServiceType ?? this.pickedServiceType);
  }

  @override
  List<Object?> get props => [
        pageStatus,
        categories,
        subCategories,
        idPickedMainCategory,
        idPickedSubCategory,
        equipments
      ];
}

class CMADMapListState extends SmListMapState {
  final List<AdConstrutionModel> adContructions;

  const CMADMapListState(
      {super.pageStatus,
      super.categories,
      super.pickedServiceType,
      super.subCategories,
      super.idPickedMainCategory,
      super.idPickedSubCategory,
      required this.adContructions});

  @override
  CMADMapListState copyWith(
      {PageStatus? pageStatus,
      List<Category>? categories,
      List<SubCategory>? subCategories,
      List<AdConstrutionModel>? adContructions,
      ServiceTypeEnum? pickedServiceType,
      int? idPickedMainCategory,
      int? idPickedSubCategory}) {
    return CMADMapListState(
      pageStatus: pageStatus ?? this.pageStatus,
      categories: categories ?? this.categories,
      subCategories: subCategories ?? this.subCategories,
      idPickedMainCategory: idPickedMainCategory ?? this.idPickedMainCategory,
      idPickedSubCategory: idPickedSubCategory ?? this.idPickedSubCategory,
      adContructions: adContructions ?? this.adContructions,
    );
  }

  @override
  List<Object?> get props => [
        pageStatus,
        categories,
        subCategories,
        idPickedMainCategory,
        idPickedSubCategory,
        adContructions
      ];
}

class SVMADMapListState extends SmListMapState {
  final List<AdServiceModel> adServices;

  const SVMADMapListState(
      {super.pageStatus,
      super.categories,
      super.pickedServiceType,
      super.subCategories,
      super.idPickedMainCategory,
      super.idPickedSubCategory,
      required this.adServices});
  @override
  SVMADMapListState copyWith(
      {PageStatus? pageStatus,
      List<Category>? categories,
      List<SubCategory>? subCategories,
      List<AdServiceModel>? adServices,
      ServiceTypeEnum? pickedServiceType,
      int? idPickedMainCategory,
      int? idPickedSubCategory}) {
    return SVMADMapListState(
      pageStatus: pageStatus ?? this.pageStatus,
      categories: categories ?? this.categories,
      subCategories: subCategories ?? this.subCategories,
      idPickedMainCategory: idPickedMainCategory ?? this.idPickedMainCategory,
      idPickedSubCategory: idPickedSubCategory ?? this.idPickedSubCategory,
      adServices: adServices ?? this.adServices,
    );
  }

  @override
  List<Object?> get props => [
        pageStatus,
        categories,
        subCategories,
        idPickedMainCategory,
        idPickedSubCategory,
        adServices
      ];
}
