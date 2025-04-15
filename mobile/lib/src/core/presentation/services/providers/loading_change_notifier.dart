import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';

mixin LoadingChangeNotifier on AppSafeChangeNotifier {
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
