import 'package:carboneto/common/widgets/texts/section_heading.dart';
import 'package:carboneto/features/explore/screens/category_screen/category_screen.dart';
import 'package:carboneto/features/explore/screens/search/widgets/subcategory_card.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubCategoryContainer extends StatelessWidget {
  final String title;
  final List<Map<String, String>> data;

  const SubCategoryContainer({
    super.key,
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CbSectionHeading(
          title: title,
          showButton: false,
          onPressed: () => {},
          fontSize: 1.3,
        ),
        const SizedBox(
          height: CbSizes.spaceBtwItems,
        ),
        SizedBox(
          height: 100,
          width: CbHelperFunctions.screenWidth(),
          child: SubcategoryList(data: data),
        ),
      ],
    );
  }
}

class SubcategoryList extends StatelessWidget {
  const SubcategoryList({super.key, required this.data});
  final List<Map<String, String>> data;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      // padding: EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
      itemBuilder: (_, index) {
        final subcategory = data[index];
        final subcategoryTitle = subcategory['title'];
        return Row(
          children: [
            SubcategoryCard(
              title: subcategoryTitle!, // Passando o título
              imagePath: subcategory['image']!,
              onTap: () {
                Get.to(() => CategoryScreen(
                      title: subcategoryTitle,
                    ));
              },
            ),
            if (index < data.length - 1) const SizedBox(width: 15),
          ],
        );
      },
      scrollDirection: Axis.horizontal,
    );
  }
}
