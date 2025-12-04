import 'package:cached_network_image/cached_network_image.dart';
import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/desenvolvimento.dart';
import 'package:carboneto/common/widgets/texts/section_heading.dart';
import 'package:carboneto/features/explore/controllers/explorer_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

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
          style: TextStyle(
            fontSize: 33,
            fontWeight: FontWeight.w700,
            fontFamily: 'Plus Jakarta Sans',
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
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
                  child: FocusedTextField(
                    hintText: 'O que você quer treinar?',
                    prefixIcon: Icon(
                      Iconsax.search_normal_1,
                      size: 20,
                    ),
                  ),
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
                        // O Obx interno é mantido para reagir à lista
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
                            height: 100, // Altura do SubcategoryCard
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  controller.featuredSubcategories.length,
                              padding: EdgeInsets.symmetric(
                                  horizontal: CbSizes.defaultSpace),
                              itemBuilder: (context, index) {
                                final item =
                                    controller.featuredSubcategories[index];
                                return Row(
                                  children: [
                                    SubcategoryCard(
                                      title: item['title']!,
                                      imagePath: item['image']!,
                                      onTap: () {
                                        Get.to(() => DesenvolvimentoScreen());
                                      },
                                    ),
                                    if (index <
                                        controller
                                                .featuredSubcategories.length -
                                            1)
                                      const SizedBox(width: 15),
                                  ],
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
                                            Get.to(() => DesenvolvimentoScreen());
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
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            // padding: EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
            itemBuilder: (_, index) {
              final subcategory = data[index];
              return Row(
                children: [
                  SubcategoryCard(
                    title: subcategory['title']!, // Passando o título
                    imagePath: subcategory['image']!,
                    onTap: () {
                      Get.to(() => DesenvolvimentoScreen());
                      // Aqui você pode navegar para a tela de treinos dessa subcategoria
                      // Get.to(() => TrainingListScreen(category: subcategory['title']!));
                    },
                  ),
                  if (index < data.length - 1) const SizedBox(width: 15),
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
  final String imagePath; // Agora esta string é uma URL
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        // ClipRRect é necessário para o CachedNetworkImage respeitar o borderRadius
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: imagePath,
            fit: BoxFit.cover,
            // Placeholder enquanto carrega
            placeholder: (context, url) => Container(
              color: Colors.grey[300], // Um placeholder cinza
            ),
            // Widget em caso de erro
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[100],
              child: Icon(Icons.error, color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
