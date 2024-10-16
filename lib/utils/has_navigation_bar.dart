import 'dart:io';

import 'package:flutter/material.dart';

bool hasNavigationBar(BuildContext context) {
  double bottomPadding = MediaQuery.of(context).padding.bottom;

  if (Platform.isIOS) {
    return bottomPadding > 34;
  } else if (Platform.isAndroid) {
    return bottomPadding > 24;
  } else {
    return bottomPadding > 0;
  }
}