import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/features/create/controllers/upload_image_controller.dart';
import 'package:carboneto/features/personalization/controllers/edit_profile/edit_profile_controller.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmBannerUploadScreen extends StatelessWidget {
  const ConfirmBannerUploadScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());
    final UploadImageController uploadImageController = Get.put(UploadImageController());
    return Scaffold(
      appBar: CbAppBar(
        title: Text('Pré-Vizualização', style: Theme.of(context).textTheme.headlineSmall,),
        leadingIcon: Icons.clear_rounded,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(CbSizes.defaultSpace),
          child: SizedBox(
            height: CbHelperFunctions.screenHeight() * 0.6,
            child: Center(
              child: CbRoundedImage(imageUrl: '', isFileImage: true, file: uploadImageController.selectedFile.value,),
            ),
          )
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(CbSizes.defaultSpace),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => controller.uploadBannerToFirebase(), 
            child: Text('Continuar'),
          ),
        ),
      ),
    );
  }
}