import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metadata_preservation/src/presentation/screens/home_screen.dart';
import 'package:metadata_preservation/src/utils/constants/strings.dart';
import '../config/themes/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: appTitle,
      theme: AppTheme.light,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
