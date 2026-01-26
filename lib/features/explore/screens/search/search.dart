import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/searchinput/search_input.dart';
import 'package:carboneto/features/explore/controllers/explorer_controller.dart';
import 'package:carboneto/features/explore/screens/search/widgets/explore_all_container.dart';
import 'package:carboneto/features/explore/screens/search/widgets/trainings_container.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) {
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: CbSizes.defaultSpace),
            child: Column(

              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
                  child: SearchInput(
                    placeholder: 'O que você quer treinar?',
                    controller: TextEditingController(),
                  ),
                ),
                
                const SizedBox(
                  height: CbSizes.spaceBtwItems * 2,
                ),

                Obx(() {
                  if (controller.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 120),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: CbColors.primary,
                        ),
                      ),
                    );
                  }

                  else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        TrainingsContainer(controller: controller),

                        ExploreAllContainer(controller: controller),

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

