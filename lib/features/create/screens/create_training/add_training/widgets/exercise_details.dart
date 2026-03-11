import 'dart:io';
import 'package:carboneto/common/widgets/chips/tip_chip_training.dart';
import 'package:carboneto/common/widgets/result/result_creator_info.dart';
import 'package:carboneto/common/widgets/result/result_main.dart';
import 'package:carboneto/features/authentication/screens/onboarding/widgets/top_logo.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:carboneto/features/training/screens/training_details/widgets/training_stats_card.dart';
import 'package:carboneto/features/training/screens/training_execution/widgets/video_player.dart';
import 'package:carboneto/home_menu.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:carboneto/utils/loading_effects/shimmer_effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:video_player/video_player.dart';

class ExerciseDetailsScreen extends StatelessWidget {
  const ExerciseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExercisePreviewController());
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtitleColor =
        isDark ? CbColors.buttonDisabled : CbColors.darkerGrey;
    final exercise = controller.exercise;

    final double videoWidth = size.width - (CbSizes.md * 2);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
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
              actions: [
                GestureDetector(
                  onTap: () => CbBottomSheet.showOptions(
                    context: context,
                    onShare: () {},
                    onReport: () {},
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: CbSizes.md),
                    child: const Icon(Icons.more_vert,
                        color: CbColors.white, size: 30),
                  ),
                ),
              ],
            ),
          ];
        },
        body: Obx(() {
          final ratio = controller.aspectRatio.value;

          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: ratio == null
                          ? CbShimmerEffects(
                              width: videoWidth,
                              height: 250,
                              radius: 16,
                            )
                          : ratio < 1.0
                              ? SizedBox(
                                  width: CbHelperFunctions.screenWidth() -
                                      CbSizes.md,
                                  height: 500,
                                  child: VideoPlayerView(
                                    url: exercise.video,
                                    isOverVideo: true,
                                    dataSourceType: DataSourceType.network,
                                  ),
                                )
                              // horizontal video
                              : SizedBox(
                                  width: CbHelperFunctions.screenWidth() -
                                      CbSizes.md,
                                  height: 250,
                                  child: VideoPlayerView(
                                    url: exercise.video,
                                    isOverVideo: true,
                                    dataSourceType: DataSourceType.network,
                                  ),
                                ),
                    ),
                    Positioned(
                      bottom: -65,
                      child: Material(
                        color: Colors.transparent,
                        child: CbStatsCard(
                          isDarkMode: isDarkMode,
                          leftIcon: exercise.type == 'reps'? CbImages.repsIcon : CbImages.clockIcon,
                          leftValue: exercise.type == 'reps'? exercise.repetitions.toString() : CbHelperFunctions.formatDuration(exercise.duration, fullCase: true),
                          leftLabel: exercise.type == 'reps' ? 'Repetições':'Duração',
                          rightIcon: CbImages.peopleIcon,
                          rightLabel: 'Pessoa(s)',
                          rightValue: exercise.peopleCount.toString(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 75),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 0, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          exercise.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 15),
                      ResultCreatorInfo(
                        creator: exercise.creator,
                        creatorId: exercise.authorId,
                        showUserPicture: true,
                        textSize: 14,
                        userPictureSize: 40,
                        justProfileInfo: true,
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ...exercise.categories!.map(
                              (category) => Padding(
                                padding:
                                    const EdgeInsets.only(right: CbSizes.sm),
                                child: CbTipChipTraining(
                                  text: category,
                                  textColor: CbColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (exercise.description.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Text(
                          'Descrição',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            textAlign: TextAlign.justify,
                            exercise.description,
                            style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: 12),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class ExercisePreviewController extends GetxController {
  static ExercisePreviewController get instance => Get.find();

  final ExerciseModel exercise = Get.arguments as ExerciseModel;
  final Rx<double?> aspectRatio = Rx<double?>(null);

  @override
  void onInit() {
    super.onInit();
    _detectOrientation();
  }

  bool get isVertical => (aspectRatio.value ?? 1) < 1.0;

  Future<void> _detectOrientation() async {
    try {
      final fileInfo =
          await DefaultCacheManager().getSingleFile(exercise.video);
      final probe = VideoPlayerController.file(File(fileInfo.path));
      await probe.initialize();
      aspectRatio.value = probe.value.aspectRatio;
      await probe.dispose();
    } catch (_) {
      aspectRatio.value = 16 / 9;
    }
  }
}
