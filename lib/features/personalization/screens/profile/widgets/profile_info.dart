import 'package:carboneto/features/personalization/controllers/profile_base_controller.dart/profile_base_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/loading_effects/shimmer_effects.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key, required this.userId,});
  final String userId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileBaseController(userId: userId), tag: userId);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(
          () => controller.profileLoading
            ? CbShimmerEffects(width: 200, height: 12)
            : Text(
              "@${controller.user.value.username}",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
        ),
        
        Obx(
          () => !controller.profileLoading 
            ? controller.user.value.isVerified ? Row(
              children: [
                SizedBox(width: 4,),
                Icon(
                  Iconsax.verify5,
                  color: CbColors.primary,
                  size: 16,
                ),
                SizedBox(width: 10,),
              ],
            ) : Row(
              children: [
                SizedBox(width: 10,),
                Text(
                  '•',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
                SizedBox(width: 10,)
              ],
            )
            : Row(
              children: [
                SizedBox(width: 10,),
                CbShimmerEffects(width: 16, height: 16),
                SizedBox(width: 10,),
              ],
            )
        ),
        Obx(() => !controller.profileLoading
          ? CountryFlag.fromCountryCode(
              controller.user.value.countryCode,
              width: 22,
              shape: RoundedRectangle(3),
              height: 15,
            )
          : CbShimmerEffects(width: 22, height: 15)
        )
      ],
    );
  }
}
