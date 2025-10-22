import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/personalization/screens/settings/settings.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/loading_effects/shimmer_effects.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class BannerWithPicture extends StatelessWidget {
  const BannerWithPicture(
      {super.key, required this.profileImg, required this.bannerImg});
  final String profileImg;
  final String bannerImg;

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final screenWidth = MediaQuery.of(context).size.width;
    final bannerHeight = screenWidth * 0.6;
    final avatarRadius = screenWidth * 0.21;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.transparent],
              stops: [0.1, 0.9],
            ).createShader(rect);
          },
          blendMode: BlendMode.dstIn,
          child: Image.asset(
            CbImages.bannerDefault,
            width: double.infinity,
            height: bannerHeight,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: -avatarRadius / 2,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CbColors.primary,
            ),
            child: Obx(
              () => !userController.profileLoading.value
                  ? (userController.user.value.profilePicture != ''
                      ? CbRoundedImage(
                          imageUrl: userController.user.value.profilePicture,
                          isNetworkImage: true,
                          borderRadius: avatarRadius,
                          width: 180,
                          height: 180,
                        )
                      : CbRoundedImage(
                          imageUrl: CbImages.userDefault,
                          borderRadius: avatarRadius,
                          width: 180,
                        ))
                  : CbShimmerEffects(
                      width: 180,
                      height: 180,
                      radius: avatarRadius,
                    ),
            ),
          ),
        ),
        Positioned(
          top: 40,
          right: 16,
          child: IconButton(
            icon: Icon(CupertinoIcons.settings,
                color: Colors.white, size: screenWidth * 0.07),
            onPressed: () => Get.to(SettingsScreen()),
          ),
        ),
      ],
    );
  }
}