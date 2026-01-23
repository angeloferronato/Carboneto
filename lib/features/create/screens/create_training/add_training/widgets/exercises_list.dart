import 'package:cached_network_image/cached_network_image.dart';
import 'package:carboneto/features/create/controllers/exercises_controller.dart';
import 'package:carboneto/features/personalization/models/user_model.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carboneto/data/repositories/user/user_repository.dart'; 

class ExercisesList extends StatelessWidget {
  ExercisesList({super.key});

  final controller = Get.put(ExercisesController());
  final userRepository = Get.put(UserRepository());
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<ExerciseModel>>(
        future: controller.fetchAllExercises(controller.exercises.isEmpty),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar exercícios: ${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum exercício encontrado.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          
          return Obx(() {
            final exercises = controller.exercises;

            return Padding(
              padding: const EdgeInsets.only(top: 15),
              child: ListView.builder(
                itemCount: exercises.length + 1,
                itemBuilder: (context, index) {
                  if (index == exercises.length) {
                    return Obx(() {
                      if (controller.lastDoc == null) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: Text(
                              "Todos os exercícios carregados.",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: ElevatedButton(
                                onPressed: () => controller.isLoadingMore.value
                                    ? null
                                    : controller.loadMoreExercises(10),
                                child: controller.isLoadingMore.value
                                    ? const CircularProgressIndicator(color: CbColors.white,)
                                    : const Text("Carregar mais"),
                              ),
                            ),
                          ),
                          const SizedBox(height: 85,),
                        ],
                      );
                    });
                  }

                  final exercise = exercises[index];
                  
                  return Obx(() {
                    final isSelected = controller.isSelected(index);
                    
                    final categoriesText = exercise.categories != null && exercise.categories!.isNotEmpty
                        ? exercise.categories!.join(', ') 
                        : 'Sem Categoria';

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: GestureDetector(
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
                                          
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child:
                                            CachedNetworkImage(
                                              imageUrl: exercise.thumb,
                                              fit: BoxFit.cover,
                                              
                                              placeholder: (context, url) => Container(
                                                color: CbColors.inputBG, 
                                                child: Icon(Icons.image, color: CbColors.primary,),
                                              ),
                                              
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
                                                    maxLines: 2, 
                                                    overflow: TextOverflow.ellipsis, 
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
                                                      
                                                      FutureBuilder<UserModel?>(
                                                        future: userRepository.fetchAuthorModel(exercise.authorId),
                                                        builder: (context, snapshot) {
                                                          final UserModel? author = snapshot.data;
                                                          final bool hasImage = author != null && author.profilePicture.isNotEmpty;
                      
                                                          
                                                          final Widget profileAvatar = CircleAvatar(
                                                            radius: 8,
                                                            backgroundImage: hasImage
                                                                ? NetworkImage(author.profilePicture)
                                                                : null,
                                                            backgroundColor: CbColors.primary,
                                                            child: hasImage ? null : const Icon(Icons.person, size: 10, color: CbColors.white),
                                                          );
                      
                                                          
                                                          Widget avatarWidget;
                                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                                            
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
                                                              
                                                              avatarWidget,
                                                              const SizedBox(width: 6),
                                                              
                                                              Text(
                                                                maxLines: 1, 
                                                                overflow: TextOverflow.ellipsis, 
                                                                author != null && author.name.isNotEmpty ? author.name : 'Autor Desconhecido',
                                                                style: const TextStyle(
                                                                  color: Colors.white70,
                                                                  fontSize: 10,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                              const SizedBox(width: 6),
                                                              if (author?.isVerified == true)
                                                                const Icon(Icons.verified, color: CbColors.primary, size: 10)
                                                              else
                                                                const SizedBox()
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                      
                      
                                                    ],
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    
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