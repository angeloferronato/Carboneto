import 'package:carboneto/features/training/screens/home/widgets/notifications_screen.dart';
import 'package:flutter/cupertino.dart';
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

    return SizedBox(
      height: 90,
      width: double.infinity, 
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Image(
              image: AssetImage(
                isDarkMode
                    ? CbImages.cbWhiteLogo
                    : CbImages.cbBlueLogo,
              ),
              width: width,
            ),
          ),

          if (showNotification)
            Positioned(
              right: 0,
              child: IconButton(
                onPressed: () =>
                    Get.to(() => NotificationsScreen()),
                icon: const Icon(
                  Iconsax.notification5,
                  size: 28,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
