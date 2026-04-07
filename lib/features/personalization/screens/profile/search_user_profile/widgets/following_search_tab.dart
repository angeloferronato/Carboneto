import 'package:carboneto/common/widgets/searchinput/search_input.dart';
import 'package:carboneto/features/personalization/controllers/follow_search_controller/follow_search_controller.dart';
import 'package:carboneto/features/personalization/screens/profile/search_user_profile/widgets/user_search_tile.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowingSearchTab extends StatelessWidget {
  const FollowingSearchTab({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    final FollowSearchController followSearchController =
        Get.put(FollowSearchController(userId: userId), tag: userId);
    return Obx(
      () => ListView.builder(
        itemCount: followSearchController.followingResults.length + 3,
        itemBuilder: (_, index) {
          if (index == 0) {
            return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: CbSizes.md, vertical: CbSizes.sm),
                child: SearchInput(
                  placeholder: 'Pesquisar',
                  controller:
                      followSearchController.searchQueryFollowingController,
                  onChanged: followSearchController.onSearchChanged,
                ));
          }

          final itemIndex = index - 1;

          if (itemIndex == followSearchController.followingResults.length) {
            return Obx(
              () => followSearchController.isLoading.value
                  ? Column(
                      children: [
                        SizedBox(
                          height: CbSizes.md,
                        ),
                        SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: CbColors.primary,
                            )),
                        SizedBox(
                          height: CbSizes.md,
                        ),
                      ],
                    )
                  : SizedBox(),
            );
          }

          if (itemIndex == followSearchController.followingResults.length + 1) {
            return followSearchController.showMoreButton
                ? Align(
                    alignment: Alignment.center,
                    child: TextButton(
                        onPressed: () =>
                            followSearchController.loadFollowingPage(),
                        child: Text(
                          'Carregar mais',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color:
                                      const Color.fromARGB(255, 76, 129, 241)),
                        )),
                  )
                : SizedBox();
          }

          return UserSearchTile(
            user: followSearchController.followingResults[itemIndex],
          );
        },
        shrinkWrap: true,
      ),
    );
  }
}
