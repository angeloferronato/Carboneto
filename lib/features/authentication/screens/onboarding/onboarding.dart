import 'package:carboneto/features/authentication/screens/onboarding/widgets/top_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:carboneto/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:carboneto/features/authentication/screens/onboarding/onboarding_dot_navigation.dart';
import 'package:carboneto/features/authentication/screens/onboarding/widgets/onboarding_bottom_buttons.dart';
import 'package:carboneto/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/text_strings.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      backgroundColor: Colors.transparent, 
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Color(0xFF1E3A8A), 
                Color(0xFF0F172A),
              ],
              center: Alignment.center,
              radius: 0.8,
            ),
          ),
          
          child: SafeArea(
            child: Column(
              children: [
                const TopLogo(showNotification: false),

                Expanded(
                  child: PageView(
                    onPageChanged: controller.updatePageIndicator,
                    controller: controller.pageController,
                    children: const [ 
                      OnboardingPage(
                        title: CbTexts.onboardingTitle1,
                        subtitle: CbTexts.onboardingSubtitle1,
                        image: CbImages.onboardingIlustration1,
                      ),
                      OnboardingPage(
                        title: CbTexts.onboardingTitle2,
                        subtitle: CbTexts.onboardingSubtitle2,
                        image: CbImages.onboardingIlustration2,
                      ),
                      OnboardingPage(
                        title: CbTexts.onboardingTitle3,
                        subtitle: CbTexts.onboardingSubtitle3,
                        image: CbImages.onboardingIlustration3,
                      ),
                    ],
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, 
                    children: const [ 
                      OnboardingDotNavigation(), 
                      SizedBox(height: 40), 
                      OnboardingBottomButtons(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}