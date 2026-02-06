import 'package:carboneto/common/widgets/buttons/filter_button.dart';
import 'package:carboneto/features/create/controllers/categories_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carboneto/utils/constants/colors.dart';

class CategoriesBar extends StatelessWidget {
  const CategoriesBar(
      {super.key, required this.controllerTag, this.hideFilterBtn = false});

  final String controllerTag;
  final bool hideFilterBtn;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoriesController(), tag: controllerTag);
    return Obx(() => SingleChildScrollView(
          controller: controller.scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              hideFilterBtn? SizedBox()
              : FilterButton(),
              ...controller.categories.map((category) {
                final isSelected = controller.isSelected(category);
                final isForYou = category == 'For you';

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: RawChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isForYou)
                            const Icon(
                              Icons.auto_awesome,
                              size: 16,
                              color: Colors.white,
                            ),
                          if (isForYou) const SizedBox(width: 4),
                          Text(
                            category,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : CbColors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                        ],
                      ),
                      selected: isSelected,
                      selectedColor: CbColors.primary,
                      backgroundColor: CbColors.dark,
                      side: BorderSide(
                        color: isSelected
                            ? CbColors.dark
                            : CbColors.white.withValues(alpha: 0.1),
                        width: 1.2,
                      ),
                      onSelected: (_) => controller.selectCategory(category),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      showCheckmark: false,
                    ),
                  ),
                );
              }),
            ],
          ),
        ));
  }
}
