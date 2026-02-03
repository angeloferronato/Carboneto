import 'dart:ui';
import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/chips/tip_chip_training.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/common/widgets/texts/section_heading.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/personalization/screens/profile/profile.dart';
import 'package:carboneto/features/training/controllers/training_details_controller.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/features/training/screens/training_details/widgets/training_queue_item.dart';
import 'package:carboneto/features/training/screens/training_details/widgets/training_queue_shimmer.dart';
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

class _TrainingDetailsScreenState extends State<TrainingDetailsScreen> {
  late TrainingDetailsController trainingDetailsController;
  TrainingModel training = TrainingModel.empty();

  @override
  void initState() {
    super.initState();
    trainingDetailsController = Get.put(TrainingDetailsController());
    training = widget.training;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchExercises(training);
    });
  }

  Future<void> _fetchExercises(TrainingModel training) async {
    final updatedTraining = await trainingDetailsController.fetchExercises(training);
    setState(() {
      this.training = updatedTraining;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    final isCreatorTraining = UserController.instance.user.value.id == training.authorId;
    return Scaffold(
      extendBody: true,
      appBar: CbAppBar(
        title: null,
        showBackArrow: true,
        actions: [
          isCreatorTraining ? 
          IconButton(
            icon: Icon(Icons.more_vert_outlined),
            onPressed: () => trainingDetailsController.showTrainingUserOptions(training)
          ) : SizedBox(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  CbRoundedImage(
                    imageUrl: training.thumbnail,
                    isNetworkImage: true,
                    width: double.infinity,
                    height: 250,
                    borderRadius: CbSizes.cardRadiusLg,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: -30,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(CbSizes.cardRadiusLg),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          padding: const EdgeInsets.all(CbSizes.md),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(CbSizes.cardRadiusLg),
                            color: isDarkMode
                                ? Color.fromARGB(188, 70, 70, 70)
                                : Color.fromARGB(255, 48, 48, 48),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Icon(Iconsax.clock4, color: CbColors.white),
                                  const SizedBox(width: CbSizes.spaceBtwItems),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${training.duration.toString()} min',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .apply(
                                                color: CbColors.light,
                                                fontSizeFactor: 1.1),
                                      ),
                                      Text(
                                        'Duração',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .apply(color: CbColors.light),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(width: CbSizes.spaceBtwItems),
                              Container(
                                width: 1,
                                height: 24,
                                color: CbColors.white.withValues(alpha: 0.8),
                              ),
                              const SizedBox(width: CbSizes.spaceBtwItems),
                              Row(
                                children: [
                                  Icon(Iconsax.chart, color: CbColors.white),
                                  const SizedBox(width: CbSizes.spaceBtwItems),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        training.exercisesId!.length.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .apply(
                                                color: CbColors.light,
                                                fontSizeFactor: 1.1),
                                      ),
                                      
                                      Text(
                                        'Exercícios',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .apply(color: CbColors.light),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: CbSizes.spaceBtwSections * 1.8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                   training.title,
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .apply(fontSizeFactor: 1.25),
                  ),
                  const SizedBox(
                    height: CbSizes.spaceBtwItems,
                  ),
                  GestureDetector(
                    onTap: UserController.instance.user.value.id == training.authorId 
                    ? () {
                      Get.offAll(HomeMenu());
                      final homeMenuController = Get.put(HomeMenuController());
                      homeMenuController.selectedIndex.value = 4; 
                    }
                    : () => Get.to(ProfileScreen(userId: training.authorId,)),
                    child: Row(
                      children: [
                        CbRoundedImage(
                          imageUrl: training.creator.profilePicture.isNotEmpty ? training.creator.profilePicture : CbImages.userDefault,
                          width: 28,
                          height: 28,
                          fit: BoxFit.cover,
                          isNetworkImage: training.creator.profilePicture.isNotEmpty,
                        ),
                        SizedBox(
                          width: CbSizes.sm,
                        ),
                        Text(
                          training.creator.name,
                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            fontSize: 14,
                            color:
                            isDarkMode ? CbColors.grey : CbColors.dark
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          width: CbSizes.xs,
                        ),
                        
                        training.creator.isVerified ? Icon(
                          Iconsax.verify5,
                          color: CbColors.primary,
                          size: 16,
                        ) : SizedBox(),
                    
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: CbSizes.spaceBtwItems,
                  ),
                  SizedBox(
                    height: 25,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        CbTipChipTraining(
                          backgroundColor: CbColors.buttonChipTraining
                              .withValues(alpha: isDarkMode ? 0.58 : 1),
                          textColor: CbColors.white,
                          text: training.textLevel ?? '',
                        ),
                        const SizedBox(
                          width: CbSizes.sm,
                        ),
                    
                        SizedBox(
                          height: 23,
                          child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: training.categories.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (_, index) {
                              return CbTipChipTraining(
                                text: training.categories[index],
                                backgroundColor:
                                    isDarkMode ? CbColors.white : CbColors.dark,
                                textColor: isDarkMode ? CbColors.dark : CbColors.white,
                              );
                            },
                            separatorBuilder: (_, __) {
                              return SizedBox(width: CbSizes.sm,);
                            },
                          
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: CbSizes.spaceBtwItems,
                  ),
                  Text(
                    training.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 12),
                  ),
                  const SizedBox(
                    height: CbSizes.spaceBtwItems,
                  ),
                  CbSectionHeading(
                    title: "Exercícios",
                    onPressed: () {},
                    showButton: false,
                  ),
                  const SizedBox(
                    height: CbSizes.spaceBtwItems,
                  ),

                  Obx(() => !trainingDetailsController.isLoading.value ? Column(
                    children: List.generate(training.exercises.length, (index) {
                      String twoDigits(int n) => n.toString().padLeft(2, '0');
                      final timeExecution = Duration(minutes: training.exercises[index].duration);
                      final minutes = twoDigits(timeExecution.inMinutes.remainder(60));
                      return Padding(
                        padding: const EdgeInsets.only(bottom: CbSizes.spaceBtwItems),
                        child: CbTrainingQueueItem(
                          video: training.exercises[index].video,
                          image: CbImages.trainingExample,
                          title: training.exercises[index].title,
                          duration: '$minutes:00',
                        ),
                      );
                    }),
                  ) : TrainingQueueShimmer()),
                  

                  const SizedBox(
                    height: 100,
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(left: CbSizes.lg, right: CbSizes.lg, bottom: CbSizes.lg),
        decoration: BoxDecoration(color: Colors.transparent),
        child: SizedBox(
          height: 60,
          child: ElevatedButton(
            onPressed: () => trainingDetailsController.showStartTrainingOptions(training),
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


