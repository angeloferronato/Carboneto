import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/loading_effects/shimmer_effects.dart';
import 'package:flutter/material.dart';

class HomeTrainingShimmer extends StatelessWidget {
  const HomeTrainingShimmer ({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CbShimmerEffects(
            radius: 20,
            width: 245,
            height: 135
          ),
          const SizedBox(height: CbSizes.sm,),
                        
          SizedBox(
            width: 245,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CbShimmerEffects(width: 85, height: 10),
                CbShimmerEffects(width: 40, height: 10),
              ],
            ),
          ),
          const SizedBox(height: CbSizes.xs,),
                        
          CbShimmerEffects(width: 200, height: 12),
          const SizedBox(height: CbSizes.sm,),
                        
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CbShimmerEffects(width: 15, height: 15),
              const SizedBox(width: CbSizes.sm,),
              CbShimmerEffects(width: 70, height: 10),
            ],
          ),
          const SizedBox(height: CbSizes.xs,),
                        
          CbShimmerEffects(width: 50, height: 10),
        ],
      
      ),
    );
  }
}