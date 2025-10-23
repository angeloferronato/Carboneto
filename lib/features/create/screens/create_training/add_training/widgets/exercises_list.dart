import 'package:carboneto/features/create/controllers/exercises_controller.dart';
import 'package:carboneto/features/personalization/models/user_model.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Importação necessária para usar o repositório
import 'package:carboneto/data/repositories/user/user_repository.dart'; 

class ExercisesList extends StatelessWidget {
  ExercisesList({super.key});

  final controller = Get.put(ExercisesController());

  // --- FUNÇÃO INTEGRADA PARA BUSCAR A IMAGEM DE PERFIL ---
  /// Busca o URL da imagem de perfil do autor do exercício usando o UserRepository.
  /// Assume que `authorId` é o `id` do usuário no Firestore.
  Future<String> fetchAuthorProfilePicture(String authorId) async {
    try {
      if (authorId.isEmpty) {
        return ''; // Retorna string vazia se o ID for vazio
      }
      // Usa o UserRepository para buscar o UserModel
      final UserModel user = await UserRepository.instance.searchUser(authorId);
      // Retorna a URL da imagem de perfil. Assumindo que UserModel tem a propriedade profilePicture.
      return user.profilePicture; 
    } catch (e) {
      // Em caso de erro, retorna uma string vazia para exibir um placeholder
      debugPrint('Erro ao buscar imagem do autor $authorId: $e');
      return '';
    }
  }
  // --- FIM DA FUNÇÃO INTEGRADA ---

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<ExerciseModel>>(
        // Chama o método que busca os dados
        future: controller.fetchAllExercises(),
        builder: (context, snapshot) {
          // --- ESTADO DE ERRO ---
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar exercícios: ${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          // --- ESTADO DE CARREGAMENTO ---
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // --- ESTADO DE DADOS VAZIOS ---
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum exercício encontrado. 🤷‍♂️',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          // --- ESTADO DE DADOS CONCLUÍDOS ---
          return Obx(() {
            final exercises = controller.exercises;

            return Padding(
              padding: const EdgeInsets.only(top: 15),
              child: ListView.separated(
                itemCount: exercises.length,
                separatorBuilder: (_, __) => const SizedBox(height: 25),
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  
                  return Obx(() {
                    final isSelected = controller.isSelected(index);
                    
                    // Tratamento de dados da lista de categories para exibição
                    final categoriesText = exercise.categories != null && exercise.categories!.isNotEmpty
                        ? exercise.categories!.join(', ') // Junta os itens da lista com vírgula
                        : 'Sem Categoria';

                    return GestureDetector(
                      onTapDown: (_) => controller.toggleSelection(index),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 1.0, end: isSelected ? 0.97 : 1.0),
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeOut,
                        builder: (context, scale, child) {
                          return Transform.scale(
                            scale: scale,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOutCubic,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  // Linha de seleção animada
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeOutCubic,
                                    width: isSelected ? 5 : 0,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      color: isSelected ? CbColors.primary : CbColors.dark,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  // Conteúdo principal do item da lista
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isSelected
                                            ? CbColors.primary.withValues(alpha: 0.4)
                                            : CbColors.dark,
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        if (isSelected)
                                          BoxShadow(
                                            color: CbColors.primary.withValues(alpha: 0.2),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        // Substituído por ícone/placeholder, já que não temos 'thumbnail'
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: Image.asset(
                                            // Acesso a propriedades do ExerciseModel
                                            CbImages.trainingImageExample, 
                                            height: 90,
                                            width: 140,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 19),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  exercise.title,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: 'Plus Jakarta Sans',
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    // --- NOVO FutureBuilder PARA A IMAGEM DO PERFIL ---
                                                    FutureBuilder<String>(
                                                      future: fetchAuthorProfilePicture(exercise.authorId),
                                                      builder: (context, snapshot) {
                                                        final imageUrl = snapshot.data;
                                                        if (snapshot.connectionState == ConnectionState.done && imageUrl != null && imageUrl.isNotEmpty) {
                                                          // Imagem de perfil do Firebase
                                                          return CircleAvatar(
                                                            radius: 8,
                                                            backgroundImage: NetworkImage(imageUrl),
                                                            backgroundColor: CbColors.primary,
                                                          );
                                                        } else {
                                                          // Placeholder/Ícone padrão (enquanto carrega ou se não tiver imagem/erro)
                                                          return const CircleAvatar(
                                                            radius: 8,
                                                            backgroundColor: CbColors.primary,
                                                          );
                                                        }
                                                      },
                                                    ),
                                                    // --- FIM DO NOVO FutureBuilder ---

                                                    const SizedBox(width: 6),
                                                    // Usando o AuthorId como 'trainer'
                                                    Text(
                                                      exercise.authorId.isNotEmpty ? exercise.authorId : 'Autor Desconhecido',
                                                      style: const TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    const Icon(Icons.verified, color: Colors.amber, size: 10),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  // Usando as categories e duration
                                                  '$categoriesText · ${exercise.duration} min',
                                                  style: TextStyle(
                                                    color: Colors.white.withValues(alpha: 0.6),
                                                    fontSize: 10,
                                                    fontFamily: 'Plus Jakarta Sans',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        AnimatedContainer(
                                          duration: const Duration(milliseconds: 250),
                                          height: 32,
                                          width: 32,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? CbColors.primary.withValues(alpha: 0.25)
                                                : CbColors.primary.withValues(alpha: 0.15),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.play_arrow_rounded,
                                            color: CbColors.primary,
                                            size: 22,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  });
                },
              ),
            );
          });
        },
      ),
    );
  }
}