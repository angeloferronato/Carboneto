import 'package:carboneto/features/explore/screens/search_result/models/search_filters.dart';
import 'package:carboneto/features/explore/services/meili_search_service.dart';
import 'package:carboneto/features/personalization/models/user_search_model.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const _kCatMelhores   = 'Melhores';
const _kCatTreinos    = 'Treinos';
const _kCatUsuarios   = 'Usuários';
const _kCatExercicios = 'Exercícios';

const _kTabCategories = {
  _kCatMelhores,
  _kCatTreinos,
  _kCatUsuarios,
  _kCatExercicios,
};

class CbSearchController extends GetxController {
  static CbSearchController get instance => Get.find();

  final TextEditingController searchTextController = TextEditingController();

  final RxList<TrainingModel>   results         = <TrainingModel>[].obs;
  final RxList<UserSearchModel> userResults     = <UserSearchModel>[].obs;
  final RxList<ExerciseModel>   exerciseResults = <ExerciseModel>[].obs;

  final RxBool   isLoading    = false.obs;
  final RxBool   hasSearched  = false.obs;
  final RxString query        = ''.obs;

  final RxString activeTab = _kCatMelhores.obs;

  final RxList<String> selectedCategories = <String>[_kCatMelhores].obs;

  /// Exposed as Rx so FilterButton can reactively read the current state.
  final Rx<Map<String, dynamic>> activeFilters =
      Rx<Map<String, dynamic>>({});

  final Set<String> _followingIds = {};

  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;

  List<String>? get _trainingFilters {
    final tags = selectedCategories
        .where((c) => !_kTabCategories.contains(c))
        .toList();
    if (tags.isEmpty) return null;

    final expanded = <String>{};
    for (final tag in tags) {
      expanded.add(tag);
      if (CategoryMapper.mainCategories.contains(tag)) {
        expanded.addAll(CategoryMapper.subTagsFor(tag));
      }
    }
    return expanded.toList();
  }

  bool get _isSportTag => _trainingFilters != null;

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  // ─────────────────────────────────────────────
  // PUBLIC SEARCH
  // ─────────────────────────────────────────────

