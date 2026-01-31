import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/common/widgets/result/progress_indicator.dart';
import 'package:carboneto/features/library/models/history_model.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';


class HistoryTraining extends StatelessWidget {

  final TrainingHistoryModel training;

  const HistoryTraining({
    super.key,
    required this.training,
  });

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
              CbRoundedImage(
                borderRadius: 12,
                isNetworkImage: true,
                imageUrl: training.thumbnail,
                fit: BoxFit.cover,
                width: 165,
                height: 100,
                backgroundColor: Colors.black,
              ),

              // Timer no canto inferior direito
              Positioned(
                right: 5,
                bottom: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: CbProgressIndicator(
                    progress: training.trainingProgress,
                    status: training.status,
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
                  training.title,
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
                imageUrl: training.authorPicture,
                width: 15,
                height: 15,
                fit: BoxFit.cover,
                isNetworkImage: true,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                training.author,
                style: TextStyle(
                  color: CbColors.grey,
                  fontSize: 11,
                ),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ],
      ),
    );
  }
  
}

