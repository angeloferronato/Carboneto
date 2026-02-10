import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/like_button/like_button.dart';
import 'package:carboneto/common/widgets/result/result_main.dart';
import 'package:carboneto/features/training/controllers/training_details_controller.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/features/training/screens/training_details/widgets/training_exercises_list.dart';
import 'package:carboneto/features/training/screens/training_details/widgets/training_info_section.dart';
import 'package:carboneto/features/training/screens/training_details/widgets/training_stats_card.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrainingDetailsScreen extends StatefulWidget {
  const TrainingDetailsScreen({super.key, required this.training});

  final TrainingModel training;

  @override
  State<TrainingDetailsScreen> createState() => _TrainingDetailsScreenState();
}

class _TrainingDetailsScreenState extends State<TrainingDetailsScreen>
    with WidgetsBindingObserver {
  late TrainingDetailsController trainingDetailsController;
  TrainingModel training = TrainingModel.empty();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    trainingDetailsController = Get.put(TrainingDetailsController());
    training = widget.training;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchExercises(training);

      trainingDetailsController.initializeStats(training);

      trainingDetailsController.startViewTracking(training);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    trainingDetailsController.stopViewTracking();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      trainingDetailsController.stopViewTracking();
    } else if (state == AppLifecycleState.resumed &&
        !trainingDetailsController.hasViewBeenCounted.value) {
      trainingDetailsController.startViewTracking(training);
    }
  }

  Future<void> _fetchExercises(TrainingModel training) async {
    final updatedTraining =
        await trainingDetailsController.fetchExercises(training);
    setState(() {
      this.training = updatedTraining;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    return Scaffold(
      extendBody: true,
      appBar: CbAppBar(
        showBackArrow: true,
        actions: [LikeButton(training: training)],
      ),
      body: Obx(() {
        if (trainingDetailsController.isLoadingStats.value) {
          return const Center(
            child: CircularProgressIndicator(color: CbColors.primary),
          );
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  ResultMain(
                    training: training,
                    height: 250,
                  ),
                  Positioned(
                    bottom: -30,
                    child: TrainingStatsCard(
                      training: training,
                      isDarkMode: isDarkMode,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: CbSizes.spaceBtwSections * 1.8,
              ),
              TrainingInfoSection(
                training: training,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: CbSizes.spaceBtwItems),
              TrainingExercisesList(training: training),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(
            left: CbSizes.lg, right: CbSizes.lg, bottom: CbSizes.lg),
        decoration: BoxDecoration(color: Colors.transparent),
        child: SizedBox(
          height: 60,
          child: ElevatedButton(
            onPressed: () =>
                trainingDetailsController.showStartTrainingOptions(training, isDarkMode),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 20),
            child: Text('Começar'),
          ),
        ),
      ),
    );
  }
}
