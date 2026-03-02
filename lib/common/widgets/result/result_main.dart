import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/features/training/controllers/training_details_controller.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// result_main.dart
class ResultMain extends StatelessWidget {
  const ResultMain({
    super.key,
    required this.training,
    this.hideOptions = false,
    this.height = 200,
    this.homeWidget = false,
  });

  final TrainingModel training;
  final double height;
  final bool hideOptions, homeWidget;

  @override
  Widget build(BuildContext context) {
    // Get.find instead of Get.put — reuses the existing instance
    // If used outside TrainingDetailsScreen (e.g. home feed), controller won't exist,
    // so we fall back to the static training data
    final controller = Get.isRegistered<TrainingDetailsController>()
        ? Get.find<TrainingDetailsController>()
        : null;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: height),
      child: Stack(
        children: [
          CbRoundedImage(
            imageUrl: training.thumbnail,
            isNetworkImage: true,
            height: height,
            fit: BoxFit.cover,
            width: homeWidget
                ? 245
                : CbHelperFunctions.screenWidth() - CbSizes.md,
            backgroundColor: Colors.transparent,
          ),

          // Views counter — reactive if controller exists, static fallback
          Positioned(
            top: 12,
            left: 12,
            child: controller != null
                ? Obx(() => _ViewsBadge(
                      views: controller.viewsCount.value,
                      homeWidget: homeWidget,
                    ))
                : _ViewsBadge(
                    views: training.viewsCount,
                    homeWidget: homeWidget,
                  ),
          ),

          if (!hideOptions)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => CbBottomSheet.showOptions(
                  context: context,
                  onShare: () {}, //HERE
                  onReport: () {}, 
                  extraItem: controller != null
                      ? Obx(() => ListTile(
                            leading: Icon(controller.isSaved.value
                                ? Icons.bookmark_sharp
                                : Icons.bookmark_border),
                            title: Text(
                                controller.isSaved.value ? 'Salvo' : 'Salvar'),
                            onTap: () => controller.toggleSave(training),
                          ))
                      : null,
                ),
                child: const Icon(
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


// Extract badge to avoid duplication
class _ViewsBadge extends StatelessWidget {
  const _ViewsBadge({required this.views, required this.homeWidget});
  final int views;
  final bool homeWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Icon(Icons.remove_red_eye,
              size: homeWidget ? 10 : 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            CbHelperFunctions.formatViews(views),
            style: TextStyle(
              color: Colors.white,
              fontSize: homeWidget ? 10 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class CbBottomSheet {
  static void showOptions({
    required BuildContext context,
    VoidCallback? onShare,
    VoidCallback? onReport,
    Widget? extraItem,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: CbColors.dark,
      builder: (context) => Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onShare != null)
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Compartilhar'),
                onTap: () {
                  Navigator.pop(context);
                  onShare();
                },
              ),
            if (extraItem != null) extraItem,
            if (onReport != null)
              ListTile(
                leading: const Icon(Icons.report_outlined),
                title: const Text('Reportar'),
                onTap: () {
                  Navigator.pop(context);
                  onReport();
                },
              ),
          ],
        ),
      ),
    );
  }
}
