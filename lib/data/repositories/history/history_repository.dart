import 'package:carboneto/data/repositories/authentication/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carboneto/features/library/models/history_model.dart';

class HistoryRepository {
  final _firestore = FirebaseFirestore.instance;

  String get uid => AuthenticationRepository.instance.authUser!.uid;

  CollectionReference get _historyCollection =>
      _firestore.collection('users').doc(uid).collection('trainingHistory');

  Stream<List<TrainingHistoryModel>> streamRecent({int limit = 6}) {
    return _historyCollection
        .orderBy('SessionEndedAt', descending: true)
        .limit(limit)
        .snapshots() 
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TrainingHistoryModel.fromDoc(doc))
          .toList();
    });
  }

  Future<HistoryPage> fetchInitial({int pageSize = 6}) async {
    final query = await _historyCollection
        .orderBy('SessionEndedAt', descending: true)
        .limit(pageSize)
        .get();

    final items =
        query.docs.map((e) => TrainingHistoryModel.fromDoc(e)).toList();
    final lastDoc = query.docs.isNotEmpty ? query.docs.last : null;
    final hasMore = query.docs.length >= pageSize;

    return HistoryPage(
      items: items,
      lastDoc: lastDoc,
      hasMore: hasMore,
    );
  }

  Future<HistoryPage> fetchMore({
    required DocumentSnapshot lastDoc,
    int pageSize = 6,
  }) async {
    final query = await _historyCollection
        .orderBy('SessionEndedAt', descending: true)
        .startAfterDocument(lastDoc)
        .limit(pageSize)
        .get();

    final items =
        query.docs.map((e) => TrainingHistoryModel.fromDoc(e)).toList();
    final newLastDoc = query.docs.isNotEmpty ? query.docs.last : null;
    final hasMore = query.docs.length >= pageSize;

    return HistoryPage(
      items: items,
      lastDoc: newLastDoc,
      hasMore: hasMore,
    );
  }
}

class HistoryPage {
  final List<TrainingHistoryModel> items;
  final DocumentSnapshot? lastDoc;
  final bool hasMore;

  HistoryPage({
    required this.items,
    required this.lastDoc,
    required this.hasMore,
  });
}
