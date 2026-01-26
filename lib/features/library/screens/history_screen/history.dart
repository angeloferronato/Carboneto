import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/result/empty_data.dart';
import 'package:carboneto/common/widgets/searchinput/search_input.dart';
import 'package:carboneto/features/library/controllers/history_controller.dart';
import 'package:carboneto/features/library/screens/history_screen/history_timeline.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  final HistoryController controller = Get.find<HistoryController>();
  final ScrollController scroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    scroll.addListener(() {
      if (scroll.position.pixels >= scroll.position.maxScrollExtent - 300) {
        controller.fetchMore();
      }
    });

    return Scaffold(
      backgroundColor: CbColors.dark,
      appBar: CbAppBar(
        title: Text(
          'Histórico',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
        ),
        showBackArrow: true,
      ),
      body: Obx(() {
        final history = controller.history;
        final TextEditingController searchCtrl = TextEditingController();

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
          child: ListView(
            controller: scroll,
            children: [
              const SizedBox(height: 16),
              SearchInput(
                placeholder: 'Pesquisar no histórico',
                controller: searchCtrl,
              ),
              const SizedBox(height: 16),
              if (history.isNotEmpty)
                HistoryTimeline(items: history)
              else
                Column(
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    EmptyData(),
                  ],
                ),
              if (controller.isLoadingMore.value)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      }),
    );
  }
}
