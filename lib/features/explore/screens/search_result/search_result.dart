import 'package:carboneto/features/explore/controllers/search_controller.dart';
import 'package:carboneto/features/explore/screens/search_result/widgets/search_app_bar.dart';
import 'package:carboneto/features/explore/screens/search_result/widgets/search_categories_bar.dart';
import 'package:carboneto/features/explore/screens/search_result/widgets/search_results_body.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({
    super.key,
    required this.initialQuery,
  });

  final String initialQuery;

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late final CbSearchController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(CbSearchController());
    _controller.hasSearched.value = true;
    _controller.isLoading.value = true;
    _controller.searchTextController.text = widget.initialQuery;
    _controller.activeTab.value = 'Melhores';
    _controller.selectedCategories
      ..clear()
      ..add('Melhores');
    _controller.search(widget.initialQuery);
  }

  void _onBack() {
    _controller.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CbColors.dark,
      extendBody: true,
      body: CustomScrollView(
        slivers: [
          SearchAppBar(
            controller: _controller,
            onBack: _onBack,
          ),
          SearchCategoriesBar(controller: _controller),
          SearchResultsBody(controller: _controller),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}