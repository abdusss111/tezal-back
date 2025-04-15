import 'dart:developer';

import 'package:eqshare_mobile/src/features/auth/data/models/user_model/user_model.dart';
import 'package:flutter/material.dart';


import '../../../domain/use_cases/auth_use_case.dart';
import '../../auth.dart';
import '../../mixins/auth_controller_mixin.dart';

class RegisterPasswordController extends ChangeNotifier
    with AuthControllerMixin
    implements PasswordController {
  final AuthUseCase _authUseCase;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  final TextEditingController passwordController = TextEditingController();
  @override
  final TextEditingController passwordRepeatController =
      TextEditingController();

  @override
  bool isShowPassword = false;
  @override
  bool isShowRepeatPassword = false;

  RegisterPasswordController(this._authUseCase);

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

  Future<void> register(BuildContext context, User userAuthData) async {
    final password = passwordController.text;

    try {
      await _authUseCase.registerUser(
        userAuthData: userAuthData,
        password: password,
        context: context,
        onSuccess: () {
          navigateToHomeScreen(context);
        },
        onError: (error) {
          log(error.toString(), name: 'Error on register, after ::');
          showErrorMessage(context, error);
          hideLoadingDialog(context);
        },
        onLoading: () => showLoadingDialog(context),
        onComplete: () {},
      );
    } catch (e) {
      if (context.mounted) {
        log(e.toString(), name: 'Error on register, after ::');
        showErrorMessage(context, e.toString());
      }
      log(e.toString(), name: 'Error on register, after ::');
    }
  }

}
