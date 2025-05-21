import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: CbColors.grey, borderRadius: BorderRadius.circular(20)),
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: Container(
          color: CbColors.secondary,
        ),
      ),
    );
  }
}
