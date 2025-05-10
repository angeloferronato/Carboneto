import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:carboneto/features/authentication/screens/login/login.dart';
import 'package:carboneto/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      darkTheme: CbAppTheme.darkTheme,
      theme: CbAppTheme.lightTheme,
      home: AnimatedSplashScreen(
        splash: 'assets/logos/CLogo.png',
        nextScreen: LoginScreen(),
        backgroundColor: Color(0xff0f4299),
        duration: 3000,
        splashIconSize: 250,
        // splashTransition: SplashTransition.rotationTransition,
        // pageTransitionType: PageTransitionType.scale,
      ),
    ); 
  }
}