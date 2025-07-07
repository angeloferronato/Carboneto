import 'package:carboneto/common/widgets/texts/section_heading.dart';
import 'package:carboneto/features/authentication/screens/onboarding/widgets/top_logo.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:carboneto/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:carboneto/features/authentication/controllers/login/login_controller.dart';

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
    final controller = Get.put(LoginController());
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
                const SizedBox(
                  height: CbSizes.spaceBtwItems * 1.5,
                ),
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
                const SizedBox(
                  height: CbSizes.spaceBtwItems * 2.5,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
                  child: FocusedTextField(
                    hintText: 'O que você quer treinar?',
                    prefixIcon: Icon(Iconsax.search_normal_1),
                    controller: controller.email,
                  ),
                ),
                const SizedBox(
                  height: CbSizes.spaceBtwItems * 2,
                ),
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .apply(color: CbColors.white, fontSizeFactor: 1.3),
                        children: [
                          const TextSpan(text: 'Categorias '),
                          TextSpan(
                            text: 'em destaque',
                            style: TextStyle(
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: [
                                    Color(0xFF0047FF),
                                    Color(0xFF1B5FF3),
                                    Color(0xFF5386F4),
                                    Color(0xFF6FB9FF),
                                    Color(0xFFA3D4FF),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(Rect.fromLTWH(0, 0, 600, 0)),
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(
                  height: CbSizes.spaceBtwItems,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                12), // ou o valor que quiser
                            child: Image(
                              image:
                                  AssetImage(CbImages.thumbnailTrainingExample),
                              width: 82,
                              height: 82,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            '3pts',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                12), // ou o valor que quiser
                            child: Image(
                              image:
                                  AssetImage(CbImages.thumbnailTrainingExample),
                              width: 82,
                              height: 82,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            'Floater',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                12), // ou o valor que quiser
                            child: Image(
                              image:
                                  AssetImage(CbImages.thumbnailTrainingExample),
                              width: 82,
                              height: 82,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            'Enterrada',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                12), // ou o valor que quiser
                            child: Image(
                              image:
                                  AssetImage(CbImages.thumbnailTrainingExample),
                              width: 82,
                              height: 82,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            'Crossover',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: CbSizes.spaceBtwItems * 1.6,
                ),
                SubCategoryList(
                  title: 'Arremesso',
                  data: arremessoData,
                ),
                const SizedBox(
                  height: CbSizes.spaceBtwItems * 1.6,
                ),
                SubCategoryList(
                  title: 'Finalização',
                  data: arremessoData,
                ),
                const SizedBox(
                  height: CbSizes.spaceBtwItems * 1.6,
                ),
                SubCategoryList(
                  title: 'Controle de Bola',
                  data: arremessoData,
                ),
                const SizedBox(
                  height: CbSizes.spaceBtwItems * 2,
                ),
                SubCategoryList(
                  title: 'Defesa',
                  data: arremessoData,
                ),
                const SizedBox(
                  height: CbSizes.spaceBtwItems * 2,
                ),
                SubCategoryList(
                  title: 'Atleticismo',
                  data: arremessoData,
                ),
                const SizedBox(
                  height: CbSizes.spaceBtwItems * 2,
                ),
                SubCategoryList(
                  title: 'QI de Basquete',
                  data: arremessoData,
                ),
                const SizedBox(
                  height: CbSizes.spaceBtwItems * 2,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: CbSizes.defaultSpace),
                      child: CbSectionHeading(
                        title: 'Explorar tudo',
                        showButton: false,
                        onPressed: () {},
                        fontSize: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Wrap(
                        spacing: 12, // espaçamento horizontal entre os cards
                        runSpacing: 12, // espaçamento vertical entre linhas
                        children: arremessoData.map((item) {
                          return SubcategoryCard(
                            title: item['title'] ?? '',
                            imagePath: item['image'] ?? '',
                            onTap: () {},
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 150,
                ),
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
        height: 100,
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
