import 'package:carboneto/common/widgets/texts/section_heading.dart';
import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/data/repositories/user/user_repository.dart';
import 'package:carboneto/features/authentication/screens/onboarding/widgets/top_logo.dart';
import 'package:carboneto/features/create/screens/create_training/add_training/widgets/categories_bar.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/features/training/screens/home/widgets/home_shimmer.dart';
import 'package:carboneto/features/training/screens/home/widgets/home_training_dart.dart';
import 'package:carboneto/features/training/screens/training_details/training_details.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen ({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future<List<TrainingModel>> _trainingsBallHandling;
  late final Future<List<TrainingModel>> _trainingsDribbling;
  late final Future<List<TrainingModel>> _trainingsMoves;
  late final Future<List<TrainingModel>> _trainingsShooting;
  final TrainingRepository trainingRepository = Get.put(TrainingRepository());
  final UserRepository userRepository = Get.put(UserRepository());

  @override
  void initState() {
    super.initState();
    _trainingsBallHandling = trainingRepository.fetchTrainingDetails('Ballhandling');
    _trainingsDribbling = trainingRepository.fetchTrainingDetails('Dribbling');
    _trainingsMoves = trainingRepository.fetchTrainingDetails('Moves');
    _trainingsShooting = trainingRepository.fetchTrainingDetails('Shooting');
  }

  @override
  Widget build(BuildContext context) {
    
    final bool isDarkTheme = CbHelperFunctions.isDarkMode(context);
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: CbSizes.defaultSpace),
            child: Column(
              children: [
                SafeArea(
                  child: TopLogo()
                ),
                Padding(
                    padding: const EdgeInsets.only(left: CbSizes.defaultSpace),
                    child: CategoriesBar(),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
                //   child: CbGridLayout(
                //     itemCount: 6,
                //     itemBuilder: (_, index) => TrainingLibItem(image: CbImages.trainingExample, text: CbTexts.trainingHomeTitleExample,),
                //     mainAxisExtent: 55,
                //   ),
                // ),

                const SizedBox(height: CbSizes.spaceBtwItems,),
                    
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
                  child: CbSectionHeading(title: 'Controle de Bola', onPressed: () {})
                ),
                    
                const SizedBox(height: CbSizes.spaceBtwItems,),
 
                FutureBuilder<List<TrainingModel>>(
                  future: _trainingsBallHandling, 
                  builder: (context, snapshot) {
                  
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: 250,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(left: CbSizes.md),
                          shrinkWrap: true,
                          itemCount: 2,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => HomeShimmer(),
                        ),
                      );
                    }
                
                    if (snapshot.hasError) {
                      return Center(child: Text("Erro: ${snapshot.error}"));
                    }
                
                    final trainings = snapshot.data ?? [];
                
                    if (trainings.isEmpty) {
                      return const Center(child: Text("Nenhum treino encontrado"));
                    }
                
                    return SizedBox(
                      height: 250,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: trainings.length,
                        padding: EdgeInsets.only(left: CbSizes.md),
                        itemBuilder: (_, index) {
                          final training = trainings[index];
                          String description = '';
                          for (var item in training.categories) {
                            description = '$description $item,';
                          }
                          description = '$description ${training.duration} min';
                          return HomeTrainingWidget(
                            imageThumbnail: training.thumbnail, 
                            level: training.level, 
                            trainerImage: training.user!.profilePicture, 
                            trainer: training.user!.name, 
                            description: description, 
                            title: training.title,
                            numberPerson: training.people,
                            onTap: () => Get.to(() => TrainingDetailsScreen(training: training,)),
                          );
                        },
                        scrollDirection: Axis.horizontal,
                      ),
                    );
                  }
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
                  child: CbSectionHeading(title: "Drible", onPressed: (){}),
                ),
                const SizedBox(height: CbSizes.spaceBtwItems,),
                    
                SizedBox(
                  height: 250,
                  child: FutureBuilder<List<TrainingModel>>(
                    future: _trainingsDribbling, 
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: 250,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(left: CbSizes.md),
                            shrinkWrap: true,
                            itemCount: 2,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => HomeShimmer(),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text("Erro: ${snapshot.error}"));
                      }

                      final trainings = snapshot.data ?? [];

                      if (trainings.isEmpty) {
                        return const Center(child: Text("Nenhum treino encontrado"));
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: trainings.length,
                        padding: EdgeInsets.only(left: CbSizes.md),
                        itemBuilder: (_, index) {
                          final training = trainings[index];
                          String description = '';
                          for (var item in training.categories) {
                            description = '$description $item,';
                          }
                          description = '$description ${training.duration} min';
                          return HomeTrainingWidget(
                            imageThumbnail: training.thumbnail, 
                            level: training.level, 
                            trainerImage: training.user!.profilePicture, 
                            trainer: training.user!.name, 
                            description: description, 
                            title: training.title,
                            numberPerson: training.people,
                            onTap: () => Get.to(() => TrainingDetailsScreen(training: training,)),
                          );
                        },
                        scrollDirection: Axis.horizontal,
                      );
                    }
                  )
                ),
                    
                const SizedBox(height: CbSizes.spaceBtwItems,),
                    
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
                  child: CbSectionHeading(title: 'Movimentos', onPressed: () {})
                ),
                    
                const SizedBox(height: CbSizes.spaceBtwItems,),
                    
                SizedBox(
                  height: 250,
                  child: FutureBuilder<List<TrainingModel>>(
                    future: _trainingsMoves, 
                    builder: (context, snapshot) {
                    
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: 250,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(left: CbSizes.md),
                            shrinkWrap: true,
                            itemCount: 2,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => HomeShimmer(),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text("Erro: ${snapshot.error}"));
                      }

                      final trainings = snapshot.data ?? [];

                      if (trainings.isEmpty) {
                        return const Center(child: Text("Nenhum treino encontrado"));
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: trainings.length,
                        padding: EdgeInsets.only(left: CbSizes.md),
                        itemBuilder: (_, index) {
                          final training = trainings[index];
                          String description = '';
                          for (var item in training.categories) {
                            description = '$description $item,';
                          }
                          description = '$description ${training.duration} min';
                          return HomeTrainingWidget(
                            imageThumbnail: training.thumbnail, 
                            level: training.level, 
                            trainerImage: training.user!.profilePicture, 
                            trainer: training.user!.name, 
                            description: description, 
                            title: training.title,
                            numberPerson: training.people,
                            onTap: () => Get.to(() => TrainingDetailsScreen(training: training,)),
                          );
                        },
                        scrollDirection: Axis.horizontal,
                      );
                    }
                  )
                ),

                const SizedBox(height: CbSizes.spaceBtwItems,),
                    
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
                  child: CbSectionHeading(title: 'Arremesso', onPressed: () {})
                ),
                    
                const SizedBox(height: CbSizes.spaceBtwItems,),
                    
                SizedBox(
                  height: 250,
                  child: FutureBuilder<List<TrainingModel>>(
                    future: _trainingsShooting, 
                    builder: (context, snapshot) {
                    
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: 250,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(left: CbSizes.md),
                            shrinkWrap: true,
                            itemCount: 2,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => HomeShimmer(),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text("Erro: ${snapshot.error}"));
                      }

                      final trainings = snapshot.data ?? [];

                      if (trainings.isEmpty) {
                        return const Center(child: Text("Nenhum treino encontrado"));
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: trainings.length,
                        padding: EdgeInsets.only(left: CbSizes.md),
                        itemBuilder: (_, index) {
                          final training = trainings[index];
                          String description = '';
                          for (var item in training.categories) {
                            description = '$description $item,';
                          }
                          description = '$description ${training.duration} min';
                          return HomeTrainingWidget(
                            imageThumbnail: training.thumbnail, 
                            level: training.level, 
                            trainerImage: training.user!.profilePicture, 
                            trainer: training.user!.name, 
                            description: description, 
                            title: training.title,
                            numberPerson: training.people,
                            onTap: () => Get.to(() => TrainingDetailsScreen(training: training,)),
                          );
                        },
                        scrollDirection: Axis.horizontal,
                      );
                    }
                  )
                ),

                SizedBox(height: 100,)
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}