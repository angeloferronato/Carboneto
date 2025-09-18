import 'dart:async';
import 'package:carboneto/utils/helpers/network_manager.dart';
import 'package:get/get.dart';

class TrainingController extends GetxController {
  static TrainingController get instance => Get.find();

  late Rx<Duration> duration;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    duration = Duration(minutes: 1).obs;
    executeTraining();
  }

  Future<void> executeTraining() async {
    final isConnected = await NetworkManager.instance.isConnected();
    if(!isConnected) return;

    startTimer();
  }

  void minusTime() {
    duration.value = Duration(seconds: duration.value.inSeconds - 1);
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => minusTime());
  } 
}