import 'package:carboneto/common/widgets/chips/tip_chip_training.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class TrainingTagsRow extends StatelessWidget {
  const TrainingTagsRow({
    super.key,
    required this.training,
    required this.isDarkMode,
  });

  final TrainingModel training;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const SizedBox(width: CbSizes.defaultSpace),
          CbTipChipTraining(
            text: training.textLevel ?? '',
            textColor: CbHelperFunctions
                .parseLevelStyle(context, training.level)['difficultyColorTxt'],
            color: CbHelperFunctions
                .parseLevelStyle(context, training.level)['difficultyColor'],
          ),
          const SizedBox(width: CbSizes.sm),
          ...training.categories.map(
            (category) => Padding(
              padding: const EdgeInsets.only(right: CbSizes.sm),
              child: CbTipChipTraining(
                text: category,
                textColor: CbColors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}

