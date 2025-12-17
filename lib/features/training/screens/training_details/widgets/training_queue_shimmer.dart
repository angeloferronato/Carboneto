import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/loading_effects/shimmer_effects.dart';
import 'package:flutter/cupertino.dart';

class TrainingQueueShimmer extends StatelessWidget {
  const TrainingQueueShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: CbSizes.spaceBtwItems),
        child: CbShimmerEffects(width: double.infinity, height: 70, radius: CbSizes.defaultSpace,),
      ), 
      itemCount: 6,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }
}