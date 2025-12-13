import 'package:carboneto/features/library/screens/widgets/section_main.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';


class LibrarySection extends StatelessWidget {
  const LibrarySection({
    super.key,
    required this.title,
    required this.icon,
    this.actionBtn,
    this.showActionBtn = false,
    this.itemCount = 5,
    required this.itemBuilder,
  });
  final String title;
  final IconData? icon;
  final dynamic actionBtn;
  final bool showActionBtn;
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionMain(
          title: title,
          icon: icon,
          actionBtn: actionBtn,
          showActionBtn: showActionBtn,
        ),
        SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 200, // define a height for horizontal list
          child: ListView.separated(
            padding: EdgeInsets.only(left: CbSizes.defaultSpace),
            scrollDirection: Axis.horizontal,
            itemCount: itemCount, // however many trainings you want
            itemBuilder:  itemBuilder,
            separatorBuilder: (context, index) =>
                const SizedBox(width: 10), // 👈 spacing between cards
          ),
        ),
      ],
    );
  }
}