import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/loading_effects/shimmer_effects.dart';
import 'package:flutter/material.dart';

class SearchShimmerList extends StatelessWidget {
  const SearchShimmerList({super.key});

  static const int _tileCount = 6;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, __) => const _ShimmerTile(),
          childCount: _tileCount,
        ),
      ),
    );
  }
}

class _ShimmerTile extends StatelessWidget {
  const _ShimmerTile();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CbShimmerEffects(width: double.infinity, height: 180, radius: 16),
          SizedBox(height: 12),
          Row(
            children: [
              CbShimmerEffects(width: 23, height: 23, radius: 50),
              SizedBox(width: 8),
              Expanded(child: CbShimmerEffects(height: 12, width: double.infinity)),
              SizedBox(width: 8),
              CbShimmerEffects(width: 40, height: 10),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: CbShimmerEffects(height: 10, width: double.infinity)),
              SizedBox(width: 12),
              CbShimmerEffects(width: 30, height: 10),
            ],
          ),
        ],
      ),
    );
  }
}
