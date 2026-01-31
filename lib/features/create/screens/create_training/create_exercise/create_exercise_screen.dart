import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/features/create/controllers/create_exercise_controller.dart';
import 'package:carboneto/features/create/controllers/upload_image_controller.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/square_upload.dart';
import 'package:carboneto/common/widgets/buttons/cb_primary_btn.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/create_form.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/form_label.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/number_dropdown.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/tag_selector.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateExerciseScreen extends StatelessWidget {
  const CreateExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UploadImageController uploadImageController = Get.put(UploadImageController(), tag: CbTexts.exerciseControllerTag);
    final createExerciseController = Get.put(CreateExerciseController());
    return Scaffold(
      backgroundColor: CbColors.dark,
      appBar: CbAppBar(
        title: Text(
          'Criar Exercício',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        showBackArrow: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(CbSizes.defaultSpace),
          child: Form(
            key: createExerciseController.createExerciseFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SquareUploadWidget(
                  uploadImageController: uploadImageController,
                  fileType: FileType.video,
                  onSelectFiles: () => uploadImageController.pickSingleVideo(50),
                  label: 'Upload video',
                  description: 'Selecionar arquivo de video. Tamanho máx 50MB.',
                ),
                const SizedBox(height: 20),
                CreateForm(
                  controller: createExerciseController.title,
                  label: 'Titulo',
                  hintText: 'Bandeja Reversa com a Mesma Mão',
                  validateEmpty: 'Título',
                  maxLength: 80,
                ),
                const SizedBox(height: CbSizes.md),
                CreateForm(
                  controller: createExerciseController.description,
                  label: 'Descrição',
                  hintText:
                      'Drible até a cesta e faça bandeja invertida, impulsionando-se com o pé oposto, girando o corpo e lançando a bola com a mesma mão do lado da cesta. Repita do outro lado, alternando mãos e pés.',
                  validateEmpty: 'Descrição do treino',
                  maxLines: 5,
                  maxLength: 400,
                ),
                const SizedBox(height: CbSizes.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 20,
                  children: [
                    Flexible(
                      flex: 1,
                      child: CreateForm(
                        controller: createExerciseController.repetitions,
                        label: 'Repetições',
                        hintText: 'Ex: 5',
                        validateEmpty: 'Número de Repetições',
                        maxLength: 2,
                        keyboardType: TextInputType.numberWithOptions(),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: CreateForm(
                        controller: createExerciseController.duration,
                        label: 'Duração',
                        hintText: 'Ex: 7',
                        validateEmpty: 'Duração',
                        maxLength: 2,
                        keyboardType: TextInputType.numberWithOptions(),
                      ),
                    ),
                  ],
                ),
                
                
                const SizedBox(height: 20),
                const FormLabel(label: 'Adicionar Tags'),
                const SizedBox(height: 10),
                TagSelector(controllerTag: CbTexts.exerciseControllerTag,),
                const SizedBox(height: 25),
                Column(
                  children: [
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const FormLabel(label: 'N° de pessoas necessárias'),
                        // Exemplo futuro:
                        const NumberDropdown(controllerTag: CbTexts.exerciseControllerTag,)
                      ],
                    ),
                    const SizedBox(height: 40),
                    CbPrimaryBtn(
                      label: 'Criar',
                      fontSize: 20,
                      paddingH: 65,
                      paddingV: 12,
                      borderRadius: 30,
                      onPressed: () => createExerciseController.createExercise(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

