import 'dart:developer';

import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:eqshare_mobile/src/core/data/services/network/api_client/user_profile_api_client.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/presentation/services/providers/loading_change_notifier.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_client_model.dart/ad_construction_client_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_model/ad_constrution_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_client_model/ad_equipment_client.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_model/ad_equipment.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_client_model/ad_service_client_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_model/ad_service_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_client_model/ad_client.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_model/ad_specialized_machinery.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_api_client.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_construction_materials_repository.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_service_repository.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';

class UserScreenController extends AppSafeChangeNotifier
    with LoadingChangeNotifier {
  Set<AllServiceTypeEnum> uniqueServiceTypes = {};

  final String userID;

  User? user;
  List<AdListRowData> _userSm = [];
  List<AdListRowData> get userSm => _userSm;

  final userRepo = UserProfileApiClient();
  final adApiClient = AdApiClient();
  final adCMRepo = AdConstructionMaterialsRepository();

  final adSVMRepo = AdServiceRepository();

  UserScreenController({required this.userID}) {
    init();
  }

  void init() async {
    await loadUser();
    await loadUserData();
  }

  Future<void> loadUser() async {
    user = await userRepo.getUserDetail(userID);
    log(user.toString(), name: 'user: ');
  }

  Future<void> loadUserData() async {
    final payload = await getPayload();

    final isClient = payload == null || payload.aud == 'CLIENT';
    if (isClient) {
      await loadUserSm();
      await loadEq();
      await loadCm();
      await loadSvm();
    } else {
      await loadSmClient();
      await loadEqClient();
      await loadCMClient();
      await loadSvmClient();
    }

    for (var element in _userSm) {
      if (element.allServiceTypeEnum != null) {
        uniqueServiceTypes.add(element.allServiceTypeEnum!);
      }
    }
    setLoading(false);
    notifyListeners();
  }

  Future<void> loadUserSm() async {
    final sm = await adApiClient.getAdSMList(userID: userID) ?? [];

    _userSm = sm
        .map((e) => AdSpecializedMachinery.getAdListRowDataFromSM(e))
        .toList();
  }

  Future<void> loadSmClient() async {
    final data = await adApiClient.getAdClientList(id: userID) ?? [];

    _userSm.addAll(data.map((e) => AdClient.getAdListRowDataFromSM(e)));
  }

  Future<void> loadEq() async {
    final data = await adApiClient.getAdEquipmentList(userId: userID) ?? [];

    _userSm.addAll(data.map((e) => AdEquipment.getAdListRowDataFromSM(e)));
  }

  Future<void> loadEqClient() async {
    final data =
        await adApiClient.getAdEquipmentClientListWith(id: userID) ?? [];

    _userSm
        .addAll(data.map((e) => AdEquipmentClient.getAdListRowDataFromSM(e)));
  }

  Future<void> loadCm() async {
    final data =
        await adCMRepo.getAdConstructionMaterialListForClient(userId: userID) ??
            [];

    _userSm
        .addAll(data.map((e) => AdConstrutionModel.getAdListRowDataFromSM(e)));
  }

  Future<void> loadCMClient() async {
    final data = await adCMRepo.getAdConstructionMaterialListForDriverOrOwner(
            userID: userID) ??
        [];
    _userSm.addAll(
        data.map((e) => AdConstructionClientModel.getAdListRowDataFromSM(e)));
  }

  Future<void> loadSvm() async {
    final data =
        await adSVMRepo.getAdServiceListForClient(userID: userID) ?? [];
    _userSm.addAll(data.map((e) => AdServiceModel.getAdListRowDataFromSM(e)));
  }

  Future<void> loadSvmClient() async {
    final data =
        await adSVMRepo.getAdServiceListForDriverOrOwner(userID: userID) ?? [];
    _userSm.addAll(
        data.map((e) => AdServiceClientModel.getAdListRowDataFromSM(e)));
  }
}
