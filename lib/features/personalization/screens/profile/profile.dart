import 'package:carboneto/common/styles/spacing_styles.dart';
import 'package:carboneto/common/widgets/buttons/action_text_button.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/common/widgets/texts/section_heading.dart';
import 'package:carboneto/data/repositories/authentication/authentication_repository.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/profile_text_row.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/training_lib_item_profile.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/loading_effects/shimmer_effects.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return Scaffold(
      body: Padding(
        padding: CbSpacingStyle.paddingWithAppBarHeight,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CbRoundedImage(
                    imageUrl: CbImages.userExample, 
                    borderRadius: 200, 
                    // border: Border.all(color: CbColors.primary, width: 1.5),
                    width: 100,
                    height: 100,
                  ),

                  SizedBox(width: CbSizes.spaceBtwItems * 1.2,),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => controller.profileLoading.value ? CbShimmerEffects(width: 80, height: 30) :
                          Text(
                            controller.user.value.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.headlineMedium
                          ),
                        ),
                    
                        Row(
                          children: [
                            ProfileTextRow(counter: '13', text: 'seguidores',),
                            Text(' · '),
                            ProfileTextRow(counter: '17', text: 'seguindo'),
                          ],
                        )
                      ]
                    ),
                  )
                ],
              ),

              const SizedBox(height: CbSizes.spaceBtwItems,),

              CbActionTextButton(text: 'Editar',),

              const SizedBox(height: CbSizes.spaceBtwSections,),

              CbSectionHeading(title: 'Treinos Criados', onPressed: (){}, showButton: false,),

              const SizedBox(height: CbSizes.spaceBtwItems,),

              Column(
                children: List.generate(4, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Image(
                          image: AssetImage(CbImages.trainingExample),
                          height: 55,
                          width: 55,
                        ),
                    
                        const SizedBox(width: CbSizes.spaceBtwItems / 2,),
                    
                        TrainingLibItemProfile(title: 'Controle de bola', description: 'Arremesso, Forma do Arremesso, 40 min',),
                      ],
                    ),
                  );
                })
              ),

              const SizedBox(height: CbSizes.spaceBtwSections,),

              Center(child: CbActionTextButton(text: 'Ver todos os treinos criados', padding: const EdgeInsets.symmetric(horizontal: CbSizes.md), height: 32,)),
              const SizedBox(height: CbSizes.spaceBtwSections,),
              
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(onPressed: () => AuthenticationRepository.instance.logout(), child: Text('Logout'),),
              ),
          
            ]
          )
        ),
      ),
    );
  }
}





