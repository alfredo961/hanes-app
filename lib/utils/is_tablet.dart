
import 'package:flutter/material.dart';

bool isTablet([BuildContext? context]) {
  var size =
      WidgetsBinding.instance.platformDispatcher.implicitView!.physicalSize;

  var pixelRatio =
      WidgetsBinding.instance.platformDispatcher.implicitView!.devicePixelRatio;
  var logicalSize = size / pixelRatio;
  var shortestSide = logicalSize.shortestSide;
  return shortestSide >= 600;
}