import 'dart:io';

import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/popups/full_screen_loader.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class UploadImageController extends GetxController {
  static UploadImageController get instance => Get.find();
  final selectedFile = Rx<File?>(null);
  final selectedVideo = Rx<File?>(null);
  final List<String> allowedExtensions = ['mp4', 'mov', 'avi', 'mkv', 'webm'];


  Future<void> pickSingleFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      selectedFile.value = File(result.files.single.path!);
    } else {
      selectedFile.value = null;
    }
  }


  Future<void> pickSingleVideo(int maxVideoSizeMB) async {
    CbFullScreenLoader.openLoadingDialog('Estamos verificando seu vídeo...', CbImages.loadingAnimation);
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);

      int fileSizeInBytes = await file.length();
      double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

      if (fileSizeInMB > maxVideoSizeMB) {
        CbLoaders.warningSnackBar(
          title: "Arquivo muito grande",
          message: "O vídeo selecionado tem ${fileSizeInMB.toStringAsFixed(1)} MB. O limite é de $maxVideoSizeMB MB.",
        );
        selectedVideo.value = null;
        CbFullScreenLoader.stopLoading();
        return;
      }

      selectedVideo.value = file;
    } else {
      selectedVideo.value = null;
    }

    CbFullScreenLoader.stopLoading();
  }

}