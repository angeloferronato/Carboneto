import 'package:carboneto/features/training/screens/home/widgets/home_training_shimmer.dart';
import 'package:carboneto/utils/loading_effects/shimmer_effects.dart';
import 'package:flutter/material.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 3,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) => Column(
              children: [
                Align(
                    alignment: AlignmentGeometry.centerLeft,
                    child: CbShimmerEffects(width: 160, height: 26)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 230,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 2,
                    shrinkWrap: true,
                    itemBuilder: (_, __) => HomeTrainingShimmer(),
                    scrollDirection: Axis.horizontal,
                  ),
                )
              ],
            ));
  }
}
