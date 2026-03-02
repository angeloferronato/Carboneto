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
      Get.to(TagSearchScreen(
        tag: controllerTag,
      ));
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
                    return Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0x31467CB8),
                            Color(0x61152E42),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: const Color(0xFF223142),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            tag,
                            style: TextStyle(
                              color:
                                  isDarkTheme ? CbColors.white : CbColors.black,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () => controller.onTagChanged(tag),
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: CbColors.accent,
                            ),
                          ),
                        ],
                      ),
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
