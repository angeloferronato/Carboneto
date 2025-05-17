import 'package:carboneto/features/authentication/screens/welcome/widgets/welcome_presentation.dart';
import 'package:carboneto/features/authentication/screens/welcome/widgets/welcome_section.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            WelcomeSection(),
          
            WelcomePresentation(),
          ],
        ),
      ),
    );
  }
}




