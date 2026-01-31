import 'package:carboneto/data/repositories/authentication/authentication_repository.dart';
import 'package:carboneto/features/library/models/history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  static HistoryController get instance => Get.find();

  final RxList<TrainingHistoryModel> history = <TrainingHistoryModel>[].obs;
  final RxList<TrainingHistoryModel> recent = <TrainingHistoryModel>[].obs;

  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;


  static const int pageSize = 6;

  DocumentSnapshot? _lastDoc;

  final _firestore = FirebaseFirestore.instance;

  String get uid => AuthenticationRepository.instance.authUser!.uid;

  @override
  void onInit() {
    super.onInit();
    fetchRecent(); 
    fetchInitial(); 
  }


  Future<void> fetchRecent() async {
    final query = await _firestore
        .collection('users')
        .doc(uid)
        .collection('trainingHistory')
        .orderBy('sessionEndedAt', descending: true)
        .limit(6)
        .get();

    recent.assignAll(
      query.docs.map((e) => TrainingHistoryModel.fromDoc(e)).toList(),
    );
  }


  Future<void> fetchInitial() async {
    hasMore.value = true;
    _lastDoc = null;
    history.clear();

    final query = await _firestore
        .collection('users')
        .doc(uid)
        .collection('trainingHistory')
        .orderBy('sessionEndedAt', descending: true)
        .limit(pageSize)
        .get();

    if (query.docs.isNotEmpty) {
      _lastDoc = query.docs.last;
      history.assignAll(
        query.docs.map((e) => TrainingHistoryModel.fromDoc(e)).toList(),
      );
    }

    if (query.docs.length < pageSize) {
      hasMore.value = false;
    }
  }

  Future<void> fetchMore() async {
    if (isLoadingMore.value || !hasMore.value || _lastDoc == null) return;

    isLoadingMore.value = true;

    final query = await _firestore
        .collection('users')
        .doc(uid)
        .collection('trainingHistory')
        .orderBy('sessionEndedAt', descending: true)
        .startAfterDocument(_lastDoc!)
        .limit(pageSize)
        .get();

    if (query.docs.isNotEmpty) {
      _lastDoc = query.docs.last;
      history.addAll(
        query.docs.map((e) => TrainingHistoryModel.fromDoc(e)).toList(),
      );
    }

    if (query.docs.length < pageSize) {
      hasMore.value = false;
    }

    isLoadingMore.value = false;
  }

  // Opcional: força refresh completo
  Future<void> refreshHistory() async {
    await fetchRecent();
    await fetchInitial();
  }
}
