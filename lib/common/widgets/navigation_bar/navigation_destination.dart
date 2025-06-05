import 'package:carboneto/common/widgets/custom_shapes/containers/rounded_countainer.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CbCustomNavigationDestination extends StatelessWidget {
  const CbCustomNavigationDestination({
    super.key, this.width = 30, this.height, required this.image, this.label = '', this.showIndicator = false, this.filledImage,
  });

  final double? width, height;
  final String image, label;
  final String? filledImage;
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
              image: AssetImage(showIndicator ? filledImage ?? image : image),
              color: showIndicator ? CbColors.primary : CbColors.darkGrey,
            )
          ),
          label: label,
        ),

        Positioned(
          top: 55,
          child: CbRoundedContainer(width: 15, height: 5, backgroundColor: showIndicator ? CbColors.primary : Colors.transparent,)
        ),
      ]
    );
  }
}