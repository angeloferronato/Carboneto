import 'package:carboneto/bindings/general_bindings.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: GeneralBindings(),
      themeMode: ThemeMode.system,
      darkTheme: CbAppTheme.darkTheme,
      theme: CbAppTheme.lightTheme,
      debugShowCheckedModeBanner: true,
      home: const Scaffold(
        backgroundColor: CbColors.primary,
        body: Center(
          child: CircularProgressIndicator(color: CbColors.white,),
        ),
      ),
    ); 
  }
}