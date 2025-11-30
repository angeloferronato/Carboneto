import 'package:carboneto/features/create/controllers/tag_controller.dart';
import 'package:carboneto/features/create/screens/create_training/tag_search/tag_search_screen.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TagSelector extends StatelessWidget {
  const TagSelector({super.key, required this.controllerTag});

  final String controllerTag;

  @override
  Widget build(BuildContext context) {
    void openTagSearch() {
      Get.to(TagSearchScreen(tag: controllerTag,));
    }

    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.put(TagController(), tag: controllerTag);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.selectedTags.map((tag) {
                return InputChip(
                  label: Text(
                    tag,
                    style: TextStyle(
                      color: (isDarkTheme
                          ? CbColors.white
                          : CbColors.black),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Plus Jakarta Sans'
                    ),
                  ),
                  backgroundColor: CbColors.dark,
                  shape: StadiumBorder(
                    side: BorderSide(color: CbColors.primary),
                  ),
                  onDeleted: () => controller.onTagChanged(tag),
                  deleteIconColor: CbColors.accent,
                );
              }).toList(),
            )),
          ),
          IconButton(
            onPressed: openTagSearch,
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: CbColors.primary,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}
