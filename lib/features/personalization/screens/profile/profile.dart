import 'package:carboneto/common/styles/spacing_styles.dart';
import 'package:carboneto/common/widgets/layouts/grid_layout.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/personalization/screens/profile/edit_profile/edit_profile.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/followers_and_following.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/highlight_btn.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/highlight_text.dart';
import 'package:carboneto/features/personalization/screens/settings/settings.dart';
import 'package:carboneto/features/training/screens/home/widgets/home_training_dart.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
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
                    ? CbShimmerEffects(width: 200, height: 60)
                    : Text(
                        userController.user.value.name,
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'O maior bagre que ja jogou no IFSC',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
              ),
              SizedBox(
                height: 20,
              ),
              FollowersAndFollowing(),
              SizedBox(
                height: 40,
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

class _TreinoCard extends StatelessWidget {
  final Treino treino;

  const _TreinoCard({required this.treino});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth =
        (screenWidth - 40 - 20) / 3; // 40 padding horizontal + 20 spacing
    final imageHeight = cardWidth * 1.2; // proporção da imagem

    return SizedBox(
      width: cardWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              treino.imagem,
              height: imageHeight,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              treino.titulo,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: cardWidth * 0.12, // tamanho do texto proporcional
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [LevelWidget(level: treino.nivel)],
            ),
          ),
        ],
      ),
    );
  }
}

class PrimaryText extends StatelessWidget {
  const PrimaryText({super.key, required this.textValue});

  final String textValue;

  @override
  Widget build(BuildContext context) {
    return Text(
      textValue,
      style: TextStyle(
        color: CbColors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final bannerHeight = screenWidth * 0.6; // altura proporcional
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
            child: CircleAvatar(
              radius: avatarRadius,
              backgroundImage: AssetImage(profileImg),
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
          CbGridLayout(
              itemCount: data.length,
              mainAxisExtent: 200,
              columnCount: 3,
              crossSpacing: 10,
              itemBuilder: (_, index) {
                final treino = data[index];
                return _TreinoCard(treino: treino);
              }),
        ],
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key, required this.userController});
  final dynamic userController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10,
      children: [
        Obx(
          () => userController.profileLoading.value
              ? CbShimmerEffects(width: 200, height: 60)
              : Text(
                  "@${userController.user.value.username}",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
        ),
        Text(
          '•',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        CountryFlag.fromCountryCode(
          'es',
          width: 22,
          shape: RoundedRectangle(3),
          height: 15,
        )
      ],
    );
  }
}


