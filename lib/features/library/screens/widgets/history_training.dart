import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';


class HistoryTraining extends StatelessWidget {
  const HistoryTraining({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 165,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 2,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  CbImages.trainingImageExample,
                  fit: BoxFit.cover,
                  width: 165,
                  height: 100,
                ),
              ),

              // Timer no canto inferior direito
              Positioned(
                right: 5,
                bottom: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '40:00',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Stephen Curry Preseason Workout',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.more_vert,
                  size: 16, // super pequeno
                ),
              )
            ],
          ),
          Row(
            children: [
              CbRoundedImage(
                imageUrl: CbImages.trainerExample,
                width: 15,
                height: 15,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Stephen Curry',
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ],
      ),
    );
  }
}