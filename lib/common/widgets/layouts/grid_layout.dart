import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CbGridLayout extends StatelessWidget {
  const CbGridLayout({
    super.key, required this.itemCount, this.mainAxisExtent = 288, required this.itemBuilder,
  });

  final int itemCount;
  final double? mainAxisExtent;
  final Widget? Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: itemCount,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: CbSizes.gridViewSpacing,
        crossAxisSpacing: CbSizes.gridViewSpacing,
        mainAxisExtent: mainAxisExtent
      ),
      itemBuilder: itemBuilder,
    );
  }
}