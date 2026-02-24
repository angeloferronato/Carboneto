import 'package:carboneto/features/personalization/models/notification_model.dart';
import 'package:carboneto/features/training/screens/home/widgets/notifications_screen.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:get/get.dart';

class TopLogo extends StatelessWidget {
  const TopLogo({super.key, this.width = 90});
  final double width;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = CbHelperFunctions.isDarkMode(context); 
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Image(
            image: AssetImage(isDarkMode ? CbImages.cbWhiteLogo : CbImages.cbBlueLogo),
            width: width,
          ),
        ),

        Positioned(
          right: 30,
          top: 25,
          child: IconButton( 
            onPressed: () => Get.to(() => NotificationsScreen()), 
            icon: Icon(CupertinoIcons.bell_fill, color: CbColors.white, size: 28,)
          ),
        ),
      ],
    );
  }
}
