import 'package:carboneto/utils/loading_effects/shimmer_effects.dart';
import 'package:flutter/material.dart';

class ContentListShimmer extends StatelessWidget {
  const ContentListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: List.generate(2, (_) => const _ResultWidgetShimmer()),
      ),
    );
  }
}

class _ResultWidgetShimmer extends StatelessWidget {
  const _ResultWidgetShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ResultMain thumbnail
        CbShimmerEffects(
          width: double.infinity,
          height: 180,
          radius: 12,
        ),
        const SizedBox(height: 10),

        // Row: user picture + title + level
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // UserPicture
                CbShimmerEffects(width: 23, height: 23, radius: 100),
                const SizedBox(width: 6),
                // Title
                CbShimmerEffects(width: 140, height: 12, radius: 4),
              ],
            ),
            // LevelWidget
            CbShimmerEffects(width: 40, height: 12, radius: 4),
          ],
        ),
        const SizedBox(height: 8),

        // Row: creator info + meta (duration • date • categories) + people count
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Creator avatar placeholder
                CbShimmerEffects(width: 16, height: 16, radius: 100),
                const SizedBox(width: 6),
                // Meta text
                CbShimmerEffects(width: 160, height: 10, radius: 4),
              ],
            ),
            // People count
            CbShimmerEffects(width: 35, height: 12, radius: 4),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}