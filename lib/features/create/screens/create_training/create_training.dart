import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/features/create/controllers/create_training_controller.dart';
import 'package:carboneto/features/create/controllers/exercises_controller.dart';
import 'package:carboneto/features/create/controllers/upload_image_controller.dart';
import 'package:carboneto/features/create/screens/create_training/add_training/add_training_screen.dart';
import 'package:carboneto/common/widgets/buttons/cb_primary_btn.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/create_form.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/exercises_selected.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/form_label.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/number_dropdown.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/square_upload.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/tag_selector.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateTraining extends StatelessWidget {
  const CreateTraining({super.key});

  @override
  Widget build(BuildContext context) {
    final UploadImageController uploadImageController = Get.put(UploadImageController(), tag: CbTexts.trainingControllerTag);
    final controller = Get.put(CreateTrainingController()); 
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
                uploadImageController: uploadImageController,
                onSelectFiles: uploadImageController.pickSingleFile,
                label: 'Upload thumbnail',
                description:
                    'Selecione um arquivo de imagem para a capa do treino.',
              ),
              const SizedBox(height: 20),

              // Title Form Section
              CreateForm(
                controller: controller.title,
                label: 'Titulo',
                hintText: 'Como arremessar igual ao Stephen Curry',
                validateEmpty: 'Como arremessar igual ao Stephen Curry',
                maxLength: 80,
              ),

              // Description Form Section
              CreateForm(
                controller: controller.description,
                label: 'Descrição',
                hintText: 'Quer arremessar como um dos maiores arremessadores da história da NBA? Neste treino, detalhamos a rotina de treino característica de Steph Curry em uma sessão completa de treinamento.',
                validateEmpty: 'Descrição do treino',
                maxLines: 5,
                maxLength: 200,
              ),
              const SizedBox(height: CbSizes.defaultSpace),

              // Tags Section
              const FormLabel(label: 'Adicionar Tags'),
              const SizedBox(height: 10),
              TagSelector(controllerTag: CbTexts.trainingControllerTag,), // Tag selector widget
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
                    onPressed: () => Get.to(() => const AddTrainingScreen()), // Navigate to Add Training Screen
                  ),
                  const SizedBox(height: 30),

                  // People Needed Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const FormLabel(label: 'N° de pessoas necessárias'),
                      const NumberDropdown(controllerTag: CbTexts.trainingControllerTag,), // Assuming custom widget for number selection
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