import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/buttons/see_all_btn.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CbColors.dark,
      appBar: CbAppBar(
        title: Text(
          'Biblioteca',
          style: TextStyle(
            fontSize: 33,
            fontWeight: FontWeight.w700,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        showBackArrow: false,
        actions: [
          IconButton(
            onPressed: () => {},
            icon: Icon(
              Iconsax.search_normal_1,
              size: 25,
            ),
          )
        ],
      ),
      body: SizedBox(
        child: Column(
          children: [
            SizedBox(
              height: CbSizes.spaceBtwSections,
            ),
            Padding(
              padding: const EdgeInsets.only(left: CbSizes.defaultSpace),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.history,
                        size: 25,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Histórico',
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SeeAllBtn(onPressed: () {})
                ],
              ),
            ),
            SizedBox(
              height: 200, // define a height for horizontal list
              child: ListView.separated(
                padding: EdgeInsets.only(left: CbSizes.defaultSpace),
                scrollDirection: Axis.horizontal,
                itemCount: 5, // however many trainings you want
                itemBuilder: (context, index) => const HistoryTraining(),
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 17), // 👈 spacing between cards
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
          CbRoundedImage(
            imageUrl: CbImages.trainingImageExample,
            width: 165,
            height: 100,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            'Stephen Curry Preseason Workout',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
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
          )
        ],
      ),
    );
  }
}
