import 'package:carboneto/common/widgets/chips/tip_chip_training.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/common/widgets/level/level_widget.dart';
import 'package:carboneto/common/widgets/result/result_creator_info.dart';
import 'package:carboneto/common/widgets/result/result_main.dart';
import 'package:carboneto/common/widgets/user/user_picture.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/personalization/screens/profile/profile.dart';
import 'package:carboneto/features/training/models/creator/creator_model.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/features/training/screens/training_details/training_details.dart';
import 'package:carboneto/features/training/screens/training_details/widgets/training_info_section.dart';
import 'package:carboneto/home_menu.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatedTraining extends StatelessWidget {
  const CreatedTraining({super.key, required this.training});

  final TrainingModel training;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          GestureDetector(
            onTap: () => Get.to(TrainingDetailsScreen(training: training)),
            child: Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 125,
                  ),
                  child: Stack(
                    children: [
                      CbRoundedImage(
                        imageUrl: training.thumbnail,
                        isNetworkImage: true,
                        height: 125,
                        fit: BoxFit.cover,
                        width: 170,
                        backgroundColor: Colors.transparent,
                      ),
                      // Views counter - top left
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: CbTipChipTraining(
                          justShowLevel: true,
                          text: training.textLevel ?? '',
                          textColor: CbHelperFunctions.parseLevelStyle(
                              context, training.level)['difficultyColorTxt'],
                          color: CbHelperFunctions.parseLevelStyle(
                              context, training.level)['difficultyColor'],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  training.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // CbRoundedImage(
          //   imageUrl: training.thumbnail,
          //   isNetworkImage: true,
          //   fit: BoxFit.cover,
          //   width: 175,
          //   height: 125,
          // ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap:
                    UserController.instance.user.value.id == training.authorId
                        ? () {
                            Get.offAll(HomeMenu());
                            final homeMenuController =
                                Get.put(HomeMenuController());
                            homeMenuController.selectedIndex.value = 4;
                          }
                        : () => Get.to(ProfileScreen(
                              userId: training.authorId,
                            )),
                child: ResultCreatorInfo(
                  creator: training.creator,
                  showUserPicture: true,
                  userPictureSize: 15,
                  justProfileInfo: true,
                ),
              ),

              Text(
                CbHelperFunctions.formatDuration((training.duration! * 60)),
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
              )
              // LevelWidget(
              //   level: training.level,
              //   hideLevelCircles: true,
              // )
            ],
          ),
        ],
      ),
    );
  }
}
