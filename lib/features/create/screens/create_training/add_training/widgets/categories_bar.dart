import 'package:carboneto/common/widgets/buttons/filter_button.dart';
import 'package:carboneto/features/create/controllers/categories_controller.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carboneto/utils/constants/colors.dart';

class CategoriesBar extends StatelessWidget {
  const CategoriesBar({super.key, required this.controllerTag, this.hideFilterBtn = false});

  final String controllerTag;
  final bool hideFilterBtn;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoriesController(), tag: controllerTag);
    final bool isDarkMode = CbHelperFunctions.isDarkMode(context); 
    return Obx(() => SingleChildScrollView(
      controller: controller.scrollController,
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: CbSizes.md),
        child: Row(
          children: [
            hideFilterBtn? SizedBox()
            : FilterButton(),
            ...controller.categories.map((category) {
              final isSelected = controller.isSelected(category);
              final isForYou = category == 'For you';
        
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: RawChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isForYou)
                          Icon(
                            Icons.auto_awesome,
                            size: 16,
                            color: isDarkMode ? (CbColors.white) : (
                              isSelected
                                ? CbColors.white
                                : CbColors.dark
                            )
                          ),
                        if (isForYou) const SizedBox(width: 4),
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
      ),
    ));
  }
}
