import 'package:carboneto/features/create/screens/create_training/add_training/widgets/categories_bar.dart';
import 'package:carboneto/features/explore/controllers/search_controller.dart';
import 'package:carboneto/features/explore/screens/search_result/models/search_filters.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class SearchCategoriesBar extends StatelessWidget {
  const SearchCategoriesBar({
    super.key,
    required this.controller,
  });

  final CbSearchController controller;

  static final List<String> _categories = [
    'Melhores',
    'Treinos',
    'Usuários',
    'Exercícios',
    ...CategoryMapper.mainCategories,
  ];

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(
        left: CbSizes.defaultSpace,
        top: 15,
        bottom: 10,
      ),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            CategoriesBar(
              controllerTag: 'search',
              customCategories: _categories,
              hideFilterBtn: true,
              onSelect: controller.setCategory,
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
