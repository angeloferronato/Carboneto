import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/data/repositories/authentication/authentication_repository.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/loading_effects/shimmer_effects.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CbUserProfileTile extends StatelessWidget {
  const CbUserProfileTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return Padding(
      padding: const EdgeInsets.all(CbSizes.defaultSpace),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              children: [
                CbRoundedImage(
                  imageUrl: controller.user.value.profilePicture != '' ? controller.user.value.profilePicture : CbImages.userDefault,
                  isNetworkImage: controller.user.value.profilePicture != '',
                  height: 75,
                  borderRadius: 75,
                  border: Border.all(color: CbColors.primary, width: 1),
                ),
            
                const SizedBox(width: CbSizes.spaceBtwItems,),
            
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => controller.profileLoading.value 
                        ? CbShimmerEffects(width: 100, height: 30)
                        : Text(
                          controller.user.value.name,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20),
                        )
                    ),
                    Obx(
                      () => controller.profileLoading.value 
                        ? CbShimmerEffects(width: 80, height: 30)
                        : Text(
                          '@${controller.user.value.username}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: IconButton(onPressed: () => AuthenticationRepository.instance.logout(), icon: Icon(Icons.exit_to_app, color: CbColors.primary,)),
          ),
        ],
      ),
    );
  }
}