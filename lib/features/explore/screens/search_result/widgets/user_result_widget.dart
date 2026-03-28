import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/personalization/models/user_search_model.dart';
import 'package:carboneto/features/personalization/screens/profile/profile.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/toggle_follow_button.dart';
import 'package:carboneto/home_menu.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class UserResultWidget extends StatelessWidget {
  UserResultWidget({super.key, required this.user});

  final UserSearchModel user;
  final currentUserId = UserController.instance.user.value.id;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: user.id.isEmpty
            ? null
            : () => Get.to(() => ProfileScreen(userId: user.id)),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            CbRoundedImage(
              imageUrl: user.profilePicture.isEmpty
                  ? CbImages.userDefault
                  : user.profilePicture,
              width: 55,
              height: 55,
              borderRadius: 55,
              isNetworkImage: user.profilePicture.isNotEmpty,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          user.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color:
                                    isDarkMode ? Colors.white : Colors.black87,
                              ),
                        ),
                      ),
                      if (user.isVerified)
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Icon(
                            Iconsax.verify5,
                            color: CbColors.primary,
                            size: 14,
                          ),
                        ),
                    ],
                  ),
                  Text(
                    '@${user.username}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w400,
                          color:
                              isDarkMode ? CbColors.light : CbColors.darkerGrey,
                        ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${CbHelperFunctions.formatCountFollowType(user.followersCount)} Seguidores',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: isDarkMode
                                  ? CbColors.light
                                  : CbColors.darkerGrey,
                            ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      CountryFlag.fromCountryCode(
                        (user.countryCode?.isEmpty ?? true)
                            ? 'br'
                            : user.countryCode!,
                        width: 17,
                        shape: RoundedRectangle(3),
                        height: 12,
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              width: 3,
            ),
            currentUserId == user.id
                ? GestureDetector(
                    child:
                        const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                    onTap: () {
                      Get.offAll(HomeMenu());
                      final homeMenuController = Get.put(HomeMenuController());
                      homeMenuController.selectedIndex.value = 4;
                    },
                  )
                : ToggleFollowButton(
                    currentUserId: UserController.instance.user.value.id,
                    targetUserId: user.id,
                    isPrivate: user.isPrivate,
                    smallBtn: true,
                  )
          ],
        ),
      ),
    );
  }
}
