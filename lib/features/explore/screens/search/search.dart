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

class CbTrainingCategories {
  // Define a estrutura para uma categoria (título e lista de subcategorias)
  static Map<String, dynamic> _createCategory(String title, List<Map<String, String>> subcategories) {
    return {
      'title': title,
      'subcategories': subcategories,
    };
  }

  static final List<Map<String, String>> shooting = [
    {'title': '3pts', 'image': CbImages.ar3ptss},
    {'title': 'Arremesso em Movimento', 'image': CbImages.arremm},
    {'title': 'Arremesso sob Pressão', 'image': CbImages.arsobp},
    {'title': 'Fadeway', 'image': CbImages.fade},
    {'title': 'Lance Livre', 'image': CbImages.lancel},
    {'title': 'Mid-Range', 'image': CbImages.midran},
    {'title': 'Step-Back', 'image': CbImages.stepback},
  ];

  static final List<Map<String, String>> finishing = [
    {'title': 'Bandeja Simples', 'image': CbImages.bandsim},
    {'title': 'Enterrada', 'image': CbImages.dunk},
    {'title': 'Floater', 'image': CbImages.floater},
    {'title': 'Euro-Step', 'image': CbImages.eustep},
    {'title': 'Finger Roll', 'image': CbImages.fingerrol},
    {'title': 'Layup em Velocidade', 'image': CbImages.layv},
    {'title': 'Reverse Layup', 'image': CbImages.reverslay},
  ];

  // Lista principal que agrupa todas as categorias para iteração
  static final List<Map<String, dynamic>> allCategories = [
    _createCategory('Arremesso', shooting),
    _createCategory('Finalização', finishing),
  ];
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
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
                const SizedBox(
                  height: CbSizes.spaceBtwItems * 2,
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
                    // controller:,
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
                            borderRadius: BorderRadius.circular(12), // ou o valor que quiser
                            child: Image(
                              image:
                                  AssetImage(CbImages.trainingExample),
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
                                  AssetImage(CbImages.trainingImageExample),
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
                  data: CbTrainingCategories.shooting,
                ),
                const SizedBox(
                  height: CbSizes.spaceBtwItems * 1.6,
                ),
                SubCategoryList(
                  title: 'Finalização',
                  data: CbTrainingCategories.finishing,
                ),
                const SizedBox(
                  height: CbSizes.spaceBtwItems * 1.6,
                ),
                SubCategoryList(
                  title: 'Controle de Bola',
                  data: CbTrainingCategories.shooting,
                ),
                const SizedBox(
                  height: CbSizes.spaceBtwItems * 2,
                ),
                SubCategoryList(
                  title: 'Defesa',
                  data: CbTrainingCategories.shooting,
                ),
                const SizedBox(
                  height: CbSizes.spaceBtwItems * 2,
                ),
                SubCategoryList(
                  title: 'Atleticismo',
                  data: CbTrainingCategories.shooting,
                ),
                const SizedBox(
                  height: CbSizes.spaceBtwItems * 2,
                ),
                SubCategoryList(
                  title: 'QI de Basquete',
                  data: CbTrainingCategories.shooting,
                ),
                const SizedBox(
                  height: CbSizes.spaceBtwItems * 2,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        CbSectionHeading(
                          title: 'Explorar tudo',
                          showButton: false,
                          onPressed: () {},
                          fontSize: 1.3,
                        ),
                      const SizedBox(height: CbSizes.spaceBtwItems,),
                      GridView.builder(
                            itemCount: CbTrainingCategories.shooting.length,
                            padding: EdgeInsets.all(0),
                            shrinkWrap: true, // permite GridView dentro de SingleChildScrollView
                            physics: const NeverScrollableScrollPhysics(), // desativa scroll interno
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 20,
                              childAspectRatio: 175 / 100,
                            ),
                            itemBuilder: (context, index) {
                              final item = CbTrainingCategories.shooting[index];
                              return Center(
                                child: SubcategoryCard(
                                  title: item['title']!,
                                  imagePath: item['image']!,
                                  onTap: () {
                                    debugPrint('Clicou em ${item['title']}');
                                  },
                                ),
                              );
                            },
                        ),
                    ],
                  ),
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
            padding: EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
            itemBuilder: (_, index) {
              final subcategory = data[index];
              return Row( // Use um Row para conter o card e o SizedBox
                children: [
                  SubcategoryCard( // Seu item da lista
                    title: subcategory['title']!,
                    imagePath: subcategory['image']!,
                  ),
                  // Adiciona um SizedBox apenas se não for o último item
                  if (index < data.length - 1)
                    const SizedBox(width: 15), // O 'gap' desejado (por exemplo, 20 pixels)
                ],
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
        // margin: const EdgeInsets.only(right: 12),
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
