import 'package:carboneto/features/personalization/controllers/follow_search_controller/follow_search_controller.dart';
import 'package:carboneto/features/personalization/controllers/profile_base_controller.dart/profile_base_controller.dart';
import 'package:carboneto/features/personalization/screens/profile/search_user_profile/widgets/followers_search_tab.dart';
import 'package:carboneto/features/personalization/screens/profile/search_user_profile/widgets/following_search_tab.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchUserProfile extends StatelessWidget {
  const SearchUserProfile({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    final ProfileBaseController profileBaseController = Get.put(ProfileBaseController(userId: userId), tag: userId);
    final FollowSearchController followSearchController = Get.put(FollowSearchController(userId: userId), tag: userId);
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(profileBaseController.user.value.username, style: Theme.of(context).textTheme.headlineSmall,),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60), 
          child: Column(
            children: [
              TabBar(
                controller: followSearchController.tabController,
                padding: const EdgeInsets.symmetric(vertical: CbSizes.sm),
                indicatorWeight: 2,
                indicatorColor: CbColors.primary,
                labelColor: isDarkMode ? CbColors.white : CbColors.darkerGrey,
                unselectedLabelColor: CbColors.darkGrey,
                splashFactory: NoSplash.splashFactory,
                tabs: [
                  Obx(() => Tab(text: '${CbHelperFunctions.formatCountFollowType(profileBaseController.followersId.length)}  Seguidores',)),
                  Obx(() => Tab(text: '${CbHelperFunctions.formatCountFollowType(profileBaseController.followingId.length)}  Seguindo',)),
                ]
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: CbSizes.lg),
        child: TabBarView(
          controller: followSearchController.tabController,
          children: [
            FollowersSearchTab(userId: userId,),
            
            FollowingSearchTab(userId: userId,),
          ]
        ),
      ),
    );
  }
}




