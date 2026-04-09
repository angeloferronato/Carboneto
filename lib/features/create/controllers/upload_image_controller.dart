import 'dart:io';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:carboneto/utils/popups/full_screen_loader.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';

class UploadImageController extends GetxController {
  static UploadImageController get instance => Get.find();
  final selectedFile = Rx<File?>(null);
  final selectedVideo = Rx<File?>(null);
  final List<String> allowedExtensions = ['mp4', 'mov', 'avi', 'mkv', 'webm'];

  Future<void> pickSingleFile(
      {UploadImageFormat format = UploadImageFormat.normal}) async {
    XFile? result = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (result == null) return;

    final isDarkMode = CbHelperFunctions.isDarkMode(Get.context!);
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: result.path,
      aspectRatio: CropAspectRatio(
        ratioX: format == UploadImageFormat.banner ? 3 : 1,
        ratioY: format == UploadImageFormat.banner ? 2 : 1,
      ),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Ajustar imagem',
          statusBarLight: !isDarkMode,
          cropStyle: format == UploadImageFormat.square 
              ? CropStyle.circle
              : CropStyle.rectangle,
          aspectRatioPresets: format == UploadImageFormat.banner
              ? [CropAspectRatioPreset.ratio3x2]
              : [CropAspectRatioPreset.square],
          lockAspectRatio: [UploadImageFormat.square, UploadImageFormat.banner]
              .contains(format),
          toolbarColor: isDarkMode ? CbColors.dark : CbColors.white,
          toolbarWidgetColor: isDarkMode ? CbColors.white : CbColors.dark,
          backgroundColor: isDarkMode ? CbColors.dark : CbColors.white,
          activeControlsWidgetColor: CbColors.primary,
        ),
        IOSUiSettings(
          title: 'Ajustar imagem',
          cropStyle: format == UploadImageFormat.square 
              ? CropStyle.circle
              : CropStyle.rectangle,
        ),
      ],
    );

    if (croppedFile != null) {
      selectedFile.value = File(croppedFile.path);
    } else {
      selectedFile.value = null;
    }
  }

  Future<void> pickSingleVideo(int maxVideoSizeMB) async {
    CbFullScreenLoader.openLoadingDialog(
        'Estamos verificando seu vídeo...', CbImages.loadingAnimation);
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: allowedExtensions);

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);

      int fileSizeInBytes = await file.length();
      double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

      if (fileSizeInMB > maxVideoSizeMB) {
        CbLoaders.warningSnackBar(
          title: "Arquivo muito grande",
          message:
              "O vídeo selecionado tem ${fileSizeInMB.toStringAsFixed(1)} MB. O limite é de $maxVideoSizeMB MB.",
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

  Future<File?> compressVideo(File file) async {
    final result = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.MediumQuality,
    );
    return result?.file;
  }

  Future<File?> compressImage(File file, {bool reduceSize = false}) async {
    final directory = await getTemporaryDirectory();

    final targetPath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.webp';

    final size = reduceSize ? 512 : 1080;
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      format: CompressFormat.webp,
      minHeight: size,
      quality: 70,
      minWidth: size,
    );

    return File(result!.path);
  }
}
