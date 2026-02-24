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

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.notification,
  });

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    final NotificationsController controller = Get.put(NotificationsController());
    return InkWell(
      onTap: () => Get.to(ProfileScreen(userId: notification.fromUserId,)),
      child: Container(    
        padding: const EdgeInsets.symmetric(horizontal: CbSizes.md, vertical: CbSizes.sm ),
        child: Row(
          children: [
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CbRoundedImage(
                    imageUrl: notification.fromUserProfilePicture.isEmpty ? CbImages.userDefault : notification.fromUserProfilePicture,
                    width: 50,
                    height: 50,
                    borderRadius: 50,
                    isNetworkImage: notification.fromUserProfilePicture.isNotEmpty,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: CbSizes.md,),
                
                  Expanded(
                    child: Text.rich(
                      TextSpan( 
                        children: [
                          TextSpan(
                            text: notification.fromUserUsername,
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 15),
                          ),
                          TextSpan(text: ' '),
                          TextSpan(
                            text: NotificationModel.notificationText(notification.type),
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 13, color: const Color.fromARGB(255, 211, 211, 211), fontWeight: FontWeight.w600)
                          ),
                          TextSpan(text: ' '),
                          TextSpan(
                            text: CbHelperFunctions.formatNotificationTimestamp(notification.createdAt),
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 13, color: CbColors.darkGrey, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
      

            if (notification.type == NotificationType.followRequest) Align(
              alignment: AlignmentGeometry.centerRight,
              child: Row(
                children: [
                  HighlightBtn(
                    textValue: 'Recusar', 
                    onPressedEdit: () => controller.rejectFollowRequest(notification.id ?? ''),
                    radius: 15,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    
                  ),
                  const SizedBox(width: CbSizes.sm,),
                  ElevatedButton(
                    onPressed: () => controller.acceptFollowRequest(notification.id ?? '', notification.fromUserId),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    child: Text('Aceitar'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}