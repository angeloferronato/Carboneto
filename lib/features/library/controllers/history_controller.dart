import 'package:carboneto/data/repositories/history/history_repository.dart';
import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/features/library/models/history_model.dart';
import 'package:carboneto/features/library/screens/history_screen/history.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  final HistoryRepository _repository = HistoryRepository();
  final TrainingRepository _trainingRepository = TrainingRepository();

  final RxList<TrainingHistoryModel> history = <TrainingHistoryModel>[].obs;
  final RxList<TrainingHistoryModel> recent = <TrainingHistoryModel>[].obs;
  final RxBool isLoadingMore = false.obs;

  var showTrainingBy = 'Recentes'.obs;

  final RxBool hasMore = true.obs;
  static const int pageSize = 6;
  DocumentSnapshot? _lastDoc;

  @override
  void onInit() {
    super.onInit();
    fetchRecent();
    fetchInitial();
  }

  void handleHistory() {
    Get.to(HistoryScreen());
  }

  void setShowTrainingBy(String value) {
    showTrainingBy.value = value;
  }

  Future<TrainingModel?> handleTrainingHistoryDetails(String trainingId) async {
    final trainingRepo = TrainingRepository.instance;

    return trainingRepo.fetchTrainingById(trainingId);
  }

  Future<void> fetchRecent() async {
    final items = await _repository.fetchRecent(limit: 6);
    recent.assignAll(items);
  }

  Future<void> fetchInitial() async {
    hasMore.value = true;
    _lastDoc = null;
    history.clear();

    final page = await _repository.fetchInitial(pageSize: pageSize);

    _lastDoc = page.lastDoc;
    history.assignAll(page.items);
    hasMore.value = page.hasMore;
  }

  Future<void> fetchMore() async {
    if (isLoadingMore.value || !hasMore.value || _lastDoc == null) return;

    isLoadingMore.value = true;

    final page = await _repository.fetchMore(
      lastDoc: _lastDoc!,
      pageSize: pageSize,
    );

    _lastDoc = page.lastDoc;
    history.addAll(page.items);
    hasMore.value = page.hasMore;

    isLoadingMore.value = false;
  }

  Future<void> refreshHistory() async {
    await fetchRecent();
    await fetchInitial();
  }
}
