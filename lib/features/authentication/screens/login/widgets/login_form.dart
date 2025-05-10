import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FocusedTextField(
          hintText: CbTexts.email,
          prefixIcon: Iconsax.sms,
        ),
      
        SizedBox(height: CbSizes.spaceBtwInputFields,),
      
        FocusedTextField(
          hintText: CbTexts.password,
          prefixIcon: Iconsax.password_check,
          suffixIcon: Iconsax.eye,
        ),
      
        SizedBox(height: CbSizes.spaceBtwItems / 2,),
      
        Row(
          children: [
            Checkbox(
              value: true,
              onChanged: (value) {},
            ),
      
            Text(CbTexts.keepMeConnected,)
          ],
        ),
      
        SizedBox(height: CbSizes.spaceBtwSections,),
      
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              CbTexts.entry,
            ),
          ),
        ),
      
        SizedBox(height: CbSizes.spaceBtwItems / 1.5,),
      
        TextButton(
          onPressed: () {},
          child: Text(CbTexts.forgetPassword),
        ),

        SizedBox(height: CbSizes.spaceBtwItems,),
      ],
    );
  }
}