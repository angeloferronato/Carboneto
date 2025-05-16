import 'package:carboneto/common/widgets/login/login_header.dart';
import 'package:carboneto/common/widgets/welcome/welcome_circle_user.dart';
import 'package:carboneto/common/widgets/welcome/welcome_orbit_circle.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 600,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: CbSizes.appBarHeight),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: -22.5,
                    child: WelcomeCircleUser(width: 460, height: 460, opacity: .25,),
                  ),
              
                  WelcomeCircleUser(width: 400, height: 400, opacity: .5,),
                 
                  WelcomeCircleUser(width: 340, height: 340, opacity: .7,),

                  WelcomeCircleUser(width: 280, height: 280, child: Image(
                      image: AssetImage(CbImages.userExample),
                  )),

                  WelcomeOrbitCircle(size: 15, top: 120, left: 38,),

                  WelcomeOrbitCircle(size: 15, bottom: 250, right: 30,),

                  WelcomeOrbitCircle(size: 25, bottom: 95, left: 50,),

                  WelcomeOrbitCircle(size: 12, top: 45, right: 150,),
                ],
              ),
            ),
          
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
              child: Column(
                children: [
                  LoginHeader(title: 'Olá, Chico!', subtitle: CbTexts.welcomeIntroduction),
                  SizedBox(height: CbSizes.spaceBtwSections,),

                  SizedBox(
                    height: CbSizes.buttonHeight * 3.5,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        CbTexts.startNow
                      )
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

