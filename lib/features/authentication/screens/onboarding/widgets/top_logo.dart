import 'package:carboneto/features/training/controllers/notifications_controller.dart';
import 'package:carboneto/features/training/screens/home/widgets/notifications_screen.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TopLogo extends StatelessWidget {
  const TopLogo({
    super.key,
    this.width = 90,
    this.showNotification = true,
  });

  final double width;
  final bool showNotification;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = CbHelperFunctions.isDarkMode(context);
    final notificationsController = Get.isRegistered<NotificationsController>()
        ? Get.find<NotificationsController>()
        : Get.put(NotificationsController());

    return SizedBox(
      height: 90,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Image(
              image: AssetImage(
                isDarkMode ? CbImages.cbWhiteLogo : CbImages.cbBlueLogo,
              ),
              width: width,
            ),
          ),

          if (showNotification)
            Positioned(
              right: 0,
              child: Obx(() {
                final unread = notificationsController.unreadCount.value;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      onPressed: () => Get.to(() => NotificationsScreen()),
                      icon: const Icon(Iconsax.notification, size: 28),
                    ),
                    if (unread > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: CbColors.primary,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                          child: Text(
                            unread > 99 ? '99+' : '$unread',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ),
        ],
      ),
    );
  }
}