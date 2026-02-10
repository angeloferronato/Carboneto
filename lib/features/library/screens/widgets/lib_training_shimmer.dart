import 'package:carboneto/utils/loading_effects/shimmer_effects.dart';
import 'package:flutter/material.dart';

class CreatedTrainingShimmerLoading extends StatelessWidget {
  const CreatedTrainingShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: CbShimmerEffects(width: 150, height: 20, radius: 5),
        ),
        SizedBox(
          height: 190, 
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(width: 15),
            itemBuilder: (_, __) => const SizedBox(
              width: 170, 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CbShimmerEffects(width: 170, height: 125, radius: 12),
                  SizedBox(height: 8),
                  CbShimmerEffects(width: 140, height: 15, radius: 4),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CbShimmerEffects(width: 15, height: 15, radius: 100),
                          SizedBox(width: 5),
                          CbShimmerEffects(width: 60, height: 10, radius: 4),
                        ],
                      ),
                      CbShimmerEffects(width: 30, height: 10, radius: 4),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}