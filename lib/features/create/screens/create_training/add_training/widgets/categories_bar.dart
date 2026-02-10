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
    // Tenta encontrar ou cria um novo com as categorias customizadas
    final controller = Get.put(
        CategoriesController(initialCategories: customCategories),
        tag: controllerTag);
    final bool isDarkMode = CbHelperFunctions.isDarkMode(context); 
    // Se tiver callback, registra
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
                  : Row(children: const [FilterButton(), SizedBox(width: 8)]),
              ...controller.categories.map((category) {
                final isSelected = controller.isSelected(category);

                final isSpecial = category == 'For you';

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: RawChip(
                      labelPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isSpecial) 
                            Icon(Icons.auto_awesome,
                                size: 16, color: isDarkMode ? (CbColors.white) : (
                              isSelected
                                ? CbColors.white
                                : CbColors.dark
                            )),
                          if (isSpecial) const SizedBox(width: 4),
                          Text(
                            category,
                            style: TextStyle(
                              color: isDarkMode ? (
                                isSelected
                                  ? Colors.white
                                  : CbColors.white.withValues(alpha: 0.9)
                              ) : (
                                isSelected
                                  ? CbColors.white
                                  : CbColors.dark.withValues(alpha: 0.9)
                              ),
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                        ],
                      ),
                      selected: isSelected,
                      selectedColor: CbColors.primary,
                      backgroundColor: isDarkMode ? CbColors.dark : CbColors.grey,
                      showCheckmark: false,
                      side: BorderSide(
                      color: isDarkMode ? (
                      isSelected
                        ? CbColors.dark
                        : CbColors.white.withValues(alpha: 0.1)
                      ) : (
                        isSelected
                        ? CbColors.white
                        : CbColors.dark.withValues(alpha: 0.05)
                      ),
                      width: 1.2,
                    ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      onSelected: (_) => controller.selectCategory(category),
                    ),
                  ),
                );
              }),
            ],
          ),
        ));
  }
}
