import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/loading_effects/shimmer_effects.dart';
import 'package:flutter/material.dart';

class NotificationTileShimmer extends StatelessWidget {
  const NotificationTileShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: CbSizes.md, vertical: CbSizes.sm),
      child: Row(
        children: [
          CbShimmerEffects(width: 50, height: 50, radius: 50,),
          const SizedBox(width: CbSizes.md,),
    
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CbShimmerEffects(width: 150, height: 15),
                const SizedBox(height: CbSizes.sm,),
                CbShimmerEffects(width: 100, height: 12)
              ],
            ),
          ),
          const SizedBox(width: CbSizes.md,),
    
          Align(
            alignment: AlignmentGeometry.centerRight,
            child: Row(
              children: [
                CbShimmerEffects(width: 80, height: 40, radius: 15,),
                const SizedBox(width: CbSizes.sm,),
                CbShimmerEffects(width: 80, height: 40, radius: 15,),
              ],
            ),
          )
        ],
      )
    );
  }
}