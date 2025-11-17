import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/buttons/see_all_btn.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

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
            SectionMain(
              title: 'Histórico',
              icon: Icons.history,
              actionBtn: SeeAllBtn(
                onPressed: () {},
              ),
              showActionBtn: true,
            ),
            SizedBox(height: 15,),
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
            SectionMain(
              title: 'Sua Lista de Treinos',
              icon: Icons.list,
              showActionBtn: true,
              actionBtn: SortSelector(label: 'Recentes', onTap: () {}),
            )
          ],
        ),
      ),
    );
  }
}



class SortSelector extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const SortSelector({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10, right: 10),
        decoration: BoxDecoration(
          color: CbColors.inputBG,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class SectionMain extends StatelessWidget {
  const SectionMain(
      {super.key,
      required this.title,
      this.icon = Icons.history,
      this.showActionBtn = false,
      this.actionBtn});

  final String title;
  final dynamic icon;
  final bool showActionBtn;
  final dynamic actionBtn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 25,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          if (showActionBtn) actionBtn,
        ],
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