  Future<void> search(String text) async {
    final trimmed = text.trim();

    if (trimmed.isEmpty) {
      _reset();
      return;
    }

    try {
      query.value       = trimmed;
      isLoading.value   = true;
      hasSearched.value = true;

      final tab = activeTab.value;
      debugPrint('SEARCH tab="$tab" query="$trimmed" filters=$_trainingFilters');

      if (_isSportTag) {
        await _searchTrainings(trimmed);
        userResults.clear();
        exerciseResults.clear();

      } else if (tab == _kCatUsuarios) {
        await _loadFollowingIds();
        await _searchUsers(trimmed, limit: 20, excludeSelf: false);
        final verifiedOnly = activeFilters.value['verifiedOnly'] as bool? ?? false;
        if (verifiedOnly) {
          userResults.assignAll(userResults.where((u) => u.isVerified).toList());
        }
        results.clear();
        exerciseResults.clear();

      } else if (tab == _kCatTreinos) {
        await _searchTrainings(trimmed);
        userResults.clear();
        exerciseResults.clear();

      } else if (tab == _kCatExercicios) {
        await _searchExercises(trimmed);
        results.clear();
        userResults.clear();

      } else if (tab == _kCatMelhores) {
        exerciseResults.clear();
        await Future.wait([
          _searchTrainings(trimmed),
          _searchUsersWithFollowState(trimmed, limit: 1, excludeSelf: false),
        ]);

      } else {
        await Future.wait([
          _searchTrainings(trimmed),
          _searchExercises(trimmed),
          _searchUsersWithFollowState(trimmed, limit: 5, excludeSelf: true),
        ]);
      }
    } catch (e) {
      debugPrint('SEARCH ERROR: $e');
      results.clear();
      userResults.clear();
      exerciseResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // FILTER BUTTON
  // ─────────────────────────────────────────────

  Future<void> applyFilters(Map<String, dynamic> filters) async {
    activeFilters.value = filters;
    debugPrint('FILTERS APPLIED: $filters');
    if (query.value.isNotEmpty) await search(query.value);
  }

  // ─────────────────────────────────────────────
  // PRIVATE SEARCH HELPERS
  // ─────────────────────────────────────────────

  Future<void> _searchTrainings(String q) async {
    final hits = await MeiliSearchService.searchTrainings(
      query: q,
      categories: _trainingFilters,
    );
    var parsed = <TrainingModel>[];
    for (final hit in hits) {
      try {
        parsed.add(TrainingModel.fromJson(hit));
      } catch (e) {
        debugPrint('TRAINING PARSE ERROR: $e');
      }
    }

    parsed = _applyClientFilters(parsed);
    results.assignAll(parsed);
  }

  List<TrainingModel> _applyClientFilters(List<TrainingModel> list) {
    final f = activeFilters.value;
    if (f.isEmpty) return list;

    var filtered = list;

    // Verified only
    final verifiedOnly = f['verifiedOnly'] as bool? ?? false;
    if (verifiedOnly) {
      for (final t in filtered) {
        debugPrint('VERIFY CHECK [${t.title}] creator.isVerified=${t.creator.isVerified}');
      }
      filtered = filtered.where((t) => t.creator.isVerified).toList();
    }

    // Difficulty
    final difficulty = f['difficulty'] as String?;
    if (difficulty != null) {
      final target = _parseDifficulty(difficulty);
      if (target != null) {
        filtered = filtered.where((t) => t.level == target).toList();
      }
    }

    // Duration range (only apply when slider was moved from default 0–180)
    final durationMin = f['durationMin'] as int?;
    final durationMax = f['durationMax'] as int?;
    if (durationMin != null && durationMax != null &&
        !(durationMin == 0 && durationMax == 180)) {
      filtered = filtered.where((t) {
        final d = t.duration ?? 0;
        return d >= durationMin && d <= durationMax;
      }).toList();
    }

    // People count
    final people = f['peopleCount'] as int?;
    if (people != null) {
      filtered = filtered.where((t) {
        if (people == 1) return t.people == 1;
        if (people == 4) return t.people >= 2 && t.people <= 4;
        if (people == 5) return t.people >= 5;
        return true;
      }).toList();
    }

    // Order
    final order = f['order'] as String?;
    if (order != null) {
      switch (order) {
        case 'recent':
          filtered.sort((a, b) {
            final ta = a.postedAt?.toDate() ?? DateTime(0);
            final tb = b.postedAt?.toDate() ?? DateTime(0);
            return tb.compareTo(ta);
          });
          break;
        case 'popular':
          // Most popular = most views
          filtered.sort((a, b) => b.viewsCount.compareTo(a.viewsCount));
          break;
        case 'rating':
          // Best rated = most likes
          filtered.sort((a, b) => b.likesCount.compareTo(a.likesCount));
          break;
        case 'alphabetical':
          filtered.sort((a, b) => a.title.compareTo(b.title));
          break;
      }
    }

    return filtered;
  }

  DifficultyLevels? _parseDifficulty(String value) {
    switch (value.toLowerCase()) {
      case 'rookie':  return DifficultyLevels.rookie;
      case 'pro':     return DifficultyLevels.pro;
      case 'allstar': return DifficultyLevels.allstar;
      case 'elite':   return DifficultyLevels.elite;
      default:        return null;
    }
  }

  Future<void> _searchExercises(String q) async {
    final hits = await MeiliSearchService.searchExercises(query: q);
    final parsed = <ExerciseModel>[];
    for (final hit in hits) {
      try {
        parsed.add(ExerciseModel.fromMeili(hit));
      } catch (e) {
        debugPrint('EXERCISE PARSE ERROR: $e\nhit: $hit');
      }
    }
    exerciseResults.assignAll(parsed);
  }

  Future<void> _searchUsers(String q,
      {int limit = 20, bool excludeSelf = true}) async {
    final hits = await MeiliSearchService.searchUsers(query: q, limit: limit);
    _assignUsers(hits, excludeSelf: excludeSelf);
  }

  Future<void> _searchUsersWithFollowState(String q,
      {int limit = 5, bool excludeSelf = true}) async {
    await Future.wait([
      _loadFollowingIds(),
      MeiliSearchService.searchUsers(query: q, limit: limit)
          .then((hits) => _assignUsers(hits, excludeSelf: excludeSelf)),
    ]);
  }

  void _assignUsers(List<Map<String, dynamic>> hits,
      {bool excludeSelf = true}) {
    final parsedUsers = hits
        .map((hit) {
          try {
            final user = UserSearchModel.fromMeili(hit);
            if (excludeSelf && user.id == _currentUserId) return null;
            if ((activeFilters.value['verifiedOnly'] as bool? ?? false) && !user.isVerified) return null;
            return user.copyWith(isFollowing: _followingIds.contains(user.id));
          } catch (e) {
            debugPrint('USER PARSE ERROR: $e');
            return null;
          }
        })
        .whereType<UserSearchModel>()
        .toList();

    userResults.assignAll(parsedUsers);
  }

  // ─────────────────────────────────────────────
  // FOLLOW / UNFOLLOW
  // ─────────────────────────────────────────────

  Future<void> toggleFollow(UserSearchModel user) async {
    final uid = _currentUserId;
    if (uid == null) return;

    final idx = userResults.indexWhere((u) => u.id == user.id);
    if (idx == -1) return;

    final nowFollowing = !user.isFollowing;
    userResults[idx] = user.copyWith(isFollowing: nowFollowing);

    try {
      final followRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('following')
          .doc(user.id);

      if (nowFollowing) {
        await followRef.set({'followedAt': FieldValue.serverTimestamp()});
        _followingIds.add(user.id);
      } else {
        await followRef.delete();
        _followingIds.remove(user.id);
      }
    } catch (e) {
      debugPrint('FOLLOW ERROR: $e');
      userResults[idx] = user.copyWith(isFollowing: user.isFollowing);
    }
  }

  // ─────────────────────────────────────────────
  // CATEGORIES
  // ─────────────────────────────────────────────

  void setCategory(String category) {
    selectedCategories.clear();
    selectedCategories.add(category);
    activeTab.value =
        _kTabCategories.contains(category) ? category : 'SportTag';
    if (query.value.isNotEmpty) search(query.value);
  }

  void clearCategories() {
    selectedCategories.clear();
    selectedCategories.add(_kCatMelhores);
    activeTab.value = _kCatMelhores;
    if (query.value.isNotEmpty) search(query.value);
  }

  void clear() {
    searchTextController.clear();
    results.clear();
    userResults.clear();
    exerciseResults.clear();
    hasSearched.value   = false;
    query.value         = '';
    activeTab.value     = _kCatMelhores;
    activeFilters.value = {};
    selectedCategories
      ..clear()
      ..add(_kCatMelhores);
    _followingIds.clear();
  }

  // ─────────────────────────────────────────────
  // PRIVATE HELPERS
  // ─────────────────────────────────────────────

  void _reset() {
    results.clear();
    userResults.clear();
    exerciseResults.clear();
    hasSearched.value = false;
    query.value       = '';
  }

  Future<void> _loadFollowingIds() async {
    final uid = _currentUserId;
    if (uid == null) return;

    try {
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('following')
          .get();

      _followingIds
        ..clear()
        ..addAll(snap.docs.map((d) => d.id));
    } catch (e) {
      debugPrint('FOLLOWING LOAD ERROR: $e');
    }
  }
}