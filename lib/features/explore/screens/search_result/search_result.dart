import 'package:carboneto/common/widgets/buttons/filter_button.dart';
import 'package:carboneto/common/widgets/searchinput/search_input.dart';
import 'package:carboneto/features/create/screens/create_training/add_training/widgets/categories_bar.dart';
import 'package:carboneto/common/widgets/result/result_widget.dart';
import 'package:carboneto/features/training/models/creator/creator_model.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class SearchResultScreen extends StatelessWidget {
  SearchResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            floating: false,
            snap: false,
            automaticallyImplyLeading: false,
            backgroundColor: CbColors.dark,
            elevation: 0,
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: CbSizes.defaultSpace,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: SearchInput(
                      placeholder: 'treino do Steph Curry',
                      controller: TextEditingController(),
                    ),
                  ),
                  const SizedBox(width: 20),
                  FilterButton(
                    onFilterApplied: (filters) {
                      // Handle the applied filters
                      print('Filters applied: $filters');
                      // You can add your filter logic here
                      // e.g., update the results list based on filters
                    },
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              left: CbSizes.defaultSpace,
              top: 10,
              bottom: 10,
            ),
            sliver: SliverToBoxAdapter(
              child: CategoriesBar(
                controllerTag: 'For you',
              ),
            ),
          ),

          /// Results
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: CbSizes.defaultSpace,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {

                  return Container();
                },
                childCount: 5,
              ),
            ),
          ),

          /// Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 30),
          ),
        ],
      ),
    );
  }
}
