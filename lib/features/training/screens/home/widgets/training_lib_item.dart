import 'package:carboneto/common/widgets/custom_shapes/containers/rounded_countainer.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class TrainingLibItem extends StatelessWidget {
  const TrainingLibItem({
    super.key, required this.image, required this.text,
  });

  final String image, text;

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = CbHelperFunctions.isDarkMode(context);
    return CbRoundedContainer(
      height: 55,
      backgroundColor: isDarkTheme ? CbColors.darkerGrey : CbColors.softGrey,
      borderRadius: 5,
      child: Row(
        children: [
          CbRoundedImage(
            width: 55,
            height: 55,
            imageUrl: image,
            backgroundColor: Colors.transparent,
            borderRadius: 5,
          ),
    
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(CbSizes.sm),
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                  fontSizeFactor: .9,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
