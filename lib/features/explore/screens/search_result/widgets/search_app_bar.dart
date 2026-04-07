import 'package:carboneto/common/widgets/buttons/filter_button.dart';
import 'package:carboneto/common/widgets/searchinput/search_input.dart';
import 'package:carboneto/features/explore/controllers/search_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchAppBar extends StatelessWidget {
  const SearchAppBar({
    super.key,
    required this.controller,
    required this.onBack,
  });

  final CbSearchController controller;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: CbColors.dark,
      elevation: 0,
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
        child: Row(
          children: [
            GestureDetector(
              onTap: onBack,
              child: const Icon(Icons.arrow_back),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SearchInput(
                placeholder: 'Pesquisar',
                controller: controller.searchTextController,
                onSubmitted: controller.search,
                onSearchPressed: () =>
                    controller.search(controller.searchTextController.text),
              ),
            ),
            const SizedBox(width: 12),
            Obx(() => FilterButton(
                  currentFilters: controller.activeFilters.value,
                  onFilterApplied: controller.applyFilters,
                )),
          ],
        ),
      ),
    );
  }
}
