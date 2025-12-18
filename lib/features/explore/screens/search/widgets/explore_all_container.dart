import 'package:carboneto/common/widgets/texts/section_heading.dart';
import 'package:carboneto/features/explore/controllers/explorer_controller.dart';
import 'package:carboneto/features/explore/screens/category_screen/category_screen.dart';
import 'package:carboneto/features/explore/screens/search/widgets/subcategory_card.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreAllContainer extends StatelessWidget {
  const ExploreAllContainer({super.key, required this.controller});

  final ExploreController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
      child: Column(
        children: [
          CbSectionHeading(
            title: 'Explorar tudo',
            showButton: false,
            onPressed: () {},
            fontSize: 1.3,
          ),
      
          const SizedBox(
            height: CbSizes.spaceBtwItems,
          ),
      
          // --- Grid "Explorar tudo" ---
          Obx(() {
            // A verificação de isLoading foi removida daqui
            if (controller.allSubcategories.isEmpty) {
              return const Center(child: Text('Nenhum item encontrado.'));
            }
      
            return GridView.builder(
              itemCount: controller.allSubcategories.length,
              padding: EdgeInsets.all(0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 20,
                childAspectRatio: 175 / 100,
              ),
              itemBuilder: (context, index) {
                final subcategory = controller.allSubcategories[index];
                final subcategoryTitle = subcategory['title'];
      
                return Center(
                  child: SubcategoryCard(
                    title: subcategoryTitle!,
                    imagePath: subcategory['image']!,
                    onTap: () {
                      Get.to(() => CategoryScreen(
                            title: subcategoryTitle,
                          ));
                    },
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
