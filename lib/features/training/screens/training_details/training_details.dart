import 'package:carboneto/common/widgets/buttons/cb_primary_btn.dart';
import 'package:carboneto/common/widgets/like_button/like_button.dart';
import 'package:carboneto/common/widgets/result/result_main.dart';
import 'package:carboneto/features/authentication/screens/onboarding/widgets/top_logo.dart';
import 'package:carboneto/features/training/controllers/training_details_controller.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/features/training/screens/training_details/widgets/training_exercises_list.dart';
import 'package:carboneto/features/training/screens/training_details/widgets/training_info_section.dart';
import 'package:carboneto/features/training/screens/training_details/widgets/training_stats_card.dart';
import 'package:carboneto/home_menu.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TrainingDetailsScreen extends StatefulWidget {
  const TrainingDetailsScreen({super.key, required this.training});

  final TrainingModel training;

  @override
  State<TrainingDetailsScreen> createState() => _TrainingDetailsScreenState();
}

class _TrainingDetailsScreenState extends State<TrainingDetailsScreen>
    with WidgetsBindingObserver {
  late final TrainingDetailsController _controller;
  late TrainingModel training;

  @override
  void initState() {
    super.initState();
    training = widget.training;
    _controller = Get.put(TrainingDetailsController());
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchExercises();
      _initAndTrack();
    });
  }

  Future<void> _initAndTrack() async {
    _controller.initializeStats(training);
    _controller.startViewTracking(training);
  }

  Future<void> _fetchExercises() async {
    final updated = await _controller.fetchExercises(training);
    if (mounted) setState(() => training = updated);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _controller.stopViewTracking();
    } else if (state == AppLifecycleState.resumed &&
        !_controller.hasViewBeenCounted.value) {
      _controller.startViewTracking(training);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Get.delete<TrainingDetailsController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(training.level.name);
    final isDarkMode = CbHelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Obx(() {
        if (_controller.isLoadingStats.value) {
          return const Center(
            child: CircularProgressIndicator(color: CbColors.primary),
          );
        }

        return NestedScrollView(
          headerSliverBuilder: (_, __) => [
            SliverAppBar(
              floating: true,
              pinned: false,
              snap: true,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 90,
              leading: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Iconsax.arrow_left),
              ),
              flexibleSpace: Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Center(
                  child: GestureDetector(
                    onTap: () => Get.offAll(HomeMenu()),
                    child: const TopLogo(showNotification: false),
                  ),
                ),
              ),
              actions: [LikeButton(training: training)],
            ),
          ],
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    ResultMain(training: training, height: 250),
                    Positioned(
                        bottom: -30,
                        child: CbStatsCard(
                          isDarkMode: isDarkMode,
                          leftIcon: CbImages.clockIcon,
                          leftValue: '${training.duration} min',
                          leftLabel: 'Duração',
                          rightIcon: CbImages.likesIcon,
                          rightLabel: 'Curtidas',
                          rightRxValue: _controller.likesCount,
                        )),
                  ],
                ),
                const SizedBox(height: CbSizes.spaceBtwSections * 1.8),
                TrainingInfoSection(training: training, isDarkMode: isDarkMode),
                const SizedBox(height: CbSizes.spaceBtwItems),
                TrainingExercisesList(training: training),
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(
            left: CbSizes.lg, right: CbSizes.lg, bottom: CbSizes.lg),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: SizedBox(
            height: 60,
            child: CbPrimaryBtn(
                label: 'Iniciar Treino',
                onPressed: () => _controller.showStartTrainingOptions(
                    training, isDarkMode))),
      ),
    );
  }
}
