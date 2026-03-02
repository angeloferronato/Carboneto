import 'package:carboneto/common/widgets/buttons/filter_button.dart';
// Importe o controller atualizado
import 'package:carboneto/features/create/controllers/categories_controller.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carboneto/utils/constants/colors.dart';

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
    final bool isDarkMode = CbHelperFunctions.isDarkMode(context);

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
                final isSpecial = category == 'For you';

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => controller.selectCategory(category),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? null
                            : const LinearGradient(
                                colors: [
                                  Color(0x31467CB8),
                                  Color(0x61152E42),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                        color: isSelected ? CbColors.primary : null,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : const Color(0xFF223142),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isSpecial) ...[
                            Icon(
                              Icons.auto_awesome,
                              size: 16,
                              color: isDarkMode
                                  ? CbColors.white
                                  : isSelected
                                      ? CbColors.white
                                      : CbColors.dark,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            category,
                            style: TextStyle(
                              color: isDarkMode
                                  ? (isSelected
                                      ? Colors.white
                                      : CbColors.white.withValues(alpha: 0.9))
                                  : (isSelected
                                      ? CbColors.white
                                      : CbColors.dark.withValues(alpha: 0.9)),
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ));
  }
}