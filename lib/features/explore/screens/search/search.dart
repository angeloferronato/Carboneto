import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/searchinput/search_input.dart';
import 'package:carboneto/common/widgets/texts/section_heading.dart';
import 'package:carboneto/features/explore/controllers/explorer_controller.dart';
import 'package:carboneto/features/explore/screens/category_screen/category_screen.dart';
import 'package:carboneto/features/explore/screens/search/widgets/subcategory_card.dart';
import 'package:carboneto/features/explore/screens/search/widgets/subcategory_list.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inicia o ExploreController
    final ExploreController controller = Get.put(ExploreController());

    return Scaffold(
      extendBody: true,
      appBar: CbAppBar(
        title: Text(
          'Explorar',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 33,
                fontWeight: FontWeight.w700,
              ),
        ),
        showBackArrow: false,
      ),
      body: MediaQuery.removePadding(
        context: context,
        removeBottom: true,

        // SingleChildScrollView foi mantido para o caso do conteúdo
        // ficar maior que a tela após o loading
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: CbSizes.defaultSpace),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- CABEÇALHO E PESQUISA (Aparecem instantaneamente) ---
                SearchInput(
                  placeholder: 'O que você quer treinar?',
                ),
                const SizedBox(
                  height: CbSizes.spaceBtwItems * 2,
                ),

                Obx(() {
                  // SE ESTIVER CARREGANDO: Mostra um loader único
                  if (controller.isLoading.value) {
                    return const Padding(
                      // Adiciona um padding para "centralizar" o loader
                      // na área visível abaixo da pesquisa
                      padding: EdgeInsets.only(top: 120),
                      child: Center(
                        child: CircularProgressIndicator(
                          // Usa o azul principal do seu gradiente
                          color: CbColors.primary,
                        ),
                      ),
                    );
                  }

                  // SE JÁ CARREGOU: Mostra todo o seu conteúdo
                  else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Título "Categorias em destaque" ---
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: CbSizes.defaultSpace),
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .apply(
                                        color: CbColors.white,
                                        fontSizeFactor: 1.3),
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
                                        ).createShader(
                                            Rect.fromLTWH(0, 0, 600, 0)),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(
                          height: CbSizes.spaceBtwItems,
                        ),

                        // --- Carrossel "Categorias em destaque" ---
                        Obx(() {
                          // A verificação de isLoading foi removida daqui
                          if (controller.featuredSubcategories.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: CbSizes.defaultSpace),
                              child: const Center(
                                  child: Text(
                                      'Nenhuma categoria em destaque encontrada.')),
                            );
                          }

                          return SizedBox(
                            height: 100,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.featuredSubcategories.length,
                              padding: EdgeInsets.symmetric(
                                horizontal: CbSizes.defaultSpace,
                              ),
                              separatorBuilder: (_, __) => const SizedBox(width: 15),
                              itemBuilder: (context, index) {
                                final item = controller.featuredSubcategories[index];

                                final String title = item['title'] as String;
                                final String imagePath = item['image'] as String;

                                return SubcategoryCard(
                                  title: title,
                                  imagePath: imagePath,
                                  onTap: () {
                                    Get.to(() => CategoryScreen(
                                          title: 'TITULO AQUI'
                                    ));
                                  },
                                );
                              },
                            ),
                          );
                        }),

                        // --- Listas de Categorias e "Explorar Tudo" ---
                        Padding(
                          padding:
                              const EdgeInsets.only(left: CbSizes.defaultSpace),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // --- Listas dinâmicas (Arremesso, etc) ---
                              Obx(() {
                                // A verificação de isLoading foi removida daqui
                                if (controller.allCategories.isEmpty) {
                                  return const SizedBox.shrink();
                                }

                                return ListView.builder(
                                  itemCount: controller.allCategories.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (_, index) {
                                    final category =
                                        controller.allCategories[index];
                                    final String title = category['title'];
                                    final List<Map<String, String>> data =
                                        List<Map<String, String>>.from(
                                            category['subcategories']);

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: CbSizes.spaceBtwItems * 1.6),
                                      child: SubCategoryList(
                                        title: title,
                                        data: data,
                                      ),
                                    );
                                  },
                                );
                              }),

                              // --- Título "Explorar tudo" ---
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
                                  return const Center(
                                      child: Text('Nenhum item encontrado.'));
                                }

                                return Padding(
                                  padding: EdgeInsets.only(
                                      right: CbSizes.defaultSpace),
                                  child: GridView.builder(
                                    itemCount:
                                        controller.allSubcategories.length,
                                    padding: EdgeInsets.all(0),
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 15,
                                      mainAxisSpacing: 20,
                                      childAspectRatio: 175 / 100,
                                    ),
                                    itemBuilder: (context, index) {
                                      final item =
                                          controller.allSubcategories[index];
                                      return Center(
                                        child: SubcategoryCard(
                                          title: item['title']!,
                                          imagePath: item['image']!,
                                          onTap: () {
                                            Get.to(() => CategoryScreen(
                                                  title: 'TITULO AQUI',
                                                ));
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 150,
                        ),
                      ],
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
