part of 'sm_list_map_bloc.dart';

abstract class SmListMapEvent {
  const SmListMapEvent();
}

class FetchInitialData extends SmListMapEvent {
  const FetchInitialData();
}

class FetchData extends SmListMapEvent {
  final ServiceTypeEnum serviceTypeEnum;
  final int? categoryId;
  final int? subCategoryId;
  final bool forceReload;
  // Новый параметр


  const FetchData(
      {required this.serviceTypeEnum, this.categoryId, this.subCategoryId,
      this.forceReload = false,

      });
}

class FetchDataWithMainCategory extends SmListMapEvent {
  final int? categoryId;
  final int? subCategoryID;

  const FetchDataWithMainCategory({this.categoryId,this.subCategoryID});
}


class FetchDataWithSearch extends SmListMapEvent{
  final String searchQuery;

  const FetchDataWithSearch({required this.searchQuery}); 
}