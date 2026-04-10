import 'package:carboneto/data/repositories/history/history_repository.dart';
import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/features/library/controllers/all_trainings_controller.dart';
import 'package:carboneto/features/library/models/history_model.dart';
import 'package:carboneto/features/library/screens/history_screen/history.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  static HistoryController get instance => Get.find();

  final HistoryRepository _repository = HistoryRepository();
  final TrainingRepository _trainingRepository = TrainingRepository();

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  final RxList<TrainingHistoryModel> history = <TrainingHistoryModel>[].obs;
  final RxList<TrainingHistoryModel> recent = <TrainingHistoryModel>[].obs;

  final RxBool isLoadingRecent = true.obs; 
  final RxBool isLoadingHistory = false.obs; 
  final RxBool isLoadingMore = false.obs; 

  var showTrainingBy = 'Recentes'.obs;
  final RxBool hasMore = true.obs;
  static const int pageSize = 10; 
  DocumentSnapshot? _lastDoc;

  @override
  void onInit() {
    super.onInit();
    _bindRecentHistory();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 300) {
        fetchMore();
      }
    });

    // Sync with Firebase changes from the main trainings list (like picture updates)
    if (Get.isRegistered<AllTrainingsController>()) {
      ever(Get.find<AllTrainingsController>().trainings, (_) {
        recent.refresh();
        history.refresh();
      });
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }

  void _bindRecentHistory() {
    isLoadingRecent.value = true;

    recent.bindStream(
      _repository.streamRecent(limit: 6).map((items) {
        isLoadingRecent.value = false;
        return items;
      }),
    );
  }

  void openHistoryScreen() {
    if (history.isEmpty) {
      fetchInitial();
    }
    Get.to(() => const HistoryScreen());
  }

  void handleHistory() {
    if (history.isEmpty) {
      fetchInitial();
    }
    Get.to(() => const HistoryScreen());
  }

  Future<void> fetchInitial() async {
    try {
      isLoadingHistory.value = true;
      hasMore.value = true;
      _lastDoc = null;
      history.clear();

      final page = await _repository.fetchInitial(pageSize: pageSize);

      _lastDoc = page.lastDoc;
      history.assignAll(page.items);
      hasMore.value = page.hasMore;
    } catch (e) {
      debugPrint('Erro ao buscar histórico inicial: $e');
    } finally {
      isLoadingHistory.value = false;
    }
  }

  Future<void> fetchMore() async {
    if (isLoadingMore.value || !hasMore.value || _lastDoc == null) return;

    try {
      isLoadingMore.value = true;

      final page = await _repository.fetchMore(
        lastDoc: _lastDoc!,
        pageSize: pageSize,
      );

      _lastDoc = page.lastDoc;
      history.addAll(page.items);
      hasMore.value = page.hasMore;
    } catch (e) {
      debugPrint('Erro ao buscar mais histórico: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshHistory() async {
    // 1. Force the UI to show the shimmer loading for the recent section
    isLoadingRecent.value = true; 
    
    // 2. Fetch the paginated 'Ver tudo' history again
    await fetchInitial(); 
    
    // 3. Re-bind the stream so Firestore fetches fresh data for the 'recent' section
    _bindRecentHistory(); 
  }

  void setShowTrainingBy(String value) {
    showTrainingBy.value = value;
  }

  Future<TrainingModel?> handleTrainingHistoryDetails(String trainingId) async {
    return _trainingRepository.fetchTrainingById(trainingId);
  }

  Future<void> removeTrainingFromHistory(
      String historyId, String userId) async {
    try {
      history.removeWhere((item) => item.id == historyId);

      final db = _trainingRepository.trainingHistoryRef(userId, historyId);
      await db.delete();

    } catch (e) {
      debugPrint('Erro ao remover: $e');
    }
  }
}