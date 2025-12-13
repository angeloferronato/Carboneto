import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/features/training/screens/home/widgets/home_training_dart.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:flutter/material.dart';

class TreinoCard extends StatelessWidget {
  const TreinoCard({super.key, required this.training});
  final TrainingModel training;


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 40 - 20) / 3;
    final imageHeight = cardWidth * 1.2;

    return SizedBox(
      width: cardWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CbRoundedImage(
              isNetworkImage: true,
              imageUrl: training.thumbnail,
              height: imageHeight,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              training.title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: cardWidth * 0.12,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [LevelWidget(level: training.level)],
            ),
          ),
        ],
      ),
    );
  }
}