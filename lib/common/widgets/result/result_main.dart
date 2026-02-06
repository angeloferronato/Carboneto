import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class ResultMain extends StatelessWidget {
  const ResultMain({
    super.key,
    required this.imageThumbnail,
    this.hideOptions = false,
    this.views,
    this.height = 200,
    this.homeWidget = false,
  });

  final String imageThumbnail;
  final int? views;
  final double height;
  final bool hideOptions, homeWidget;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: height,
      ),
      child: Stack(
        children: [
          CbRoundedImage(
            imageUrl: imageThumbnail,
            isNetworkImage: true,
            height: height,
            fit: BoxFit.cover,
            width: homeWidget ? 245 :CbHelperFunctions.screenWidth() - 40,
            backgroundColor: Colors.transparent,
          ),
          // Views counter - top left
          if (views != null)
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: homeWidget ? 5: 8,
                  vertical: homeWidget ? 2: 4,
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
                      size: homeWidget? 10: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      CbHelperFunctions.formatViews(views),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: homeWidget? 10: 12,
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
                              ListTile(
                                leading: const Icon(Icons.bookmark_border),
                                title: const Text('Salvar'),
                                onTap: () {
                                  Navigator.pop(context);
                                  // Add save logic
                                },
                              ),
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
