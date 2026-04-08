import 'package:carboneto/common/widgets/buttons/cb_primary_btn.dart';
import 'package:carboneto/common/widgets/login/login_header.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/personalization/models/user_model.dart';
import 'package:carboneto/home_menu.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:carboneto/utils/loading_effects/shimmer_effects.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomePresentation extends StatelessWidget {
  const WelcomePresentation({
    super.key,
  });



  @override
  Widget build(BuildContext context) {
    final userRepository = Get.put(UserController());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
      child: Column(
        children: [
          Obx(
            () => userRepository.profileLoading.value 
            ? Column(
              children: [
                CbShimmerEffects(width: 200, height: 35),
                const SizedBox(height: 10,),
                CbShimmerEffects(width: 300, height: 35),
                const SizedBox(height: 10,),
              ],
            )
            : LoginHeader(title: 'Olá, ${UserModel.nameParts(userRepository.user.value.name)[0]}', subtitle: CbTexts.welcomeIntroduction),
          ),
          
          
          
          SizedBox(height: CbHelperFunctions.screenHeight() * 0.001,),
    
          SizedBox(
            height: CbSizes.buttonHeight * 3.5,
            width: double.infinity,
            child: CbPrimaryBtn(
              label: CbTexts.startNow,
              borderRadius: 50,
              fontSize: 15,
              onPressed: () => Get.offAll(HomeMenu()),
            ),
          )
        ],
      ),
    );
  }
}