import 'package:carboneto/common/widgets/custom_shapes/containers/rounded_countainer.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/common/widgets/layouts/grid_layout.dart';
import 'package:carboneto/common/widgets/texts/section_heading.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(CbSizes.defaultSpace),
              child: CbGridLayout(
                itemCount: 6,
                itemBuilder: (_, index) => CbRoundedContainer(
                  height: 55,
                  backgroundColor: CbColors.darkerGrey,
                  borderRadius: 5,
                  child: Row(
                    children: [
                      CbRoundedImage(
                        width: 55,
                        height: 55,
                        image: CbImages.trainingExample
                      ),

                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(CbSizes.sm),
                          child: Text(
                            CbTexts.trainingHomeTitleExample,
                            style: Theme.of(context).textTheme.bodyMedium!.apply(
                              fontSizeFactor: .9
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                mainAxisExtent: 55,
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
              child: CbSectionHeading(title: 'Mais Populares', onPressed: () {})

            ),

          ],
        ),
      ),
    );
  }
}

