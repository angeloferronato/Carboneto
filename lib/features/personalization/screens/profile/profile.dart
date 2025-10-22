import 'package:carboneto/common/styles/spacing_styles.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/common/widgets/layouts/grid_layout.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/personalization/screens/profile/edit_profile/edit_profile.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/followers_and_following.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/highlight_btn.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/highlight_text.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/profile_info.dart';
import 'package:carboneto/features/personalization/screens/settings/settings.dart';
import 'package:carboneto/features/training/screens/home/widgets/home_training_dart.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/loading_effects/shimmer_effects.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Treino {
  final String titulo;
  final String imagem;
  final DifficultyLevels nivel;

  Treino({
    required this.titulo,
    required this.imagem,
    required this.nivel,
  });
}

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final List<Treino> treinos = [
    Treino(
      titulo: "treino de movimento assdasd asd asdsad as",
      imagem: CbImages.thumbnailTrainingExample,
      nivel: DifficultyLevels.elite,
    ),
    Treino(
      titulo: "treino de movimento assdasd asd asdsad as",
      imagem: CbImages.thumbnailTrainingExample,
      nivel: DifficultyLevels.allstar,
    ),
    Treino(
      titulo: "treino de movimento assdasd asd asdsad as",
      imagem: CbImages.thumbnailTrainingExample,
      nivel: DifficultyLevels.pro,
    ),
    Treino(
      titulo: "treino de movimento assdasd asd asdsad as",
      imagem: CbImages.thumbnailTrainingExample,
      nivel: DifficultyLevels.allstar,
    ),
    Treino(
      titulo: "treino de movimento assdasd asd asdsad as",
      imagem: CbImages.thumbnailTrainingExample,
      nivel: DifficultyLevels.elite,
    ),
    Treino(
      titulo: "treino de movimento assdasd asd asdsad as",
      imagem: CbImages.thumbnailTrainingExample,
      nivel: DifficultyLevels.elite,
    ),
    Treino(
      titulo: "treino de movimento assdasd asd asdsad as",
      imagem: CbImages.thumbnailTrainingExample,
      nivel: DifficultyLevels.allstar,
    ),
    Treino(
      titulo: "treino de movimento assdasd asd asdsad as",
      imagem: CbImages.thumbnailTrainingExample,
      nivel: DifficultyLevels.allstar,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    return Scaffold(
      body: Padding(
        padding: CbSpacingStyle.paddingWithAppBarHeight * 0,
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(
            children: [
              BannerWithPicture(
                  profileImg: CbImages.userExample,
                  bannerImg: CbImages.trainingImageExample),
              SizedBox(
                height: 60,
              ),
              ProfileInfo(userController: userController),
              SizedBox(
                height: 5,
              ),
              Obx(
                () => userController.profileLoading.value
                    ? CbShimmerEffects(width: 200, height: 30)
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: CbSizes.defaultSpace),
                        child: Text(
                          userController.user.value.name,
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: CbSizes.defaultSpace),
                child: Obx(
                  () => !userController.profileLoading.value
                      ? Text(
                          userController.user.value.description,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w300),
                        )
                      : Column(
                          children: [
                            CbShimmerEffects(width: 120, height: 10),
                            SizedBox(
                              height: 5,
                            ),
                            CbShimmerEffects(width: 100, height: 10),
                          ],
                        ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // FollowersAndFollowing(),
              SizedBox(
                height: 10,
              ),
              HighlightBtn(
                textValue: 'Editar Perfil',
                onPressedEdit: () => Get.to(() => EditProfileScreen()),
              ),
              SizedBox(
                height: 40,
              ),
              ContentGrid(data: treinos, title: 'Treinos Criados'),
              SizedBox(
                height: 100,
              )
            ],
          )
        ])),
      ),
    );
  }
}





class BannerWithPicture extends StatelessWidget {
  const BannerWithPicture(
      {super.key, required this.profileImg, required this.bannerImg});
  final String profileImg;
  final String bannerImg;

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final screenWidth = MediaQuery.of(context).size.width;
    final bannerHeight = screenWidth * 0.6;
    final avatarRadius = screenWidth * 0.21;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.transparent],
              stops: [0.1, 0.9],
            ).createShader(rect);
          },
          blendMode: BlendMode.dstIn,
          child: Image.asset(
            bannerImg,
            width: double.infinity,
            height: bannerHeight,
            fit: BoxFit.cover,
          ),
        ),
        
        Positioned(
          bottom: -avatarRadius / 2,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CbColors.primary,
            ),
            child: Obx(
              () => !userController.profileLoading.value
                  ? (userController.user.value.profilePicture != ''
                      ? CbRoundedImage(
                          imageUrl: userController.user.value.profilePicture,
                          isNetworkImage: true,
                          borderRadius: avatarRadius,
                          width: 180,
                          height: 180,
                        )
                      : CbRoundedImage(
                          imageUrl: CbImages.userDefault,
                          borderRadius: avatarRadius,
                          width: 180,
                        ))
                  : CbShimmerEffects(
                      width: 180,
                      height: 180,
                      radius: avatarRadius,
                    ),
            ),
          ),
        ),
        Positioned(
          top: 40,
          right: 16,
          child: IconButton(
            icon: Icon(CupertinoIcons.settings,
                color: Colors.white, size: screenWidth * 0.07),
            onPressed: () => Get.to(SettingsScreen()),
          ),
        ),
      ],
    );
  }
}

class ContentGrid extends StatelessWidget {
  const ContentGrid({super.key, required this.data, required this.title});
  final List<Treino> data;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          HighlightText(
            textValue: 'Treinos Criados',
            textSize: 15,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(67, 147, 147, 147),
            ),
            height: 1,
          ),

          // FAZER NO FUTURO A LOGICA DE MOSTRAR OS TREINOS SE EXISTIREM: 
          // WIDGET PRONTO:
          // CbGridLayout(
          //     itemCount: data.length,
          //     mainAxisExtent: 200,
          //     columnCount: 3,
          //     crossSpacing: 5,
          //     itemBuilder: (_, index) {
          //       final treino = data[index];
          //       return _TreinoCard(treino: treino);
          //     }),

          Column(
            children: [
              const SizedBox(height: 40,),
              Icon(
                Icons.add,
                size: 70,
                color: CbColors.buttonSecondary, // opcional, para combinar com seu tema
              ),
              const SizedBox(height: 10),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                child: Column(
                  children: [
                    Text(
                      'Você ainda não possui treinos criados.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: CbColors.buttonSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Crie um novo treino para começar a organizar suas sessões de basquete.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: CbColors.buttonSecondary,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

