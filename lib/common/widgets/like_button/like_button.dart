import 'package:carboneto/features/training/controllers/training_details_controller.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


class LikeButton extends StatelessWidget {
  final TrainingModel training;

  const LikeButton({super.key, required this.training});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TrainingDetailsController());
    return Padding(
      padding: const EdgeInsets.only(right: CbSizes.md),
      child: GestureDetector(
        onTap: () => controller.toggleLike(training),
        child: Obx( () => 
          Icon(
            controller.isLiked.value? Iconsax.heart5 : Iconsax.heart,
            color: controller.isLiked.value? CbColors.primary : Colors.grey,
          ),
        ),
      ),
    );
  }
}