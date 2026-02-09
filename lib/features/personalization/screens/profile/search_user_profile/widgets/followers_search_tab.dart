import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:carboneto/features/personalization/controllers/follow_search_controller/follow_search_controller.dart';
import 'package:carboneto/features/personalization/controllers/profile_base_controller.dart/profile_base_controller.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/personalization/screens/profile/search_user_profile/widgets/user_search_tile.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class FollowersSearchTab extends StatelessWidget {
  const FollowersSearchTab({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context) {
    final ProfileBaseController profileBaseController = Get.put(ProfileBaseController(userId: userId), tag: userId);
    final FollowSearchController followSearchController = Get.put(FollowSearchController(userId: userId), tag: userId);
    return Obx(
      () => ListView.builder(
        itemCount: followSearchController.followersResults.length + 3,
        itemBuilder: (_, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: CbSizes.md, vertical: CbSizes.sm),
                child: FocusedTextField(
                  controller: followSearchController.searchQueryFollowersController,
                  onChanged: followSearchController.onSearchChanged,
                  prefixIcon: Icon(Iconsax.search_normal),
                  hintText: 'Pesquisar',
                ),
              );
            }
            
            final itemIndex = index - 1;
    
            if (itemIndex == followSearchController.followersResults.length) {
              return Obx(
                () => followSearchController.isLoading.value
                ? Column(
                  children: [
                    SizedBox(height: CbSizes.md,),
                    SizedBox(height: 50, width: 50, child: CircularProgressIndicator(strokeWidth: 2, color: CbColors.primary, )),
                    SizedBox(height: CbSizes.md,),
                  ],
                ) : SizedBox(),
              );
            }
    
            if (itemIndex == followSearchController.followersResults.length + 1) {
              return followSearchController.showMoreButton
              ? Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () => followSearchController.loadFollowersPage(), 
                  child: Text(
                    'Carregar mais', 
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color.fromARGB(255, 76, 129, 241)),
                  )
                ),
              ) : SizedBox();
            }
                      
            return UserSearchTile(user: followSearchController.followersResults[itemIndex], isUserFollow: profileBaseController.user.value.id == UserController.instance.user.value.id,);
        },
        shrinkWrap: true,
      ), 
    );
  }
}