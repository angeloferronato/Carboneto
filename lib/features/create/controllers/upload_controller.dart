import 'package:get/get.dart';

enum UploadState { idle, preparing, uploading, processing, success, error }

class UploadStatusController extends GetxController {
  static UploadStatusController get instance => Get.find<UploadStatusController>();

  final Rx<UploadState> state = UploadState.idle.obs;
  final RxDouble progress = 0.0.obs;
  final RxString statusMessage = ''.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isMinimized = false.obs;

  bool get isActive => state.value != UploadState.idle;

  void startPreparing() {
    state.value = UploadState.preparing;
    progress.value = 0.0;
    statusMessage.value = 'Preparando envio...';
    errorMessage.value = '';
    isMinimized.value = false;
  }

  void startUploading() {
    state.value = UploadState.uploading;
    statusMessage.value = 'Enviando treino...';
  }

  void setProgress(double value) {
    progress.value = value.clamp(0.0, 1.0);
  }

  void startProcessing() {
    state.value = UploadState.processing;
    progress.value = 0.95;
    statusMessage.value = 'Finalizando...';
  }

  void setSuccess() {
    state.value = UploadState.success;
    progress.value = 1.0;
    statusMessage.value = 'Upload Concluído';
  }

  void setError(String message) {
    state.value = UploadState.error;
    statusMessage.value = 'Falha no envio';
    errorMessage.value = message;
  }

  void reset() {
    state.value = UploadState.idle;
    progress.value = 0.0;
    statusMessage.value = '';
    errorMessage.value = '';
    isMinimized.value = false;
  }

  void minimize() => isMinimized.value = true;
  void expand() => isMinimized.value = false;
}