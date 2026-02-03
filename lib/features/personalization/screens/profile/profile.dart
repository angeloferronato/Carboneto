import 'package:carboneto/common/styles/spacing_styles.dart';
import 'package:carboneto/features/personalization/controllers/profile_base_controller.dart/profile_base_controller.dart';
import 'package:carboneto/features/personalization/screens/profile/edit_profile/edit_profile.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/banner_picture.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/content_grid.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/highlight_btn.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/profile_info.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/loading_effects/shimmer_effects.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.userId});

  final String userId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileBaseController(userId: widget.userId), tag: widget.userId);
    return Scaffold(
      body: Padding(
        padding: CbSpacingStyle.paddingWithAppBarHeight * 0,
        child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(
            children: [
              BannerWithPicture(userId: widget.userId,),
              SizedBox(
                height: 60,
              ),
              ProfileInfo(userId: widget.userId,),
              SizedBox(
                height: 5,
              ),
              Obx(
                () => controller.profileLoading
                    ? CbShimmerEffects(width: 200, height: 30)
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: CbSizes.defaultSpace),
                        child: Text(
                          controller.user.value.name,
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: CbSizes.defaultSpace*2.5),
                child: Obx(
                  () => !controller.profileLoading ? Text(
                    controller.user.value.description,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center,
                  ) : Column(
                    children: [
                      CbShimmerEffects(width: 120, height: 10),
                      SizedBox(height: 5,),
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
              Obx(
                () => controller.isAuthUser
                ? HighlightBtn(
                  textValue: 'Editar Perfil',
                  onPressedEdit: () => Get.to(() => EditProfileScreen()),
                )
                : HighlightBtn(textValue: 'Seguir', onPressedEdit: () {}),
              ),
              SizedBox(
                height: 40,
              ),
              ContentGrid(userId: widget.userId,),
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



