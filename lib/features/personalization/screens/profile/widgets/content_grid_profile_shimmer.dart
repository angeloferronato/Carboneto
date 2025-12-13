import 'package:carboneto/common/widgets/layouts/grid_layout.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/loading_effects/shimmer_effects.dart';
import 'package:flutter/cupertino.dart';

class ContentGridProfileShimmer extends StatelessWidget {
  const ContentGridProfileShimmer ({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 40 - 20) / 3;
    final imageHeight = cardWidth * 1.2;
    return CbGridLayout(
      mainAxisExtent: 200,
      itemCount: 6, 
      columnCount: 3,
      crossSpacing: 5,
      itemBuilder: (_, __) => Column(
        children: [
          CbShimmerEffects(
            width: double.infinity,
            height: imageHeight,  
            radius: 16,
          ),
          const SizedBox(height: CbSizes.sm,),

          CbShimmerEffects(width: double.infinity, height: cardWidth * 0.12),
          const SizedBox(height: CbSizes.sm,),
          
          CbShimmerEffects(width: 80, height: cardWidth * 0.08),
        ],
      )
    );
  }
}