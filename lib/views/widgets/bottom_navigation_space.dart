import 'package:flutter/material.dart';

import '../../utils/has_navigation_bar.dart';

class BottomNavigationSpace extends StatelessWidget {
  const BottomNavigationSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: hasNavigationBar(context)
          ? MediaQuery.of(context).size.height * .07
          : MediaQuery.of(context).size.height * .025,
    );
  }
}
