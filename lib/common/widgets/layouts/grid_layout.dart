import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CbGridLayout extends StatelessWidget {
  const CbGridLayout({
    super.key, required this.itemCount, this.crossSpacing = 12, this.mainAxisExtent = 288, required this.itemBuilder, this.columnCount = 2
  });

  final int itemCount, columnCount;
  final double mainAxisExtent, crossSpacing;
  final Widget? Function(BuildContext, int) itemBuilder;


  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(top: 20),
      itemCount: itemCount,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: crossSpacing,
        mainAxisExtent: mainAxisExtent
      ),
      itemBuilder: itemBuilder,
    );
  }
}