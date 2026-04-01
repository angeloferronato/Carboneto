import 'package:carboneto/common/widgets/buttons/cb_primary_btn.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/highlight_btn.dart';
import 'package:carboneto/features/settings/controllers/follow_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToggleFollowButton extends StatelessWidget {
  const ToggleFollowButton({
    super.key,
    required this.currentUserId,
    required this.targetUserId,
    required this.isPrivate,
    this.smallBtn = false,
  });

  final String currentUserId;
  final String targetUserId;
  final bool isPrivate;
  final bool smallBtn;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);

    final followController = Get.put(
      FollowController(
        currentUserId: currentUserId,
        targetUserId: targetUserId,
      ),
      tag: '$currentUserId$targetUserId',
    );

    return Obx(() => followController.isLoading.value
        ? HighlightBtn(
            padding: EdgeInsets.symmetric(horizontal: 48, vertical: 12),
            textValue: '',
            icon: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 4.0,
                color: CbColors.primary,
              ),
            ),
            onPressedEdit: () {},
          )
        : followController.isFollowing.value
            ? HighlightBtn(
                textValue: 'Seguindo',
                labelColor: isDarkMode ? CbColors.white : CbColors.dark,
                onPressedEdit: () => followController.stopFollowingUser(),
              )
            : followController.followRequestId.value.isNotEmpty
                ? HighlightBtn(
                    textValue: 'Pedido enviado',
                    onPressedEdit: () => followController.cancelFollowRequest(),
                  )
                : smallBtn
                    ? CbPrimaryBtn(
                        label: 'Seguir',
                        paddingV: 0,
                        paddingH: 15,
                        onPressed: () => isPrivate
                            ? followController.sendFollowRequest()
                            : followController.startFollowingUser(),
                      )
                    : CbPrimaryBtn(
                        label: 'Seguir',
                        paddingH: 25,
                        fontSize: 17,
                        onPressed: () => isPrivate
                            ? followController.sendFollowRequest()
                            : followController.startFollowingUser(),
                      ));
  }
}
