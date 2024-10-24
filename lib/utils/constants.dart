import 'package:flutter/material.dart';

class Consts{
  //URL Base
  static const String baseUrl = 'http://localhost:3001';
  static const String emulatorBaseUrl = 'http://10.0.2.2:3001';
  static const String localHostBaseUrl = 'http://192.168.1.25:3001';

  //Endpoints
  static const String getHilos = '/api/yarn/getYarnInventory';
  static const String getTeams = '/api/yarn/getTeams';
  static const String searchByCategory = '/api/yarn/filterYarnInventory?yarn_type';
  static const String printOrder = '/api/print/printOrder';
  static const String getOrderNumber = '/api/order/getOrderNumber';
  static const String getYarnByType = '/api/yarn/getYarnByType';

  //http service
  static const int timeoutSeconds = 30;

  //Colors
  static const Color rojo = Color(0xFFec2a25);
  static const Color rojoSecundario = Color(0xFFf47f7b);
  static const Color morado = Color(0xFF741773);
  static const Color moradoSecundario = Color(0xFFaf77ad);
  static const Color blanco = Color(0xFFffffff);
  static const Color backgroundWhite = Color(0xFFf7f7f7);
}