import 'package:carboneto/common/widgets/result/result_widget.dart';
import 'package:carboneto/common/widgets/texts/section_heading.dart';
import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/data/repositories/user/user_repository.dart';
import 'package:carboneto/features/authentication/screens/onboarding/widgets/top_logo.dart';
import 'package:carboneto/features/create/screens/create_training/add_training/widgets/categories_bar.dart';
import 'package:carboneto/features/training/controllers/home_controller.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/features/training/screens/home/widgets/home_shimmer.dart';
import 'package:carboneto/features/training/screens/home/widgets/home_training.dart';
import 'package:carboneto/features/training/screens/training_details/training_details.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TrainingRepository trainingRepository = Get.put(TrainingRepository());
  final UserRepository userRepository = Get.put(UserRepository());
  final HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: CbSizes.md, bottom: CbSizes.md),
          child: Obx(() {
            if (controller.isLoading.value) {
              return _buildLoading();
            }
          
            if (controller.isGridMode.value) {
              return _buildSingleListMode();
            }
          
            return _buildSectionsMode();
          }),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return ListView(
      shrinkWrap: true,
      children: [
        TopLogo(),
        CategoriesBar(
          controllerTag: 'home',
        ),
        HomeShimmer(),
      ],
    );
  }

  Widget _buildSingleListMode() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: TopLogo()),
        SliverToBoxAdapter(child: CategoriesBar(controllerTag: 'home')),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              controller.currentTitle.value,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontSize: 22),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: CbSizes.md),
                child: ResultWidget(
                  training: controller.visibleTrainings[index],
                  homeWidget: true,
                ),
              );
            },
            childCount: controller.visibleTrainings.length,
          ),
        ),
      ],
    );
  }

  // Widget _buildGridMode() {
  //   return SingleChildScrollView(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         TopLogo(),
  //         CategoriesBar(controllerTag: 'home',),
  //         Padding(
  //           padding: const EdgeInsets.only(top: 16, left: CbSizes.md),
  //           child: Text(
  //             controller.currentTitle.value,
  //             style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 22),
  //           ),
  //         ),
  //         Container(
  //           margin: const EdgeInsets.symmetric(horizontal: CbSizes.md),
  //           child: CbGridLayout(
  //             mainAxisExtent: 235,
  //             itemCount: controller.visibleTrainings.length,
  //             itemBuilder: (_, index) {
  //               final training = controller.visibleTrainings[index];
  //               return HomeTrainingWidget(
  //                 paddingRight: 0,
  //                 borderRadius: 15,
  //                 onTap: () {
  //                   Get.to(() => TrainingDetailsScreen(training: training));
  //                 },
  //                 training: training,
  //               );
  //             },
  //           ),
  //         ),

  //       ],
  //     ),
  //   );
  // }

  Widget _buildSectionsMode() {
    return Obx(() {
      final sections = controller.sections;

      return ListView(
        children: [
          TopLogo(),
          CategoriesBar(
            controllerTag: 'home',
          ),
          const SizedBox(height: 16),
          ...sections.entries.map((entry) {
            final category = entry.key;
            final trainings = entry.value;

            if (trainings.isEmpty) return const SizedBox();

            return _buildSection(category, trainings);
          }),
        ],
      );
    });
  }

  Widget _buildSection(String title, List<TrainingModel> trainings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title),
        const SizedBox(height: 12),
        SizedBox(
          height: 265,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: trainings.length,
            itemBuilder: (_, index) {
              final training = trainings[index];

              return HomeTrainingWidget(
                training: training,
                onTap: () {
                  Get.to(() => TrainingDetailsScreen(training: training));
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: CbSizes.md),
          child: CbSectionHeading(
            title: title,
            onPressed: () {
              controller.openCategory(title);
            }
          ),
        )
      ],
    );
  }
}
