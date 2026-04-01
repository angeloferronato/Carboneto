import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/result/empty_data.dart';
import 'package:carboneto/common/widgets/searchinput/search_input.dart';
import 'package:carboneto/features/library/controllers/history_controller.dart';
import 'package:carboneto/features/library/screens/history_screen/history_timeline.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryScreen extends GetView<HistoryController> {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoadingHistory.value && controller.history.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          controller: controller.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: CbAppBar(
                title: Text(
                  'Histórico',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                showBackArrow: true,
              ),
            ),

            // SliverToBoxAdapter(
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
            //     child: Column(
            //       children: [
            //         const SizedBox(height: 16),
            //         SearchInput(
            //           placeholder: 'Pesquisar no histórico',
            //           controller: controller.searchController,
            //         ),
            //         const SizedBox(height: 16),
            //       ],
            //     ),
            //   ),
            // ),

            if (controller.history.isEmpty)
              const SliverFillRemaining(
                child: Column(
                  children: [
                    SizedBox(height: 100),
                    EmptyData(),
                  ],
                ),
              )
            else ...[
              HistoryTimeline(items: controller.history),

              if (controller.isLoadingMore.value)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator(color: CbColors.primary,)),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ],
        );
      }),
    );
  }
}