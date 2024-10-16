import 'package:flutter/material.dart';

import 'constants.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      primaryColor: Consts.rojo,
      scaffoldBackgroundColor: Consts.backgroundWhite,
      colorScheme: const ColorScheme(
        primary: Consts.rojo,
        primaryContainer: Consts.rojoSecundario,
        secondary: Consts.morado,
        secondaryContainer: Consts.moradoSecundario,
        surface: Consts.blanco,
        error: Colors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black,
        onError: Colors.white,
        brightness: Brightness.light,
      ),
    );
  }
}
