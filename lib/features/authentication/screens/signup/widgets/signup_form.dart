import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:carboneto/common/widgets/login/login_no_account_text.dart';
import 'package:carboneto/features/authentication/controllers/signup/signup_controller.dart';
import 'package:carboneto/features/authentication/screens/login/login.dart';
import 'package:carboneto/features/authentication/screens/signup/widgets/terms_text.dart';
import 'package:carboneto/features/personalization/screens/profile/edit_profile/widgets/country_selector.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:carboneto/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Form(
          key: controller.signupFormKey,
          child: Column(
            children: [
              FocusedTextField(
                prefixIcon: Icon(Iconsax.user),
                hintText: CbTexts.name,
                controller: controller.name,
                validator: (value) => CbValidator.validateEmptyText('Nome', value),
              ),
              SizedBox(height: CbSizes.spaceBtwInputFields),
              FocusedTextField(
                hintText: CbTexts.username,
                controller: controller.username,
                prefixIcon: Icon(Iconsax.user_edit),
                validator: (value) => CbValidator.validateEmptyText('Nome de Usuário', value),
              ),
              SizedBox(height: CbSizes.spaceBtwInputFields),


              FocusedTextField(
                hintText: CbTexts.email,
                prefixIcon: Icon(Iconsax.sms),
                controller: controller.email, 
                validator: (value) => CbValidator.validateEmail(value),
              ),
              SizedBox(height: CbSizes.spaceBtwInputFields),
              Obx(
                () => FocusedTextField(
                  hintText: CbTexts.password,
                  prefixIcon: Icon(Iconsax.password_check),
                  validator: (value) => CbValidator.validatePassword(value),
                  controller: controller.password,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.hidePassword.value ?
                        Iconsax.eye_slash : 
                        Iconsax.eye
                    ),
                    onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                    ),
                  obscureText: controller.hidePassword.value,
                ),
              ),
              SizedBox(height: CbSizes.spaceBtwInputFields),
 
              FocusedTextField(
                controller: controller.description,
                hintText: 'Descrição(opcional)',
                maxLines: 2,
              ),
              SizedBox(height: CbSizes.spaceBtwInputFields),
              
              CbCountrySelector(showLabel: false,),
              SizedBox(height: CbSizes.spaceBtwInputFields),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Posição',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: CbSizes.sm),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: CbColors.darkGrey,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(CbSizes.md),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: CbColors.dark,
                        value: controller.dropDownValue,
                        hint: Text('Selecione uma opção', style: Theme.of(context).textTheme.bodyMedium,),
                        items: controller.dropDownList.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: Theme.of(context).textTheme.bodyLarge,),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            controller.dropDownValue = newValue;
                          });
                        },
                        icon: const Icon(Icons.arrow_drop_down),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                
                
                ],
              ),
              SizedBox(height: CbSizes.spaceBtwInputFields),

            ],
          ),
        ),
        Row(
          children: [
            Obx(
              () => Checkbox(
                value: controller.policyPrivacy.value, 
                onChanged: (value) => controller.policyPrivacy.value = !controller.policyPrivacy.value,
              ),
            ),
            TermsText(),
          ],
        ),
        SizedBox(height: CbSizes.spaceBtwSections),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => controller.signup(),
            child: Text(CbTexts.createAccountTitle),
          ),
        ),
        SizedBox(height: CbSizes.spaceBtwSections),
        LoginNoAccountText(
          firstText: CbTexts.alreadyHaveAccount,
          secondText: CbTexts.login,
          onTap: () => Get.to(LoginScreen()),
        )
      ],
    );
  }
}
