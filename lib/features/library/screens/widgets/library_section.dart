import 'package:carboneto/common/widgets/result/empty_data.dart';
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
    required this.emptyData,
    required this.itemBuilder,
  });
  final String title;
  final IconData? icon;
  final dynamic actionBtn;
  final bool showActionBtn;
  final int itemCount;
  final EmptyData emptyData;
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
        if (itemCount == 0)
          emptyData
        else
          SizedBox(
            height: 200,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                overscroll: false,
              ),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                    horizontal: CbSizes.defaultSpace),
                scrollDirection: Axis.horizontal,
                physics:
                    const ClampingScrollPhysics(),
                itemCount: itemCount,
                itemBuilder: itemBuilder,
                separatorBuilder: (context, index) => const SizedBox(width: 7),
              ),
            ),
          ),
      ],
    );
  }
}
