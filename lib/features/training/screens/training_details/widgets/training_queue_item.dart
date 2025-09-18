import 'package:carboneto/common/widgets/custom_shapes/containers/rounded_countainer.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CbTrainingQueueItem extends StatelessWidget {
  const CbTrainingQueueItem({
    super.key,
    required this.image,
    required this.title,
    required this.duration,
  });

  final String image, title, duration;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return CbRoundedContainer(
          padding: const EdgeInsets.symmetric(vertical: CbSizes.xs, horizontal: CbSizes.sm),
          backgroundColor: isDarkMode ? CbColors.darkerGrey : CbColors.grey,
          height: 70,
          width: constraints.maxWidth,
          child: Row(
            children: [
              CbRoundedImage(
                imageUrl: image,
                borderRadius: 15,
                width: 50,
                height: 50,
              ),
              const SizedBox(width: CbSizes.md),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: CbSizes.xs),
                    Text(
                      duration,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: CbSizes.md),
              IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {},
                icon: Icon(Iconsax.play_circle4),
              ),
            ],
          ),
        );
      },
    );
  }
}
