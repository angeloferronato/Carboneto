import 'package:carboneto/data/repositories/exercises/exercise_repository.dart';
import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/features/create/controllers/create_training_controller.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/personalization/models/notification_model.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/features/training/screens/training_details/widgets/resume_training_sheet.dart';
import 'package:carboneto/features/training/screens/training_execution/training_execution.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/network_manager.dart';
import 'package:carboneto/utils/popups/full_screen_loader.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carboneto/data/repositories/follow/follow_repository.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class TrainingDetailsController extends GetxController {
  final TrainingRepository trainingRepository = Get.put(TrainingRepository());
  final UserController userController = Get.put(UserController());
  final ExerciseRepository exerciseRepository = Get.put(ExerciseRepository());
  final CreateTrainingController createTrainingController =
      Get.put(CreateTrainingController());
  final FollowRepository followRepository = Get.put(FollowRepository());

  final RxList<String> _followingIds = <String>[].obs;

  final isLoadingStats = false.obs;
  final isLoading = false.obs;
  final hasViewBeenCounted = false.obs;
  final isLiked = false.obs;
  final isSaved = false.obs;
  final likesCount = 0.obs;
  final savesCount = 0.obs;
  final viewsCount = 0.obs;

  Timer? _viewTimer;
  int _secondsOnScreen = 0;
  static const int viewThresholdSeconds = 20;

  // ─── STATS (fetch once on open) ───────────────────────────────────────────

  Future<void> initializeStats(TrainingModel training) async {
    isLoadingStats.value = true;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Single fetch — fresh data every time screen opens
      final doc = await FirebaseFirestore.instance
          .collection('allTrainings')
          .doc(training.id)
          .get();

      final data = doc.data();
      likesCount.value = (data?['Stats']?['likes'] ?? 0) as int;
      savesCount.value = (data?['Stats']?['saves'] ?? 0) as int;
      viewsCount.value = (data?['Stats']?['views'] ?? 0) as int;

      final status = await trainingRepository.checkInteractionStatus(
        trainingId: training.id,
        userId: user.uid,
      );
      isLiked.value = status['isLiked'] ?? false;
      isSaved.value = status['isSaved'] ?? false;
    } catch (e) {
      debugPrint('Error loading stats: $e');
    } finally {
      isLoadingStats.value = false;
    }
  }

  @override
  void onClose() {
    stopViewTracking();
    _viewTimer?.cancel();
    super.onClose();
  }

  // ─── LIKE ─────────────────────────────────────────────────────────────────

  void toggleLike(TrainingModel training) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Don't notify if the user is liking their own training
    if (user.uid == training.authorId) {
      isLiked.value = !isLiked.value;
      likesCount.value += isLiked.value ? 1 : -1;
      trainingRepository
          .toggleTrainingLike(trainingId: training.id, userId: user.uid)
          .catchError((e) {
        isLiked.value = !isLiked.value;
        likesCount.value += isLiked.value ? 1 : -1;
        Get.snackbar('Erro', 'Falha ao sincronizar curtida');
      });
      return;
    }

    final wasLiked = isLiked.value;
    isLiked.value = !isLiked.value;
    likesCount.value += isLiked.value ? 1 : -1;

    trainingRepository
        .toggleTrainingLike(trainingId: training.id, userId: user.uid)
        .then((_) {
      // Only send notification when liking, not unliking
      if (!wasLiked) {
        final notification = NotificationModel(
          type: NotificationType.likeTraining,
          fromUserId: user.uid,
          isRead: false,
        );
        Get.find<FollowRepository>()
            .sendNotification(notification, training.authorId)
            .catchError((e) => debugPrint('Falha ao enviar notificação: $e'));
      }
    }).catchError((e) {
      isLiked.value = !isLiked.value;
      likesCount.value += isLiked.value ? 1 : -1;
      Get.snackbar('Erro', 'Falha ao sincronizar curtida');
    });
  }

  // ─── SAVE ─────────────────────────────────────────────────────────────────

  void toggleSave(TrainingModel training) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    isSaved.value = !isSaved.value;
    savesCount.value += isSaved.value ? 1 : -1;

    trainingRepository
        .toggleTrainingSave(
            trainingId: training.id, userId: user.uid, trainingData: training)
        .catchError((e) {
      isSaved.value = !isSaved.value;
      savesCount.value += isSaved.value ? 1 : -1;
      Get.snackbar('Erro', 'Falha ao sincronizar salvamento');
    });
  }

  // ─── VIEW TRACKING ────────────────────────────────────────────────────────

  void startViewTracking(TrainingModel training) {
    if (hasViewBeenCounted.value) return;

    _secondsOnScreen = 0;
    _viewTimer?.cancel();

    _viewTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsOnScreen++;
      if (_secondsOnScreen >= viewThresholdSeconds &&
          !hasViewBeenCounted.value) {
        _recordView(training);
        timer.cancel();
      }
    });
  }

  void stopViewTracking() {
    _viewTimer?.cancel();
    _secondsOnScreen = 0;
  }

  Future<void> _recordView(TrainingModel training) async {
    if (hasViewBeenCounted.value) return;
    try {
      final uid = userController.user.value.id;
      if (uid.isEmpty) return;

      final canCount = await trainingRepository.canCountView(
        trainingId: training.id,
        userId: uid,
      );
      if (canCount) {
        await trainingRepository.recordTrainingView(
          trainingId: training.id,
          userId: uid,
        );
        hasViewBeenCounted.value = true;
        viewsCount.value++; // update locally since no stream
      }
    } catch (e) {
      debugPrint('Error recording view: $e');
    }
  }

  // ─── EXERCISES ───────────────────────────────────────────────────────────

  Future<TrainingModel> fetchExercises(TrainingModel training) async {
    isLoading.value = true;
    final uid = userController.user.value.id;
    if (uid.isNotEmpty) {
      try {
        final relations = await followRepository.loadRelations(uid);
        final dynamic rawFollowing = relations.length > 1 ? relations[1] : null;
        _followingIds.assignAll(
            List<String>.from(rawFollowing as Iterable? ?? const []));
      } catch (_) {}
    }

    bool canView(ExerciseModel e) {
      if (uid.isNotEmpty && e.authorId == uid) return true;
      switch (e.visibility) {
        case TrainingVisibility.public:
          return true;
        case TrainingVisibility.private:
          return false;
        case TrainingVisibility.followers:
          return uid.isNotEmpty && _followingIds.contains(e.authorId);
      }
      // Defensive fallback (should be unreachable).
      // ignore: dead_code
      return true;
    }

    final fetched = await exerciseRepository
        .fetchSpecificExerciseDetails(training.exercisesId ?? []);
    training.exercises = fetched.where(canView).toList();
    isLoading.value = false;
    return training;
  }

  // ─── DIALOGS ─────────────────────────────────────────────────────────────

  void showTrainingUserOptions(TrainingModel training) {
    stopViewTracking();
    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.only(
            left: CbSizes.md, right: CbSizes.md, bottom: CbSizes.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: const Text('Editar'),
              onTap: () => Get.back(),
            ),
            ListTile(
              leading: const Icon(Icons.delete_rounded, color: Colors.red),
              title: const Text('Deletar', style: TextStyle(color: Colors.red)),
              onTap: () => createTrainingController
                  .showCancelDeleteTrainingMessage(training),
            ),
          ],
        ),
      ),
    ).whenComplete(() {
      if (!hasViewBeenCounted.value) startViewTracking(training);
    });
  }

  Future<void> showStartTrainingOptions(
      TrainingModel training, bool isDarkMode) async {
    stopViewTracking();

    // ── 1. Check for existing progress ──────────────────────────────────────
    DocumentSnapshot? progressSnapshot;
    try {
      final uid = userController.user.value.id;
      if (uid.isNotEmpty) {
        progressSnapshot =
            await trainingRepository.getTrainingProgress(uid, training.id);
      }
    } catch (e) {
      debugPrint('Progress check failed: $e');
    }

    final _progressData = progressSnapshot?.data() as Map<String, dynamic>?;
    final _savedProgress = (_progressData?['TrainingProgress'] as int?) ?? 0;

    // Meaningful progress = user advanced at least one exercise
    // OR the training timer has ticked down by at least 15 seconds.
    final _exerciseIndex =
        (_progressData?['CurrentExerciseIndex'] as int?) ?? 0;
    final _remainingTime =
        (_progressData?['TrainingRemainingTime'] as int?) ?? 0;
    final _totalDuration = (_progressData?['TrainingDuration'] as int?) ?? 0;
    final _elapsedTime = _totalDuration - _remainingTime;

    final hasMeaningfulProgress = _exerciseIndex > 0 || _elapsedTime >= 15;

    final hasProgress = progressSnapshot != null &&
        progressSnapshot.exists &&
        _progressData?['Status'] == 'in_progress' &&
        hasMeaningfulProgress;

    // ── 2a. Existing progress → resume sheet ────────────────────────────────
    if (hasProgress) {
      final savedProgress = _savedProgress;

      await showModalBottomSheet(
        context: Get.context!,
        showDragHandle: false,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => ResumeTrainingSheet(
          isDark: isDarkMode,
          progress: savedProgress,
          onContinue: () {
            Get.back(); // close sheet
            startTraining(training, resumeFromSaved: true);
          },
          onStartOver: () {
            Get.back(); // close sheet
            startTraining(training, resumeFromSaved: false);
          },
        ),
      );

      if (!hasViewBeenCounted.value) startViewTracking(training);
      return;
    }

    // ── 2b. No progress → original confirmation dialog ──────────────────────
    await Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: CbSizes.lg),
      contentPadding: const EdgeInsets.all(CbSizes.lg),
      title: 'Você deseja continuar?',
      middleText: 'Temos um treino pronto para você! Deseja iniciá-lo?',
      confirm: ElevatedButton(
        onPressed: () => startTraining(training),
        style: ElevatedButton.styleFrom(
            backgroundColor: CbColors.primary,
            side: const BorderSide(color: CbColors.primary)),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: CbSizes.lg),
          child: Text('Sim'),
        ),
      ),
      cancel: OutlinedButton(
        onPressed: () {
          Navigator.of(Get.overlayContext!).pop();
          if (!hasViewBeenCounted.value) startViewTracking(training);
        },
        child: const Text('Não',),
      ),
      backgroundColor: isDarkMode ? CbColors.dark : CbColors.white,
    );
  }

  Future<void> startTraining(TrainingModel training,
      {bool resumeFromSaved = true}) async {
    try {
      CbFullScreenLoader.openLoadingDialog(
          'Estamos iniciando seu treino...', CbImages.loadingAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        CbLoaders.errorSnackBar(
            title: 'Sem conexão de internet!',
            message: 'Sem internet não é possível iniciar seu treino.');
        CbFullScreenLoader.stopLoading();
        return;
      }

      // ── Delete saved progress when the user chooses "start from zero" ──────
      if (!resumeFromSaved) {
        final uid = userController.user.value.id;
        if (uid.isNotEmpty) {
          await trainingRepository.deleteTrainingProgress(uid, training.id);
        }
      }

      // ── Count view if not yet recorded ──────────────────────────────────────
      if (!hasViewBeenCounted.value) {
        final uid = userController.user.value.id;
        final canCount = await trainingRepository.canCountView(
          trainingId: training.id,
          userId: uid,
        );
        if (canCount) {
          await trainingRepository.recordTrainingView(
            trainingId: training.id,
            userId: uid,
          );
          hasViewBeenCounted.value = true;
          viewsCount.value++;
        }
      }

      CbFullScreenLoader.stopLoading();
      Get.to(() => TrainingExecution(training: training));
    } catch (e) {
      CbFullScreenLoader.stopLoading();
      CbLoaders.errorSnackBar(title: 'Ah não!', message: e.toString());
    }
  }
}
