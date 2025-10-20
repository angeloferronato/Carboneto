import 'package:carboneto/features/create/screens/create_training/controllers/create_training_controller.dart';
import 'package:carboneto/features/create/screens/create_training/tag_search/tag_search_screen.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TagSelector extends StatelessWidget {
  TagSelector({super.key});

  final controller = Get.find<CreateTrainingController>();

  void _openTagSearch() {
    Get.to(() => const TagSearchScreen());
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

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
                      onDeleted: () => controller.removeTag(tag),
                      deleteIconColor: CbColors.accent,
                    );
                  }).toList(),
                )),
          ),
          IconButton(
            onPressed: _openTagSearch,
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
