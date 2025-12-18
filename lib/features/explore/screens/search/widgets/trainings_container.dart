import 'package:carboneto/features/explore/controllers/explorer_controller.dart';
import 'package:carboneto/features/explore/screens/search/widgets/featured_categories.dart';
import 'package:carboneto/features/explore/screens/search/widgets/main_categories.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';


class TrainingsContainer extends StatelessWidget {
  const TrainingsContainer({super.key, required this.controller});
  final ExploreController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: CbSizes.defaultSpace),
      child: Column(
        children: [
          FeaturedCategories(controller: controller),
          MainCategories(controller: controller),
        ],
      ),
    );
  }
}