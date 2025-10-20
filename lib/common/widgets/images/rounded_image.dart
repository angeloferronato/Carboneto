import 'package:cached_network_image/cached_network_image.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/loading_effects/shimmer_effects.dart';
import 'package:flutter/material.dart';
class CbRoundedImage extends StatelessWidget {
  const CbRoundedImage({
    super.key,
    this.width, 
    this.height,
    required this.imageUrl, 
    this.applyImageRadius = true, 
    this.border, 
    this.backgroundColor = CbColors.light, 
    this.fit = BoxFit.contain, 
    this.padding, 
    this.margin,
    this.isNetworkImage = false, 
    this.onPressed, 
    this.borderRadius = CbSizes.md, 
  });

  final double? width, height;
  final String imageUrl;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color backgroundColor;
  final BoxFit? fit; 
  final EdgeInsetsGeometry? padding, margin;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: padding,
        margin: margin,
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius)
        ),
        child: ClipRRect(
          borderRadius: applyImageRadius ? BorderRadius.circular(borderRadius) : BorderRadius.zero,
          child: isNetworkImage ? CachedNetworkImage(
            fit: fit,
            imageUrl: imageUrl,
            progressIndicatorBuilder: (context, url, progress) => CbShimmerEffects(width: width ?? 55, height: height ?? 55, radius: borderRadius,),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ) : Image(
            fit: fit,
            image: AssetImage(imageUrl) as ImageProvider,
          )

        ),
      ),
    );
  }
}