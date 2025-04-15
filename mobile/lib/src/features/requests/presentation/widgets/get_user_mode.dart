import 'package:eqshare_mobile/src/core/data/models/payload/payload.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';

UserMode updateProfileData(Payload payload) {
    switch (payload.aud) {
      case TokenService.driverAudience:
        return UserMode.driver;
      case TokenService.ownerAudience:
        return UserMode.owner;
      case TokenService.clientAudience:
        return UserMode.client;
      default:
        return UserMode.guest;
    }
  }