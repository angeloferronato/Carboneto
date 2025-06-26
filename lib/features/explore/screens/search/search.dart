import 'package:carboneto/common/widgets/texts/section_heading.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  final List<Map<String, String>> arremessoData = [
    {
      'title': 'Controle de bola',
      'image': CbImages.ballHandle,
    },
    {
      'title': 'Lance Livre',
      'image': CbImages.freeThrow,
    },
    {
      'title': 'Controle de bola',
      'image': CbImages.ballHandle,
    },
    {
      'title': 'Lance Livre',
      'image': CbImages.freeThrow,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = CbHelperFunctions.isDarkMode(context);
    return Scaffold(
      extendBody: true,
      body: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: CbSizes.defaultSpace),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
                  child: Text(
                    'Explorar',
                    style: TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: CbSizes.spaceBtwItems,),
                SubCategoryList(
                  title: 'Arremesso',
                  data: arremessoData,
                ),
                const SizedBox(height: CbSizes.spaceBtwItems,),
                SubCategoryList(
                  title: 'Finalização',
                  data: arremessoData,
                ),
                const SizedBox(height: CbSizes.spaceBtwItems,),
                SubCategoryList(
                  title: 'Controle de Bola',
                  data: arremessoData,
                ),
                const SizedBox(height: CbSizes.spaceBtwItems,),
                SubCategoryList(
                  title: 'Defesa',
                  data: arremessoData,
                ),
                const SizedBox(height: CbSizes.spaceBtwItems,),
                SubCategoryList(
                  title: 'Atleticismo',
                  data: arremessoData,
                ),
                const SizedBox(height: CbSizes.spaceBtwItems,),
                SubCategoryList(
                  title: 'QI de Basquete',
                  data: arremessoData,
                ),
                const SizedBox(height: 150,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubCategoryList extends StatelessWidget {
  final String title;
  final List<Map<String, String>> data;

  const SubCategoryList({
    super.key,
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
            child: CbSectionHeading(
              title: title,
              showButton: false,
              onPressed: () => {},
              fontSize: 1.3,
            )),
        const SizedBox(
          height: CbSizes.spaceBtwItems,
        ),
        SizedBox(
          height: 100,
          width: CbHelperFunctions.screenWidth(),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            padding: EdgeInsets.only(left: CbSizes.md),
            itemBuilder: (_, index) {
              final subcategory = data[index];
              return SubcategoryCard(
                title: subcategory['title']!,
                imagePath: subcategory['image']!,
              );
            },
            scrollDirection: Axis.horizontal,
          ),
        ),
      ],
    );
  }
}

class SubcategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback? onTap;

  const SubcategoryCard({
    super.key,
    required this.title,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 175,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
