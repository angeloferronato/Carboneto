import 'package:carboneto/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CbAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CbAppBar({
    super.key,
    this.title,
    this.showBackArrow = false,
    this.leadingIcon,
    this.actions,
    this.leadingOnPressed,
    this.centerTitle = false,
  });

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: AppBar(
        automaticallyImplyLeading: false,
        leading: showBackArrow
            ? IconButton(
                onPressed: () {
                  try {
                    if (Get.key.currentState?.canPop() ?? false) {
                      Get.back();
                    } else {
                      Navigator.of(context).maybePop();
                    }
                  } catch (_) {
                    Navigator.of(context).maybePop();
                  }
                },
                icon: Icon(Iconsax.arrow_left),
              )
            : leadingIcon != null
                ? IconButton(
                    onPressed: leadingOnPressed,
                    icon: Icon(leadingIcon),
                  )
                : null,
        actions: actions,
        title: title,
        centerTitle: centerTitle,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(CbDeviceUtils.getAppBarHeight());
}
