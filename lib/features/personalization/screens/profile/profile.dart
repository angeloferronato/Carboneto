import 'package:carboneto/common/styles/spacing_styles.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/personalization/screens/profile/edit_profile/edit_profile.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/banner_picture.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/content_grid.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/highlight_btn.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/profile_info.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/loading_effects/shimmer_effects.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    return Scaffold(
      body: Padding(
        padding: CbSpacingStyle.paddingWithAppBarHeight * 0,
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(
            children: [
              BannerWithPicture(
                  profileImg: CbImages.userExample,
                  bannerImg: CbImages.bannerDefault),
              SizedBox(
                height: 60,
              ),
              ProfileInfo(userController: userController),
              SizedBox(
                height: 5,
              ),
              Obx(
                () => userController.profileLoading.value
                    ? CbShimmerEffects(width: 200, height: 30)
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: CbSizes.defaultSpace),
                        child: Text(
                          userController.user.value.name,
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: CbSizes.defaultSpace),
                child: Obx(
                  () => !userController.profileLoading.value
                      ? Text(
                          userController.user.value.description,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w300),
                        )
                      : Column(
                          children: [
                            CbShimmerEffects(width: 120, height: 10),
                            SizedBox(
                              height: 5,
                            ),
                            CbShimmerEffects(width: 100, height: 10),
                          ],
                        ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // FollowersAndFollowing(),
              SizedBox(
                height: 10,
              ),
              HighlightBtn(
                textValue: 'Editar Perfil',
                onPressedEdit: () => Get.to(() => EditProfileScreen()),
              ),
              SizedBox(
                height: 40,
              ),
              ContentGrid(),
              SizedBox(
                height: 100,
              )
            ],
          )
        ])),
      ),
    );
  }
}



