import 'dart:io';

import 'package:carboneto/common/widgets/buttons/cb_primary_btn.dart';
import 'package:carboneto/features/create/controllers/upload_image_controller.dart';
import 'package:carboneto/features/training/screens/training_execution/widgets/video_player.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:carboneto/utils/loading_effects/shimmer_effects.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class SquareUploadWidget extends StatelessWidget {
  const SquareUploadWidget({
    super.key,
    required this.onSelectFiles,
    this.label = "",
    this.description = "",
    required this.uploadImageController,
    this.fileType = FileType.image,
    this.existingImageUrl,
  });

  final String label, description;
  final UploadImageController uploadImageController;
  final FileType fileType;
  final VoidCallback onSelectFiles;

  /// When provided (edit mode), shows this network image until the user picks a new file.
  final String? existingImageUrl;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);

    return Obx(() {
      final hasNewFile = uploadImageController.selectedFile.value != null;
      final hasNewVideo = uploadImageController.selectedVideo.value != null;
      final hasExisting =
          existingImageUrl != null && existingImageUrl!.isNotEmpty;

      // ── No file picked yet ───────────────────────────────────────────
      if (!hasNewFile && !hasNewVideo) {
        // Edit mode: show existing network thumbnail with a swap button
        if (hasExisting) {
          return Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Shimmer shown while image loads
                    CbShimmerEffects(
                      width: double.infinity,
                      height: 250,
                      radius: 20,
                    ),
                    // Network image overlays shimmer once loaded
                    Image.network(
                      existingImageUrl!,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded || frame != null) {
                          return child;
                        }
                        // Still loading — return transparent so shimmer shows through
                        return const SizedBox(
                          height: 250,
                          width: double.infinity,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: CbSizes.spaceBtwItems),
              CbPrimaryBtn(label: 'Trocar Imagem', onPressed: onSelectFiles),
            ],
          );
        }

        // Create mode: show empty upload box
        return Center(
          child: Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0x31467CB8), Color(0x61152E42)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: CbColors.borderBlue, width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isDarkMode ? CbColors.dark : CbColors.lightGrey,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.upload_rounded,
                    size: 30,
                    color: CbColors.primary,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color:
                        isDarkMode ? CbColors.lightGrey : CbColors.darkerGrey,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color:
                          isDarkMode ? CbColors.lightGrey : CbColors.darkerGrey,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                CbPrimaryBtn(
                  label: 'Selecionar',
                  fontSize: 13,
                  onPressed: onSelectFiles,
                ),
              ],
            ),
          ),
        );
      }

      // ── New file picked ──────────────────────────────────────────────
      if (fileType == FileType.image) {
        return Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                uploadImageController.selectedFile.value ?? File(''),
                height: 250,
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ),
            const SizedBox(height: CbSizes.spaceBtwItems),
            CbPrimaryBtn(label: 'Trocar Imagem', onPressed: onSelectFiles),
          ],
        );
      }

      // Video
      return Column(
        children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: VideoPlayerView(
              url: uploadImageController.selectedVideo.value!.path,
              dataSourceType: DataSourceType.file,
            ),
          ),
          const SizedBox(height: CbSizes.spaceBtwItems),
          CbPrimaryBtn(
            label: 'Trocar vídeo',
            fontSize: 13,
            onPressed: onSelectFiles,
          ),
        ],
      );
    });
  }
}
