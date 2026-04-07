import 'package:carboneto/common/widgets/buttons/filter_button.dart';
import 'package:carboneto/common/widgets/chips/cb_chip.dart';
import 'package:carboneto/features/create/controllers/categories_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesBar extends StatelessWidget {
  const CategoriesBar({
    super.key,
    required this.controllerTag,
    this.hideFilterBtn = false,
    this.customCategories,
    this.onSelect,
  });

  final String controllerTag;
  final bool hideFilterBtn;
  final List<String>? customCategories;
  final Function(String)? onSelect;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
        CategoriesController(initialCategories: customCategories),
        tag: controllerTag);

    if (onSelect != null) {
      controller.onCategorySelected = onSelect;
    }

    return Obx(() => SingleChildScrollView(
          controller: controller.scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              hideFilterBtn
                  ? const SizedBox()
                  : const Row(children: [FilterButton(), SizedBox(width: 8)]),
              ...controller.categories.map((category) {
                final isSelected = controller.isSelected(category);

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CbChip(
                    label: category, 
                    isSelected: isSelected, 
                    onTap: () => controller.selectCategory(category)
                  )
                );
              }),
            ],
          ),
        ));
  }
}
