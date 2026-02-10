import 'package:carboneto/utils/loading_effects/shimmer_effects.dart';
import 'package:flutter/material.dart';

class HistoryShimmerLoading extends StatelessWidget {
  const HistoryShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: CbShimmerEffects(width: 100, height: 20, radius: 5),
        ),
        SizedBox(
          height: 160, 
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(width: 15),
            itemBuilder: (_, __) => const SizedBox(
              width: 165, 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CbShimmerEffects(width: 165, height: 100, radius: 12),
                  SizedBox(height: 8),
                  CbShimmerEffects(width: 120, height: 15, radius: 4),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      CbShimmerEffects(width: 18, height: 18, radius: 100), 
                      SizedBox(width: 5),
                      CbShimmerEffects(width: 80, height: 12, radius: 4), 
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