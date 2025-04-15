import 'package:flutter/foundation.dart';
import 'package:eqshare_mobile/app/app_change_notifier.dart';

import 'package:flutter/material.dart';
import '../../domain/use_cases/auth_use_case.dart';
import '../auth.dart';
import '../mixins/auth_controller_mixin.dart';

class LoginController extends ChangeNotifier
    with AuthControllerMixin
    implements PasswordController {
  final AuthUseCase _authUseCase;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final appChangeNotifier = AppChangeNotifier();

  final TextEditingController phoneController = TextEditingController();
  String? phoneNumber;

  @override
  final TextEditingController passwordController = TextEditingController();

  @override
  bool isShowPassword = false;
  @override
  bool isShowRepeatPassword = false;

  @override
  void setShowPassword(bool value) {
    isShowPassword = value;
    notifyListeners();
  }

  @override
  void setShowRepeatPassword(bool value) {
    isShowRepeatPassword = value;
    notifyListeners();
  }

  LoginController(this._authUseCase);

  void setPhoneNumber(String number) {
    phoneNumber = number;
    notifyListeners();
  }

  bool validatePhoneNumber() {
    if (phoneNumber == null || phoneNumber!.isEmpty) {
      return false;
    }
    return phoneNumber!.replaceAll(RegExp(r'\D'), '').length == 11;
  }

  Future<void> authenticate(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      final password = passwordController.text;
      final phone = '+7${phoneController.text.replaceAll(RegExp(r'\D'), '')}';
      FocusScope.of(context).requestFocus(FocusNode());

      try {
        await _authUseCase.authenticate(
          phone: phone,
          password: password,
          onSuccess: () async {
            navigateToHomeScreen(context);
          },
          onError: (message) {
            debugPrint('err');
            if (kDebugMode) {
              print(message);
            }
            appChangeNotifier.setErrorMessage(message);

            hideLoadingDialog(context);
            if (message == 'Ошибка сервера') hideLoadingDialog(context);
          },
          onLoading: () => showLoadingDialog(context),
          onComplete: () {},
          context: context,
        );
      } catch (e) {
        debugPrint('catch');

        if (!context.mounted) return;
        showErrorMessage(context, e.toString());
        hideLoadingDialog(context);
      }
      if (!context.mounted) return;
      FocusScope.of(context).unfocus();
    }
  }

  @override
  TextEditingController? get passwordRepeatController => null;
}
