import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRecentlyViewedAdsRepo {
  final SharedPreferences prefs;

  static String recentlyViewedKey = 'recently_viewed';

  UserRecentlyViewedAdsRepo({required this.prefs});

  Future<void> delete ()async{
   await prefs.remove(recentlyViewedKey);
  }

  Future<void> initRecentlyViewedAdList() async {
    if (!prefs.containsKey(recentlyViewedKey)) {
      await prefs.setStringList(recentlyViewedKey, []);
    }
  }

  Future<String> saveViewedAd(AllServiceTypeEnum allServiceTypeEnum,
      {required String id}) async {
    final values = prefs.getStringList(recentlyViewedKey) ?? [];

    final newAd = _viewedAdSaveType(allServiceTypeEnum, id);

    values.remove(newAd);

    values.insert(0, newAd);
    if (values.length > 20) {
      values.removeLast();
    }

    await _saveForPrefs(values);
    return newAd;
  }

  Future<void> _saveForPrefs(List<String>? value) async {
    if (value != null) {
      await prefs.setStringList(recentlyViewedKey, value);
    }
  }

  String _viewedAdSaveType(AllServiceTypeEnum allServiceTypeEnum, String id) {
    return '${allServiceTypeEnum.name}-$id';
  }

  List<String>? getData(){
    final data =  prefs.getStringList(recentlyViewedKey);
    return data;
  } 
}
