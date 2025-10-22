import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/features/create/screens/create_training/controllers/create_training_controller.dart';
import 'package:carboneto/features/create/screens/create_training/add_training/add_training_screen.dart';
import 'package:carboneto/features/create/screens/create_training/controllers/exercises_controller.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/cb_primary_btn.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/create_form.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/exercises_selected.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/form_label.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/number_dropdown.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/square_upload.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/tag_selector.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateTraining extends StatelessWidget {
  const CreateTraining({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(CreateTrainingController()); // Use the controller
    final exercisesController = Get.put(ExercisesController());
    return Scaffold(
      appBar: CbAppBar(
        title: const Text(
          'Criar Treino',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        centerTitle: true,
        showBackArrow: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(CbSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upload thumbnail
              SquareUploadWidget(
                onSelectFiles: () {},
                label: 'Upload thumbnail',
                description:
                    'Selecione um arquivo de imagem para a capa do treino. Tamanho máx 20mb',
              ),
              const SizedBox(height: 20),

              // Title Form Section
              CreateForm(
                label: 'Titulo',
                hintText: 'How to train like Steph Curry',
                validateEmpty: 'How to train like Steph Curry',
              ),
              const SizedBox(height: 20),

              // Description Form Section
              CreateForm(
                label: 'Descrição',
                hintText: 'Want to shoot, move, and handle the ball like one of the greatest shooters in NBA history? In this video, we break down Steph Curry’s signature training routine on this all in one training session.',
                validateEmpty: 'Descrição do treino',
                maxLines: 5,
              ),
              const SizedBox(height: 20),

              // Tags Section
              const FormLabel(label: 'Adicionar Tags'),
              const SizedBox(height: 10),
              TagSelector(), // Tag selector widget
              const SizedBox(height: 25),
              const FormLabel(label: 'Exercícios'),
              // Exercises Section
              Column(
                children: [
                  const SizedBox(height: 10),

                  // Display selected exercises
                  Obx(() {
                    if (exercisesController.selectedCount == 0) {
                      return Column(
                        children: [
                          // HERE WILL BE THE LIST OF EXERICESE
                          Image(
                            image: AssetImage(CbImages.basket),
                            width: 70,
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 0),
                            child: Text(
                              'Adicione um exercicio para começar seu treinamento',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: CbColors.darkGrey,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return SelectedExecises();
                  }),

                  const SizedBox(height: 25),

                  // Add Exercise Button
                  CbPrimaryBtn(
                    label: 'Adicionar Exercício',
                    onPressed: () => Get.to(() =>
                        const AddTrainingScreen()), // Navigate to Add Training Screen
                  ),
                  const SizedBox(height: 30),

                  // People Needed Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const FormLabel(label: 'N° de pessoas necessárias'),
                      const NumberDropdown(), // Assuming custom widget for number selection
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Upload Button
                  CbPrimaryBtn(
                    label: 'Upload',
                    fontSize: 18,
                    paddingH: 45,
                    paddingV: 12,
                    borderRadius: 30,
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


                  // HERE WILL BE THE LIST OF AN EXERICESE
                  // Image(
                  //   image: AssetImage(CbImages.basket),
                  //   width: 70,
                  // ),
                  // const SizedBox(height: 10),
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.symmetric(horizontal: 50, vertical: 0),
                  //   child: Text(
                  //     'Adicione um exercicio para começar seu treinamento',
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //       fontSize: 14,
                  //       color: CbColors.darkGrey,
                  //       fontWeight: FontWeight.w300,
                  //     ),
                  //   ),
                  // ),