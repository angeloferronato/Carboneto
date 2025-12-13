import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';


class CreatedTraining extends StatelessWidget {
  const CreatedTraining({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 115,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          CbRoundedImage(
            imageUrl: CbImages.thumbnailTrainingExample,
            height: 115,
            fit: BoxFit.cover,
          ),
          Text(
            'USA Full Week',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 14,
            ),
          ),
          Text(
            'Coach K',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                color: CbColors.buttonDisabled,
                fontWeight: FontWeight.w200,
                fontSize: 12),
          )
        ],
      ),
    );
  }
}