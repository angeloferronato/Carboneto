import 'package:carboneto/common/widgets/buttons/filter_button.dart';
import 'package:carboneto/common/widgets/searchinput/search_input.dart';
import 'package:carboneto/features/create/screens/create_training/add_training/widgets/categories_bar.dart';
import 'package:carboneto/common/widgets/result/result_widget.dart';
import 'package:carboneto/features/training/models/creator/creator_model.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class SearchResultScreen extends StatelessWidget {
  SearchResultScreen({super.key});

  final List<TrainingModel> fakeBasketballTrainings = [
    TrainingModel(
      id: 'bb_001',
      authorId: 'coach_001',
      title: 'Solo Ball Handling',
      description:
          'Improve your dribbling control, speed, and coordination with solo drills.',
      duration: 1230,
      categories: ['Basketball', 'Ball Handling'],
      level: DifficultyLevels.rookie,
      textLevel: 'Rookie',
      people: 1,
      thumbnail: 'https://picsum.photos/400/300?basketball1',
      exercises: [],
      exercisesId: [],
      creator: CreatorModel(
        name: 'Coach Alex',
        profilePicture: 'https://i.pravatar.cc/150?img=11',
        isVerified: true,
      ),
    ),
    TrainingModel(
      id: 'bb_002',
      authorId: 'coach_002',
      title: 'Shooting Fundamentals',
      description: 'Form shooting, catch & shoot, and consistency drills.',
      duration: 1245,
      categories: ['Basketball', 'Shooting'],
      level: DifficultyLevels.rookie,
      textLevel: 'Rookie',
      people: 1,
      thumbnail: 'https://picsum.photos/400/300?basketball2',
      exercises: [],
      exercisesId: [],
      creator: CreatorModel(
        name: 'Mike Shooter',
        profilePicture: 'https://i.pravatar.cc/150?img=12',
        isVerified: false,
      ),
    ),
    TrainingModel(
      id: 'bb_003',
      authorId: 'coach_003',
      title: '1v1 Offensive Moves',
      description: 'Learn effective offensive moves for isolation situations.',
      duration: 1250,
      categories: ['Basketball', 'Offense'],
      level: DifficultyLevels.pro,
      textLevel: 'Pro',
      people: 2,
      thumbnail: 'https://picsum.photos/400/300?basketball3',
      exercises: [],
      exercisesId: [],
      creator: CreatorModel(
        name: 'Jordan Skills',
        profilePicture: 'https://i.pravatar.cc/150?img=13',
        isVerified: true,
      ),
    ),
    TrainingModel(
      id: 'bb_004',
      authorId: 'coach_004',
      title: 'Defense & Footwork',
      description: 'Defensive stance, lateral movement, and reaction drills.',
      duration: 1240,
      categories: ['Basketball', 'Defense'],
      level: DifficultyLevels.pro,
      textLevel: 'Pro',
      people: 1,
      thumbnail: 'https://picsum.photos/400/300?basketball4',
      exercises: [],
      exercisesId: [],
      creator: CreatorModel(
        name: 'Coach Defense',
        profilePicture: 'https://i.pravatar.cc/150?img=14',
        isVerified: false,
      ),
    ),
    TrainingModel(
      id: 'bb_005',
      authorId: 'coach_005',
      title: 'Explosiveness & Vertical Jump',
      description: 'Plyometric and strength drills to increase jump height.',
      duration: 1260,
      categories: ['Basketball', 'Athleticism'],
      level: DifficultyLevels.elite,
      textLevel: 'Elite',
      people: 1,
      thumbnail: 'https://picsum.photos/400/300?basketball5',
      exercises: [],
      exercisesId: [],
      creator: CreatorModel(
        name: 'Elite Performance Lab',
        profilePicture: 'https://i.pravatar.cc/150?img=15',
        isVerified: true,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false, 
            floating: false,
            snap: false,
            automaticallyImplyLeading: false,
            backgroundColor: CbColors.dark,
            elevation: 0,
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: CbSizes.defaultSpace,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: SearchInput(
                      placeholder: 'treino do Steph Curry',
                      controller: TextEditingController(),
                    ),
                  ),
                  const SizedBox(width: 20),
                  FilterButton(
                    onFilterApplied: (filters) {
                      // Handle the applied filters
                      print('Filters applied: $filters');
                      // You can add your filter logic here
                      // e.g., update the results list based on filters
                    },
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              left: CbSizes.defaultSpace,
              top: 10,
              bottom: 10,
            ),
            sliver: SliverToBoxAdapter(
              child: CategoriesBar(controllerTag: 'For you',),
            ),
          ),

          /// Results
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: CbSizes.defaultSpace,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = fakeBasketballTrainings[index];

                  return ResultWidget(
                    training: item,
                    views: 12341,
                  );
                },
                childCount: fakeBasketballTrainings.length,
              ),
            ),
          ),

          /// Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 30),
          ),
        ],
      ),
    );
  }
}

