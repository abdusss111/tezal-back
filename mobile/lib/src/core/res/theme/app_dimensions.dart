import 'dart:io';

import 'package:flutter/material.dart';

class AppDimensions {
  static const double defaultPadding = 8.0;
  static const EdgeInsetsGeometry footerActionButtonsPadding =
      EdgeInsets.symmetric(
    horizontal: 10.0,
    vertical: 16.0,
  );
  static const EdgeInsetsGeometry requestExecutionContainerPadding =
      EdgeInsets.only(top: 0, left: 0, right: 0);
  static const EdgeInsetsGeometry appPrimaryInputPadding =
      EdgeInsets.fromLTRB(14, 10, 14, 10);
  static const double requestExecutionContainerHeight = 170;
  static const double footerActionButtonsSeparatorWidth = 10;

  static EdgeInsetsGeometry callButtonPadding =
      Platform.isIOS ? callButtonPaddingForIOS : callButtonPaddingForAndroid;
  static const EdgeInsetsGeometry callButtonPaddingForAndroid =
      EdgeInsets.only(bottom: 25, left: 10, right: 16, top: 10);
  static const EdgeInsetsGeometry callButtonPaddingForIOS =
      EdgeInsets.only(bottom: 35, left: 10, right: 16, top: 10);
}
