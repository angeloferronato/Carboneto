import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/features/create/controllers/exercises_controller.dart';
import 'package:carboneto/features/create/screens/create_training/add_training/widgets/exercise_details.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carboneto/data/repositories/user/user_repository.dart'; 

class ExercisesList extends StatelessWidget {
  ExercisesList({super.key});

  final controller = Get.put(ExercisesController());
  final userRepository = Get.put(UserRepository());
  
  @override
  Widget build(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    return Expanded(
      child: Obx(() {
        final exercises = controller.filteredExercises;
        return Padding(
          padding: const EdgeInsets.only(top: 15),
          child: ListView.builder(
            itemCount: exercises.length + 1,
            itemBuilder: (context, index) {
              if (index == exercises.length) {
                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: ElevatedButton(
                          onPressed: () => controller.loadMoreExercises(10),
                          child: const Text("Carregar mais"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 85,),
                  ],
                );
              }
              final exercise = exercises[index];
              
              return Obx(() {
                final isSelected = controller.isIntermediateSelected(index);                  
                final categoriesText = exercise.categories!.join(', ');

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: GestureDetector(
                    onTapDown: (_) => controller.toggleSelectionIntermediate(index),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 1.0, end: isSelected ? 0.97 : 1.0),
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeOut,
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutCubic,
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeOutCubic,
                                  width: isSelected ? 5 : 0,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: isSelected ? CbColors.primary : CbColors.dark,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected
                                          ? CbColors.primary.withValues(alpha: 0.4)
                                          : Colors.transparent,
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      if (isSelected)
                                        BoxShadow(
                                          color: CbColors.primary.withValues(alpha: 0.2),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [                                        
                                      CbRoundedImage(
                                        imageUrl: exercise.thumb,
                                        borderRadius: 20,
                                        width: 140,
                                        height: 90,
                                        fit: BoxFit.cover,
                                        isNetworkImage: true,
                                      ),

                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 19),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                exercise.title,
                                                maxLines: 2, 
                                                overflow: TextOverflow.ellipsis, 
                                                style: Theme.of(context).textTheme.bodyLarge
                                              ),
                  
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  CbRoundedImage(
                                                    imageUrl: exercise.creator.profilePicture.isNotEmpty ? exercise.creator.profilePicture : CbImages.userDefault,
                                                    isNetworkImage: exercise.creator.profilePicture.isNotEmpty,
                                                    borderRadius: 12,
                                                    backgroundColor: CbColors.primary,
                                                    width: 15,
                                                    height: 15,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  
                                                  const SizedBox(width: 6),                                                    
                                                  Text(
                                                    maxLines: 1, 
                                                    overflow: TextOverflow.ellipsis, 
                                                    exercise.creator.name,
                                                    style: TextStyle(
                                                      color: isDarkMode ? Colors.white70 : CbColors.darkerGrey,
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  
                                                  const SizedBox(width: 6),
                                                  exercise.creator.isVerified 
                                                    ? const Icon(Icons.verified, color: CbColors.primary, size: 10) 
                                                    : const SizedBox()
                                                ],
                                              ),
                        
                                              const SizedBox(height: 4),
                                              Text(
                                                '$categoriesText · ${exercise.duration} min',
                                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                  color: isDarkMode ? Colors.white70 : CbColors.darkerGrey,
                                                  fontSize: 10,
                                                )
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () => Get.to(
                                            () => const ExerciseDetailsScreen(),
                                            arguments: exercise,
                                          ),
                                          child: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: CbColors.primary,
                                            size: 22,
                                          ),     
                                        ) 
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              });
            },
          ),
        );
      }
      ),
    );
  }
}