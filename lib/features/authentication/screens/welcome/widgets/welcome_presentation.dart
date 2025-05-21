import 'package:carboneto/common/widgets/login/login_header.dart';
import 'package:carboneto/home_menu.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomePresentation extends StatelessWidget {
  const WelcomePresentation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
      child: Column(
        children: [
          LoginHeader(title: 'Olá, Chico!', subtitle: CbTexts.welcomeIntroduction),
          SizedBox(height: CbSizes.spaceBtwSections,),
    
          SizedBox(
            height: CbSizes.buttonHeight * 3.5,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.offAll(HomeMenu()),
              child: Text(
                CbTexts.startNow
              )
            ),
          )
        ],
      ),
    );
  }
}