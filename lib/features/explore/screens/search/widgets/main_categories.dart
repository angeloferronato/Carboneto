import 'package:carboneto/features/explore/controllers/explorer_controller.dart';
import 'package:carboneto/features/explore/screens/search/widgets/subcategory_list.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class MainCategories extends StatelessWidget {
  const MainCategories({super.key, required this.controller});
  final ExploreController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.allCategories.isEmpty) {
        return const SizedBox.shrink();
      }

      return ListView.builder(
        itemCount: controller.allCategories.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          final category = controller.allCategories[index];
          final String title = category['title'];
          final List<Map<String, String>> data =
              List<Map<String, String>>.from(category['subcategories']);
          return Padding(
            padding: const EdgeInsets.only(bottom: CbSizes.spaceBtwItems * 1.6),
            child: SubCategoryContainer(
              title: title,
              data: data,
            ),
          );
        },
      );
    });
  }
}