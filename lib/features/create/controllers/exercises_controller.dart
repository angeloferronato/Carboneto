import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:get/get.dart';

class ExercisesController extends GetxController {
  static ExercisesController get instance => Get.find();

  final exercises = <ExerciseModel>[].obs;
  final _trainingRepository = Get.put(TrainingRepository());

  //final RxList<Map<String, dynamic>> exercises = [
  //   {
  //     'title': 'Alternância de Mãos',
  //     'trainer': 'Stephen Curry',
  //     'category': 'Arremesso',
  //     'type': 'Forma do Arremesso',
  //     'duration': '40 min',
  //     'thumbnail': CbImages.thumbnailTrainingExample,
  //   },
  //   {
  //     'title': 'Controle de Bola Estacionário',
  //     'trainer': 'Kyrie Irving',
  //     'category': 'Drible',
  //     'type': 'Manuseio de Bola',
  //     'duration': '30 min',
  //     'thumbnail': CbImages.thumbnailTrainingExample,
  //   },
  //   {
  //     'title': 'Finalizações em Movimento',
  //     'trainer': 'Ja Morant',
  //     'category': 'Finalização',
  //     'type': 'Bandejas e Contato',
  //     'duration': '35 min',
  //     'thumbnail': CbImages.thumbnailTrainingExample,
  //   },
  //   {
  //     'title': 'Arremesso de 3 Pontos',
  //     'trainer': 'Damian Lillard',
  //     'category': 'Arremesso',
  //     'type': 'Longa Distância',
  //     'duration': '45 min',
  //     'thumbnail': CbImages.thumbnailTrainingExample,
  //   },
  //   {
  //     'title': 'Post Moves Fundamentais',
  //     'trainer': 'Joel Embiid',
  //     'category': 'Post',
  //     'type': 'Movimentos de Costa para o Aro',
  //     'duration': '50 min',
  //     'thumbnail': CbImages.thumbnailTrainingExample,
  //   },
  //   {
  //     'title': 'Condicionamento de Quadra Inteira',
  //     'trainer': 'Giannis Antetokounmpo',
  //     'category': 'Condicionamento',
  //     'type': 'Resistência e Explosão',
  //     'duration': '25 min',
  //     'thumbnail': CbImages.thumbnailTrainingExample,
  //   },
  //   {
  //     'title': 'Defesa 1x1',
  //     'trainer': 'Marcus Smart',
  //     'category': 'Defesa',
  //     'type': 'Posicionamento e Reação',
  //     'duration': '30 min',
  //     'thumbnail': CbImages.thumbnailTrainingExample,
  //   },
  //   {
  //     'title': 'Leitura de Pick and Roll',
  //     'trainer': 'Chris Paul',
  //     'category': 'Tomada de Decisão',
  //     'type': 'Criação de Jogadas',
  //     'duration': '40 min',
  //     'thumbnail': CbImages.thumbnailTrainingExample,
  //   },
  //   {
  //     'title': 'Rotação Defensiva',
  //     'trainer': 'Draymond Green',
  //     'category': 'Defesa',
  //     'type': 'Comunicação e Cobertura',
  //     'duration': '35 min',
  //     'thumbnail': CbImages.thumbnailTrainingExample,
  //   },
  //   {
  //     'title': 'Movimentação Sem a Bola',
  //     'trainer': 'Klay Thompson',
  //     'category': 'Ataque',
  //     'type': 'Espaçamento e Cortes',
  //     'duration': '30 min',
  //     'thumbnail': CbImages.thumbnailTrainingExample,
  //   },
  //   {
  //     'title': 'Passe em Transição',
  //     'trainer': 'Lonzo Ball',
  //     'category': 'Passe',
  //     'type': 'Ritmo e Precisão',
  //     'duration': '20 min',
  //     'thumbnail': CbImages.thumbnailTrainingExample,
  //   },
  // ].obs;

  final RxList<int> selectedIndexes = <int>[].obs;

  Future<List<ExerciseModel>> fetchAllExercises() async {
    try {
      final fetchedExercises = await _trainingRepository.fetchAllExercises();
      // Atualiza a lista observável, o Obx no widget será reconstruído
      exercises.assignAll(fetchedExercises); 
      return fetchedExercises;
    } catch (e) {
      // Re-lança a exceção para que o FutureBuilder possa capturá-la
      rethrow; 
    }
  }

  bool isSelected(int index) => selectedIndexes.contains(index);

  void toggleSelection(int index) {
    if (isSelected(index)) {
      selectedIndexes.remove(index);
    } else {
      selectedIndexes.add(index);
    }
  }

  int get selectedCount => selectedIndexes.length;
}