import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CbRoundedImage extends StatelessWidget {
  const CbRoundedImage({super.key, this.borderRadius = CbSizes.cardRadiusSm, required this.width, required this.height, this.backgroundColor = Colors.transparent, required this.image});

  final double borderRadius, width, height;
  final Color backgroundColor;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius)
      ),
      child: Image(image: AssetImage(image)),
    );
  }
}