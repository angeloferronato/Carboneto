import 'package:carboneto/features/authentication/screens/login/login.dart';
import 'package:carboneto/features/authentication/screens/onboarding/onboarding.dart';
import 'package:carboneto/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      darkTheme: CbAppTheme.darkTheme,
      theme: CbAppTheme.lightTheme,
      home: OnBoardingScreen(),
      debugShowCheckedModeBanner: false,
    ); 
  }
}