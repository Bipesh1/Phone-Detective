// Phone Detective - App Widget

import 'package:flutter/material.dart';
import 'utils/theme.dart';
import 'utils/routes.dart';

class PhoneDetectiveApp extends StatelessWidget {
  const PhoneDetectiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Detective',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
