import 'package:carboneto/features/create/screens/create_training/controllers/exercises_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExercisesList extends StatelessWidget {
  ExercisesList({super.key});

  final controller = Get.put(ExercisesController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        final exercises = controller.exercises;

        return Padding(
          padding: const EdgeInsets.only(top: 15),
          child: ListView.separated(
            itemCount: exercises.length,
            separatorBuilder: (_, __) => const SizedBox(height: 25),
            itemBuilder: (context, index) {
              final exercise = exercises[index];
          
              return Obx(() {
                final isSelected = controller.isSelected(index);
          
                return GestureDetector(
                  onTapDown: (_) => controller.toggleSelection(index),
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
                                  color: isSelected
                                      ? CbColors.primary
                                      : CbColors.dark,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
          

                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? CbColors.primary.withValues(alpha: 0.4)
                                        : CbColors.dark,
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
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                        exercise['thumbnail'],
                                        height: 90,
                                        width: 140,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
          
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 19),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              exercise['title'],
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Plus Jakarta Sans',
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 8,
                                                  backgroundImage: AssetImage(
                                                      exercise['thumbnail']),
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  exercise['trainer'],
                                                  style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                const Icon(Icons.verified,
                                                    color: Colors.amber, size: 10),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${exercise['category']}, ${exercise['type']}  ·  ${exercise['duration']}',
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withValues(alpha: 0.6),
                                                fontSize: 10,
                                                fontFamily: 'Plus Jakarta Sans',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
          
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      height: 32,
                                      width: 32,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? CbColors.primary.withValues(alpha: 0.25)
                                            : CbColors.primary.withValues(alpha: 0.15),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.play_arrow_rounded,
                                        color: CbColors.primary,
                                        size: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              });
            },
          ),
        );
      }),
    );
  }
}
