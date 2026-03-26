import 'dart:async';
import 'package:carboneto/data/repositories/authentication/authentication_repository.dart';
import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

class AllTrainingsController extends GetxController {
  static AllTrainingsController get instance => Get.find();

  final _repo = Get.put(TrainingRepository());
  final _authRepo = AuthenticationRepository.instance;

  final ScrollController scrollController = ScrollController();

  final RxList<TrainingModel> trainings = <TrainingModel>[].obs;
  final RxBool isLoading = true.obs;
  
  final selectedFilter = 'Recentes'.obs;
  final selectedCategory = 'Todos'.obs;


  final Map<String, TrainingModel> localCache = {};
  StreamSubscription<List<String>>? _streamSubscription;

  final List<String> filterOptions = [
    'Recentes', 'A-Z (Nome)', 'Maiores (Duração)', 'Menores (Duração)',
  ];

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 500), () {
      setCategory('Todos');
    });
  }

  @override
  void onClose() {
    _streamSubscription?.cancel();
    scrollController.dispose();
    super.onClose();
  }


  void setCategory(String category) {
    selectedCategory.value = category;
    isLoading.value = true;
    trainings.clear();

    final user = _authRepo.authUser;
    final userId = user?.uid;

    if (userId == null) {
      isLoading.value = false;
      return;
    }

    _streamSubscription?.cancel();

    Stream<List<String>> targetStream;

    // Streams Individuais
    final streamCreated = _repo.getCreatedIdsStream(userId);
    final streamSaved = _repo.getSavedIdsStream(userId);
    final streamLiked = _repo.getLikedIdsStream(userId);

    if (category == 'Salvos') {
      targetStream = streamSaved;
    } else if (category == 'Curtidos') {
      targetStream = streamLiked;
    } else {

      
      targetStream = CombineLatestStream.list<List<String>>([
        streamCreated,
        streamSaved,
        streamLiked
      ]).map((List<List<String>> values) {
        final created = values[0];
        final saved = values[1];
        final liked = values[2];

        return {...created, ...saved, ...liked}.toList();
      });
    }

    // OUVINTE EM TEMPO REAL
    _streamSubscription = targetStream.listen((ids) async {
      await _handleNewIds(ids);
    }, onError: (e) {
      print("ERRO NO STREAM: $e");
      isLoading.value = false;
    });
  }

  

  Future<void> _handleNewIds(List<String> ids) async {
    if (ids.isEmpty) {
      trainings.clear();
      isLoading.value = false;
      return;
    }

    try {
      final idsToFetch = ids.where((id) => !localCache.containsKey(id)).toList();

      if (idsToFetch.isNotEmpty) {
        for (var i = 0; i < idsToFetch.length; i += 10) {
          final end = (i + 10 < idsToFetch.length) ? i + 10 : idsToFetch.length;
          final chunk = idsToFetch.sublist(i, end);
          
          final fetchedModels = await _repo.fetchTrainingsByIds(chunk);
          
          for (var model in fetchedModels) {
            localCache[model.id] = model;
          }
        }
      }

      // 3. Monta a lista completa usando o Cache
      List<TrainingModel> finalList = [];
      for (var id in ids) {
        if (localCache.containsKey(id)) {
          finalList.add(localCache[id]!);
        }
      }

      if (!['Todos', 'Salvos', 'Curtidos'].contains(selectedCategory.value)) {
        finalList = finalList.where((t) {
          // Verifica array de categorias (normalizando para minúsculo para evitar erro)
          return t.categories.any((c) => c.toLowerCase() == selectedCategory.value.toLowerCase()) ||
                 t.categories.contains(selectedCategory.value);
        }).toList();
      }

      // 5. Ordenação
      _applySortInMemory(finalList);

      trainings.assignAll(finalList);
      
    } catch (e) {
      print("Erro ao processar lista: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _applySortInMemory(List<TrainingModel> list) {
    switch (selectedFilter.value) {
      case 'Recentes':
        list.sort((a, b) => (b.postedAt ?? Timestamp.now())
            .compareTo(a.postedAt ?? Timestamp.now()));
        break;
      case 'A-Z (Nome)':
        list.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Maiores (Duração)':
        list.sort((a, b) => (b.duration ?? 0).compareTo(a.duration ?? 0));
        break;
      case 'Menores (Duração)':
        list.sort((a, b) => (a.duration ?? 0).compareTo(b.duration ?? 0));
        break;
    }
  }

  void resetToDefaults() {
    selectedCategory.value = 'Todos';
    selectedFilter.value = 'Recentes';

    setCategory('Todos'); 
  }

  void updateSort(String option) {
    selectedFilter.value = option;
    List<TrainingModel> currentList = List.from(trainings);
    _applySortInMemory(currentList);
    trainings.assignAll(currentList);
  }

  void showFilterModal(bool isDarkMode) {
     Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDarkMode ? CbColors.dark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ordenar por', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : CbColors.dark)),
            const SizedBox(height: 15),
            ...filterOptions.map((option) => Obx(() => ListTile(
                  onTap: () { updateSort(option); Get.back(); },
                  title: Text(option, style: TextStyle(
                      color: selectedFilter.value == option ? CbColors.primary : (isDarkMode ? Colors.white : CbColors.dark),
                      fontWeight: selectedFilter.value == option ? FontWeight.bold : FontWeight.normal)),
                  trailing: selectedFilter.value == option ? const Icon(Icons.check, color: CbColors.primary) : null,
                  contentPadding: EdgeInsets.zero,
                ))),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}