import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';


class SectionMain extends StatelessWidget {
  const SectionMain(
      {super.key,
      required this.title,
      this.icon = Icons.history,
      this.showActionBtn = false,
      this.actionBtn});

  final String title;
  final dynamic icon;
  final bool showActionBtn;
  final dynamic actionBtn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 25,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          if (showActionBtn) actionBtn,
        ],
      ),
    );
  }
}