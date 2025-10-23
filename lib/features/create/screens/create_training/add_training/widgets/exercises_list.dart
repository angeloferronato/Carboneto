import 'package:cached_network_image/cached_network_image.dart';
import 'package:carboneto/features/create/controllers/exercises_controller.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
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

  // --- FUNÇÃO ATUALIZADA PARA BUSCAR O USER MODEL COMPLETO ---
  /// Busca o UserModel do autor do exercício usando o UserRepository.
  /// Retorna o UserModel completo em caso de sucesso, ou null em caso de erro.
  Future<UserModel?> fetchAuthorModel(String authorId) async {
    try {
      if (authorId.isEmpty) {
        return null; // Retorna null se o ID for vazio
      }
      // Usa o UserRepository para buscar o UserModel
      // Assumindo que searchUser retorna um UserModel
      final UserModel user = await UserRepository.instance.searchUser(authorId);
      // Retorna o UserModel completo.
      return user; 
    } catch (e) {
      // Em caso de erro, retorna null.
      debugPrint('Erro ao buscar UserModel do autor $authorId: $e');
      return null;
    }
  }
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
                                          child:
                                          CachedNetworkImage(
                                            imageUrl: exercise.thumb,
                                            fit: BoxFit.cover,
                                            // Placeholder enquanto carrega
                                            placeholder: (context, url) => Container(
                                              color: CbColors.inputBG, // Um placeholder cinza
                                              child: Icon(Icons.image, color: CbColors.primary,),
                                            ),
                                            // Widget em caso de erro
                                            errorWidget: (context, url, error) => Container(
                                              color: Colors.grey[100],
                                              child: Icon(Icons.error, color: Colors.red),
                                            ),
                                            width: 140,
                                            height: 90,
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
                                                  maxLines: 2, // Limita a 1 linha
                                                  overflow: TextOverflow.ellipsis, // Mostra "..." se ultrapassar
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
                                                    // --- NOVO FutureBuilder PARA O USER MODEL ---
                                                    FutureBuilder<UserModel?>(
                                                      future: fetchAuthorModel(exercise.authorId),
                                                      builder: (context, snapshot) {
                                                        final UserModel? author = snapshot.data;
                                                        final bool hasImage = author != null && author.profilePicture.isNotEmpty;

                                                        // Use o NetworkImage se houver uma URL válida, caso contrário use um placeholder.
                                                        final Widget profileAvatar = CircleAvatar(
                                                          radius: 8,
                                                          backgroundImage: hasImage
                                                              ? NetworkImage(author.profilePicture)
                                                              : null,
                                                          backgroundColor: CbColors.primary,
                                                          child: hasImage ? null : const Icon(Icons.person, size: 10, color: CbColors.white),
                                                        );

                                                        // Exibe o avatar
                                                        Widget avatarWidget;
                                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                                          // Estado de carregamento
                                                          avatarWidget = const SizedBox(
                                                            height: 16,
                                                            width: 16,
                                                            child: CircularProgressIndicator(strokeWidth: 2, color: CbColors.primary),
                                                          );
                                                        } else {
                                                          avatarWidget = profileAvatar;
                                                        }

                                                        return Row(
                                                          children: [
                                                            // Avatar/Imagem do Perfil
                                                            avatarWidget,
                                                            const SizedBox(width: 6),
                                                            // Nome do Autor (usando fullName ou username, se existir)
                                                            Text(
                                                              maxLines: 1, // Limita a 1 linha
                                                              overflow: TextOverflow.ellipsis, 
                                                              author != null && author.name.isNotEmpty ? author.name : 'Autor Desconhecido',
                                                              style: const TextStyle(
                                                                color: Colors.white70,
                                                                fontSize: 10,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                            const SizedBox(width: 6),
                                                            if (author?.isVerify == true)
                                                              const Icon(Icons.verified, color: Colors.amber, size: 10)
                                                            else
                                                              const SizedBox()
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                    // --- FIM DO NOVO FutureBuilder ---

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