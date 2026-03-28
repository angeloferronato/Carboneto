import 'package:carboneto/features/explore/controllers/search_controller.dart';
import 'package:carboneto/features/explore/screens/search_result/widgets/search_empty_state.dart';
import 'package:carboneto/features/explore/screens/search_result/widgets/search_item.dart';
import 'package:carboneto/features/explore/screens/search_result/widgets/search_shimmer_list.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchResultsBody extends StatelessWidget {
  const SearchResultsBody({
    super.key,
    required this.controller,
  });

  final CbSearchController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) return const SearchShimmerList();

      final items = _buildItems();

      if (items.isEmpty) return const SearchEmptyState();

      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => items[index].build(context, controller),
            childCount: items.length,
          ),
        ),
      );
    });
  }

  List<SearchItem> _buildItems() {
    final isMelhores = controller.activeTab.value == 'Melhores';
    final hasUsers     = controller.userResults.isNotEmpty;
    final hasTrainings = controller.results.isNotEmpty;
    final hasExercises = !isMelhores && controller.exerciseResults.isNotEmpty;

    if (!hasUsers && !hasTrainings && !hasExercises) return const [];

    return [
      for (final u in controller.userResults) SearchItem.user(u),
      for (final t in controller.results)     SearchItem.training(t),
      if (hasExercises) ...[
        if (hasTrainings || hasUsers) SearchItem.sectionHeader('Exercícios'),
        for (final e in controller.exerciseResults) SearchItem.exercise(e),
      ],
    ];
  }
}
