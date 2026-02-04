import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';


class LikeButton extends StatelessWidget {
  final TrainingModel training;

  const LikeButton({super.key, required this.training});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => {},
      icon: Icon(
        Iconsax.heart,
        color: Colors.grey,
      ),
    );
  }
}