import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/features/create/screens/create_training/add_training/widgets/exercise_details.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExerciseSearchCard extends StatelessWidget {
  const ExerciseSearchCard({super.key, required this.exercise});

  final ExerciseModel exercise;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    final categoriesText = (exercise.categories ?? []).join(', ');
    final subtitle = [
      if (categoriesText.isNotEmpty) categoriesText,
      if (exercise.duration > 0) '${exercise.duration} min',
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () => Get.to(
          () => const ExerciseDetailsScreen(),
          arguments: exercise,
        ),
        child: Row(
          children: [
            CbRoundedImage(
              imageUrl: exercise.thumb,
              borderRadius: 16,
              width: 120,
              height: 80,
              fit: BoxFit.cover,
              isNetworkImage: true,
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 6),

                  Row(
                    children: [
                      CbRoundedImage(
                        imageUrl: exercise.creator.profilePicture.isNotEmpty
                            ? exercise.creator.profilePicture
                            : CbImages.userDefault,
                        isNetworkImage:
                            exercise.creator.profilePicture.isNotEmpty,
                        borderRadius: 12,
                        backgroundColor: CbColors.primary,
                        width: 14,
                        height: 14,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          exercise.creator.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.white70
                                : CbColors.darkerGrey,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (exercise.creator.isVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.verified,
                            color: CbColors.primary, size: 10),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),

                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: isDarkMode
                                ? Colors.white70
                                : CbColors.darkerGrey,
                            fontSize: 10,
                          ),
                    ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: CbColors.primary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}