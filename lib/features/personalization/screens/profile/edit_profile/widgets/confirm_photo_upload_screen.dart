import 'dart:io';
import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/buttons/cb_primary_btn.dart';
import 'package:carboneto/features/create/controllers/upload_image_controller.dart';
import 'package:carboneto/features/personalization/controllers/edit_profile/edit_profile_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class ConfirmPhotoUploadScreen extends StatelessWidget {
  ConfirmPhotoUploadScreen ({super.key});

  final UploadImageController uploadImageController = Get.put(UploadImageController());
  final controller = Get.put(EditProfileController());
  @override
  Widget build(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: CbAppBar(
        title: Text('Pré-Visualização', style: Theme.of(context).textTheme.headlineSmall,),
        leadingIcon: Icons.clear_rounded,
        leadingOnPressed: () => Get.back(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(CbSizes.defaultSpace),
          child: SizedBox(
            height: CbHelperFunctions.screenHeight() * 0.6,
            child: Center(
              child: ClipOval(
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: PhotoView(
                    imageProvider: FileImage(uploadImageController.selectedFile.value ?? File('')),
                    backgroundDecoration: BoxDecoration(
                      color: isDarkMode ? CbColors.dark : CbColors.white,
                    ),
                    loadingBuilder: (context, event) => CircularProgressIndicator(color: CbColors.primary,),
                    maxScale: PhotoViewComputedScale.covered * 2.5,
                    minScale: PhotoViewComputedScale.contained,
                  ),
                ),
              ),
            ),
          )
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(CbSizes.defaultSpace),
        child: CbPrimaryBtn(
            label: CbTexts.cbContinue, 
            onPressed: () => controller.uploadProfileImageToFirebase(),
            paddingV: 15,
            paddingH: 40,
          )
      ),
    );
  }
}