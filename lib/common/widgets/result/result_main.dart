import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/features/training/controllers/training_details_controller.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ResultMain extends StatelessWidget {
  ResultMain({
    super.key,
    required this.training,
    this.hideOptions = false,
    this.height = 200,
    this.homeWidget = false,
  });

  final TrainingModel training;
  final double height;
  final bool hideOptions, homeWidget;
  final controller = Get.put(TrainingDetailsController());

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: height,
      ),
      child: Stack(
        children: [
          CbRoundedImage(
            imageUrl: training.thumbnail,
            isNetworkImage: true,
            height: height,
            fit: BoxFit.cover,
            width: homeWidget ? 245 : CbHelperFunctions.screenWidth() - CbSizes.md,
            backgroundColor: Colors.transparent,
          ),
          // Views counter - top left
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: homeWidget ? 5 : 8,
                  vertical: homeWidget ? 2 : 4,
                ),
                decoration: BoxDecoration(
                  color: CbColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.remove_red_eye,
                      size: homeWidget ? 10 : 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      CbHelperFunctions.formatViews(training.viewsCount),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: homeWidget ? 10 : 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Three dots menu - top right
          hideOptions
              ? SizedBox()
              : Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      // Default behavior - show options menu
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: CbColors.dark,
                        builder: (context) => Container(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.share),
                                title: const Text('Compartilhar'),
                                onTap: () {
                                  Navigator.pop(context);
                                  // Add share logic
                                },
                              ),
                              Obx(() => ListTile(
                                leading: controller.isSaved.value ? Icon(Icons.bookmark_sharp) : Icon(Icons.bookmark_border),
                                title: controller.isSaved.value ? Text('Salvo') : Text('Salvar'),
                                onTap: () {
                                  controller.toggleSave(training);
                                },
                              ))
                              ,
                              ListTile(
                                leading: const Icon(Icons.report_outlined),
                                title: const Text('Reportar'),
                                onTap: () {
                                  Navigator.pop(context);
                                  // Add report logic
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.more_horiz,
                      color: CbColors.white,
                      size: 30,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}



