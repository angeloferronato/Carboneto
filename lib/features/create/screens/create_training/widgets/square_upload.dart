import 'dart:io';

import 'package:carboneto/common/widgets/buttons/cb_primary_btn.dart';
import 'package:carboneto/features/create/controllers/upload_image_controller.dart';
import 'package:carboneto/features/training/screens/training_execution/widgets/video_player.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
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
  });

  final String label, description;
  final UploadImageController uploadImageController;
  final FileType fileType;

  final VoidCallback onSelectFiles;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    return Obx(
      () => uploadImageController.selectedFile.value == null && uploadImageController.selectedVideo.value == null ? Center(
        child: Container(
          height: 250,
          decoration: BoxDecoration(
            border: Border.all(
              color: CbColors.darkGrey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Upload icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isDarkMode ? CbColors.inputBG : CbColors.lightGrey,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.upload_rounded,
                  size: 30,
                  color: CbColors.primary,
                ),
              ),
              const SizedBox(height: 15),

              // Main text
              Text(
                // "Upload video",
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? CbColors.lightGrey : CbColors.darkerGrey,
                ),
              ),
              const SizedBox(height: 8),

              // Subtext
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child:  Text(
                  // "Selecionar arquivo de video. Tamanho máx 50mb.",
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDarkMode ? CbColors.lightGrey : CbColors.darkerGrey,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Select files button
              CbPrimaryBtn(label: 'Selecionar', fontSize: 13, onPressed: onSelectFiles)
            ],
          ),
        ),
      ) : fileType == FileType.image ? Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(20),
            child: Image.file(
              uploadImageController.selectedFile.value ?? File(''),
              height: 250,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),

          const SizedBox(height: CbSizes.spaceBtwItems,),

          CbPrimaryBtn(label: 'Trocar Imagem', onPressed: onSelectFiles),
        ],
      ) : Column(
        children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: VideoPlayerView(url: uploadImageController.selectedVideo.value!.path, dataSourceType: DataSourceType.file)
          ),
          const SizedBox(height: CbSizes.spaceBtwItems,),

          CbPrimaryBtn(label: 'Trocar vídeo', fontSize: 13, onPressed: onSelectFiles)
        ],
      )
    );
    
  }
}
