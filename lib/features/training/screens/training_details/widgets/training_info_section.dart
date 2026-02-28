import 'package:carboneto/common/widgets/result/result_creator_info.dart';
import 'package:carboneto/common/widgets/texts/section_heading.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/personalization/screens/profile/profile.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/features/training/screens/training_details/widgets/training_tags_row.dart';
import 'package:carboneto/home_menu.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrainingInfoSection extends StatelessWidget {
  const TrainingInfoSection({
    super.key,
    required this.training,
    required this.isDarkMode,
  });

  final TrainingModel training;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
          child: Text(
            training.title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .apply(fontSizeFactor: 1.25),
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
          child: Row(
            children: [
              ResultCreatorInfo(
                  creator: training.creator,
                  creatorId: training.authorId,
                  userPictureSize: 25,
                  textSize: 11,
                  showUserPicture: true,
              ),
              const SizedBox(width: 5),
              Text(
                'há ${CbHelperFunctions.formatTimestamp(training.postedAt!)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: CbSizes.spaceBtwItems),
        TrainingTagsRow(training: training, isDarkMode: isDarkMode),
        const SizedBox(height: CbSizes.spaceBtwItems),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
          child: Text(
            training.description,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 12),
          ),
        ),
        const SizedBox(height: CbSizes.spaceBtwItems),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
          child: CbSectionHeading(
            title: "Exercícios (${training.exercisesId!.length})",
            showButton: false,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

