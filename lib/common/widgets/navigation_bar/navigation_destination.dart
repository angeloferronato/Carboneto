import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CbCustomNavigationDestination extends StatelessWidget {
  const CbCustomNavigationDestination({
    super.key, this.width = 30, this.height, required this.image, this.label = '', this.showIndicator = false,
  });

  final double? width, height;
  final String image, label;
  final bool showIndicator;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        NavigationDestination(
          icon: SizedBox(
            width: width,
            height: height,
            child: Image(
              image: AssetImage(image),
              color: showIndicator ? CbColors.primary : CbColors.darkGrey,
            )
          ),
          label: label,
        ),

        Positioned(
          top: 55,
          child: Container(
            height: 6,
            width: 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: showIndicator ? CbColors.primary : Colors.transparent,
            ),
          ),
        ),
      ]
    );
  }
}