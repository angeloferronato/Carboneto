import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/features/training/controllers/training_details_controller.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResultMain extends StatelessWidget {
  const ResultMain({
    super.key,
    required this.training,
    this.hideOptions = false,
    this.height = 200,
    this.homeWidget = false,
    this.extraOptions,
  });

  final TrainingModel training;
  final double height;
  final bool hideOptions, homeWidget;
  final List<CbBottomSheetOption>? extraOptions;

  @override
  Widget build(BuildContext context) {
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
                  onShare: () {},
                  onReport: () {},
                  controller: controller,
                  training: training,
                  extraOptions: extraOptions,
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

class CbBottomSheetOption {
  const CbBottomSheetOption({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
}

class CbBottomSheet {
  static void showOptions({
    required BuildContext context,
    required VoidCallback onShare,
    required VoidCallback onReport,
    TrainingDetailsController? controller,
    TrainingModel? training,
    List<CbBottomSheetOption>? extraOptions,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: CbColors.dark,
      builder: (context) => Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Share
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Compartilhar'),
              onTap: () {
                Navigator.pop(context);
                onShare();
              },
            ),

            // Save — only when inside TrainingDetailsScreen
            if (controller != null && training != null)
              Obx(() => ListTile(
                    leading: Icon(controller.isSaved.value
                        ? Icons.bookmark_sharp
                        : Icons.bookmark_border),
                    title: Text(
                        controller.isSaved.value ? 'Salvo' : 'Salvar'),
                    onTap: () => controller.toggleSave(training),
                  )),

            // Extra options (e.g. Editar, Excluir)
            if (extraOptions != null)
              ...extraOptions.map(
                (option) => ListTile(
                  leading: Icon(option.icon),
                  title: Text(option.label),
                  onTap: () {
                    Navigator.pop(context);
                    option.onTap();
                  },
                ),
              ),

            // Report
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