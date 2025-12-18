import 'package:carboneto/features/explore/controllers/explorer_controller.dart';
import 'package:carboneto/features/explore/screens/search/widgets/subcategory_list.dart';
import 'package:carboneto/features/explore/screens/widgets/gradient_title.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class FeaturedCategories extends StatelessWidget {
  const FeaturedCategories({super.key, required this.controller});
  final ExploreController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        GradientTitle(title: 'Categorias em destaque'),

        const SizedBox(height: CbSizes.spaceBtwItems),

        Obx(() {
          if (controller.featuredSubcategories.isEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
              child: const Center(
                  child: Text('Nenhuma categoria em destaque encontrada.')),
            );
          }

          return SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 1,
              itemBuilder: (context, index) {
                final data = controller.featuredSubcategories;
                return SubcategoryList(data: data);
              },
            ),
          );
        }),
      ],
    );
  }
}