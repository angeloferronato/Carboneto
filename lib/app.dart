import 'package:carboneto/bindings/general_bindings.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/theme/theme.dart';
import 'package:country_picker/country_picker.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: GeneralBindings(),
      themeMode: ThemeMode.dark,
      darkTheme: CbAppTheme.darkTheme,
      supportedLocales: const [
        Locale('en'),
        Locale('pt'), // necessário para ativar a tradução em português
      ],
      localizationsDelegates: const [
        CountryLocalizations.delegate, // necessário para country_picker
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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