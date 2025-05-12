import 'package:carboneto/features/authentication/screens/signup/widgets/user_mode_signup.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class UserSignUpOptions extends StatelessWidget {
  const UserSignUpOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UserModeSignUp(selectedModeText: 'atleta', image: CbImages.playerImage,),
            SizedBox(width: CbSizes.md,),
            UserModeSignUp(selectedModeText: 'treinador', image: CbImages.coachImage, spaceBtwImage: CbSizes.md,)
          ],
        ),
    
        SizedBox(height: CbSizes.spaceBtwSections,),
      ],
    );
  }
}
