import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/utils/loading_effects/shimmer_effects.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key, required this.userController});
  final UserController userController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10,
      children: [
        Obx(
          () => userController.profileLoading.value
              ? CbShimmerEffects(width: 200, height: 12)
              : Text(
                  "@${userController.user.value.username}",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
        ),
        Text(
          '•',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        Obx(() => !userController.profileLoading.value
            ? CountryFlag.fromCountryCode(
                userController.user.value.countryCode,
                width: 22,
                shape: RoundedRectangle(3),
                height: 15,
              )
            : CbShimmerEffects(width: 22, height: 15))
      ],
    );
  }
}
