import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/loading_effects/shimmer_effects.dart';
import 'package:flutter/material.dart';

class FollowersAndFollowingShimmer extends StatelessWidget {
  const FollowersAndFollowingShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            CbShimmerEffects(width: 50, height: 25),
            SizedBox(height: CbSizes.sm,),
            CbShimmerEffects(width: 100, height: 12),
          ],
        ),
        Column(
          children: [
            CbShimmerEffects(width: 50, height: 25),
            SizedBox(height: CbSizes.sm,),
            CbShimmerEffects(width: 100, height: 12),
          ],
        ),
        Column(
          children: [
            CbShimmerEffects(width: 50, height: 25),
            SizedBox(height: CbSizes.sm,),
            CbShimmerEffects(width: 100, height: 12),
          ],
        ),
      ],
    );
  }
}