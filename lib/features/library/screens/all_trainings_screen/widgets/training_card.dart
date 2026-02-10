import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';


class TrainingCard extends StatelessWidget {
  const TrainingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    return Column(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            CbImages.thumbnailTrainingExample,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Arremessos',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w200,
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 13,
                ),
              ),
            ),
            const Icon(Icons.more_vert, size: 14, color: CbColors.textSecondary,),
          ],
        ),
        Text(
          'Chico Buarque',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isDarkMode ? CbColors.buttonDisabled : CbColors.darkerGrey,
            fontSize: 10,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}