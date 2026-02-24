import 'package:carboneto/features/personalization/models/user_model.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/highlight_btn.dart';
import 'package:carboneto/features/settings/controllers/follow_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToggleFollowButton extends StatelessWidget {
  const ToggleFollowButton({
    super.key, required this.currentUserId, required this.targetUserId, required this.profileUser,
  });

  final String currentUserId, targetUserId;
  final UserModel profileUser;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    final followController = Get.put(FollowController(currentUserId: currentUserId, targetUserId: targetUserId), tag: '$currentUserId$targetUserId');
    return Obx(
      () => followController.isLoading.value 
      ? HighlightBtn(
        padding: EdgeInsets.symmetric(horizontal: 48, vertical: 12),
        textValue: '',
        icon: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 4.0,
            color: CbColors.primary,
          )
        ),
        onPressedEdit: () {}
      )
      : followController.isFollowing.value
        ? HighlightBtn(
          textValue: 'Seguindo', 
          labelColor: isDarkMode 
            ? CbColors.white 
            : CbColors.dark, 
          icon: Icon(Icons.check), 
          onPressedEdit: () => followController.stopFollowingUser(),
        ) : followController.followRequestId.value.isNotEmpty 
          ? HighlightBtn(
            textValue: 'Pedido enviado', 
            onPressedEdit: () => followController.cancelFollowRequest()
          )
          : ElevatedButton(
            onPressed: () => profileUser.isPrivate
              ? followController.sendFollowRequest()
              : followController.startFollowingUser(),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ), 
            child: Text(
              'Seguir', 
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: CbColors.white,
                fontSize: CbSizes.md,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
    );
  }
}