import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CbCustomNavigationDestination extends StatelessWidget {
  const CbCustomNavigationDestination({
    super.key, this.width = 30, this.height, required this.image, this.label = '',
  });

  final double? width, height;
  final String image, label;

  @override
  Widget build(BuildContext context) {
    return NavigationDestination(
      icon: SizedBox(
        width: width,
        height: height,
        child: Image(
          image: AssetImage(image),
          color: CbColors.darkGrey,
        )
      ),
      label: label,
    );
  }
}