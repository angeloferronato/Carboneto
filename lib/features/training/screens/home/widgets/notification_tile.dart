import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/features/personalization/models/notification_model.dart';
import 'package:carboneto/features/personalization/screens/profile/profile.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/highlight_btn.dart';
import 'package:carboneto/features/training/controllers/notifications_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.notification,
  });

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    final NotificationsController controller =
        Get.put(NotificationsController());

    return InkWell(
      onTap: () {
        if (notification.type == NotificationType.likeTraining &&
            notification.targetId != null) {
        } else {
          Get.to(() => ProfileScreen(userId: notification.fromUserId));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: CbSizes.md, vertical: CbSizes.sm),
        child: Row(
          children: [
            CbRoundedImage(
              imageUrl: notification.fromUserProfilePicture.isEmpty
                  ? CbImages.userDefault
                  : notification.fromUserProfilePicture,
              width: 44,
              height: 44,
              borderRadius: 44,
              isNetworkImage: notification.fromUserProfilePicture.isNotEmpty,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: CbSizes.md),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${notification.fromUserUsername} ',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontSize: 14),
                    ),
                    if (notification.fromUserIsVerified)
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(Iconsax.verify5,
                              color: CbColors.primary, size: 14),
                        ),
                      ),
                    TextSpan(
                      text:
                          NotificationModel.notificationText(notification.type),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 13,
                            color: const Color.fromARGB(255, 211, 211, 211),
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: CbHelperFunctions.formatNotificationTimestamp(
                          notification.createdAt),
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(color: CbColors.darkGrey),
                    ),
                  ],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: CbSizes.sm),
            if (notification.type == NotificationType.followRequest)
              _buildFollowButtons(controller)
            else if (notification.type == NotificationType.likeTraining &&
                notification.targetImageUrl.isNotEmpty)
              CbRoundedImage(
                imageUrl: notification.targetImageUrl,
                isNetworkImage: true,
                width: 55,
                height: 55,
                fit: BoxFit.cover,
              )
          ],
        ),
      ),
    );
  }

  Widget _buildFollowButtons(NotificationsController controller) {
    return Row(
      spacing: 5,
      children: [
        HighlightBtn(
          textValue: 'Recusar',
          fontSize: 14,
          labelWeight: FontWeight.w600,
          onPressedEdit: () =>
              controller.rejectFollowRequest(notification.id ?? ''),
          radius: 15,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        ElevatedButton(
          onPressed: () => controller.acceptFollowRequest(
              notification.id ?? '', notification.fromUserId),
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
          child: const Text('Aceitar', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),),
        )
      ],
    );
  }
}
