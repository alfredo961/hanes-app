import 'package:flutter/material.dart';
import 'package:hilaza/utils/constants.dart';
import 'package:hilaza/viewmodels/home_viewmodel.dart';
import 'package:provider/provider.dart';

import 'utils/app_theme.dart';
import 'views/teams_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hilaza',
      theme: AppTheme.theme,
      home: const TeamsScreen(),
    );
  }
}
