import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/features/create/controllers/create_training_controller.dart';
import 'package:carboneto/features/create/controllers/difficulty_level_selector_controller.dart';
import 'package:carboneto/features/create/controllers/exercises_controller.dart';
import 'package:carboneto/features/create/controllers/number_dropdown_controller.dart';
import 'package:carboneto/features/create/controllers/tag_controller.dart';
import 'package:carboneto/features/create/controllers/upload_controller.dart';
import 'package:carboneto/features/create/controllers/upload_image_controller.dart';
import 'package:carboneto/features/create/screens/create_training/add_training/add_training_screen.dart';
import 'package:carboneto/common/widgets/buttons/cb_primary_btn.dart';
import 'package:carboneto/features/create/screens/create_training/uploading/uploading_screen.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/create_form.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/difficulty_level_selector.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/selected_exercises.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/form_label.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/number_dropdown.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/square_upload.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/tag_selector.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/training_visibility_sector.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateTraining extends StatefulWidget {
  const CreateTraining({super.key});

  @override
  State<CreateTraining> createState() => _CreateTrainingState();
}

class _CreateTrainingState extends State<CreateTraining> {
  late final UploadImageController _uploadImageController;
  late final CreateTrainingController _controller;
  late final ExercisesController _exercisesController;
  // Singleton — registered once at app start or here lazily
  late final UploadStatusController _uploadStatusController;

  @override
  void initState() {
    super.initState();
    _deleteTaggedControllers();

    final tag = CbTexts.trainingControllerTag;

    _uploadImageController = Get.put(UploadImageController(), tag: tag);
    Get.put(TagController(), tag: tag);
    Get.put(NumberDropdownController(), tag: tag);
    Get.put(DifficultyLevelSelectorController(), tag: tag);
    _exercisesController = Get.put(ExercisesController(), tag: tag);
    _controller = Get.put(CreateTrainingController(), tag: tag);

    // Register the upload status controller as a global singleton (no tag)
    // so it survives navigation but resets when the user returns.
    _uploadStatusController = Get.isRegistered<UploadStatusController>()
        ? Get.find<UploadStatusController>()
        : Get.put(UploadStatusController());
    // Ensure clean state when entering this screen
    _uploadStatusController.reset();
  }

  @override
  void dispose() {
    _deleteTaggedControllers();
    super.dispose();
  }

  void _deleteTaggedControllers() {
    final tag = CbTexts.trainingControllerTag;
    Get.delete<CreateTrainingController>(tag: tag, force: true);
    Get.delete<ExercisesController>(tag: tag, force: true);
    Get.delete<UploadImageController>(tag: tag, force: true);
    Get.delete<TagController>(tag: tag, force: true);
    Get.delete<NumberDropdownController>(tag: tag, force: true);
    Get.delete<DifficultyLevelSelectorController>(tag: tag, force: true);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    final tag = CbTexts.trainingControllerTag;

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
      // Stack wraps the body so the overlay floats above the scroll content
      body: SafeArea(
        child: Stack(
          children: [
            // ── Main scrollable form ──────────────────────────────────────
            SingleChildScrollView(
              padding: const EdgeInsets.all(CbSizes.defaultSpace),
              child: Form(
                key: _controller.createTrainingFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Upload thumbnail
                    SquareUploadWidget(
                      uploadImageController: _uploadImageController,
                      onSelectFiles: () => _uploadImageController
                          .pickSingleFile(format: UploadImageFormat.banner),
                      label: 'Upload thumbnail',
                      description:
                          'Selecione um arquivo de imagem para a capa do treino.',
                    ),
                    const SizedBox(height: 20),

                    // Title
                    CreateForm(
                      controller: _controller.title,
                      label: 'Titulo',
                      hintText: 'Escreva aqui o titulo do seu treino.',
                      validateEmpty: 'Título do treino',
                      maxLength: 80,
                    ),
                    const SizedBox(height: 15),

                    // Description
                    CreateForm(
                      controller: _controller.description,
                      label: 'Descrição',
                      hintText: 'Escreva aqui a descrição do seu treino.',
                      validateEmpty: 'Descrição do treino',
                      maxLines: 5,
                      maxLength: 200,
                    ),
                    const SizedBox(height: CbSizes.defaultSpace),

                    // Tags
                    const FormLabel(label: 'Adicionar Tags'),
                    const SizedBox(height: 10),
                    TagSelector(controllerTag: tag),
                    const SizedBox(height: 25),

                    // Exercises
                    const FormLabel(label: 'Exercícios'),
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        Obx(() {
                          if (_exercisesController.selectedIndexes.isEmpty) {
                            return Column(
                              children: [
                                Image(
                                  image: const AssetImage(CbImages.basket),
                                  width: 70,
                                  color: isDarkMode
                                      ? CbColors.grey
                                      : CbColors.darkerGrey,
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
                                      color: isDarkMode
                                          ? CbColors.darkGrey
                                          : CbColors.darkerGrey,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          return SelectedExercises(tag: tag);
                        }),
                        const SizedBox(height: 25),
                        CbPrimaryBtn(
                          label: 'Adicionar Exercício',
                          onPressed: () =>
                              Get.to(() => AddTrainingScreen(tag: tag)),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),

                    // People
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const FormLabel(label: 'N° de pessoas necessárias'),
                        NumberDropdown(controllerTag: tag),
                      ],
                    ),
                    const SizedBox(height: CbSizes.md),

                    // Difficulty
                    Align(
                      alignment: AlignmentGeometry.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FormLabel(label: 'Nível de Dificuldade'),
                          const SizedBox(height: CbSizes.md),
                          DifficultyLevelSelector(
                            width: double.infinity,
                            tag: tag,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Visibility
                    const FormLabel(label: 'Visibilidade'),
                    const SizedBox(height: 10),
                    TrainingVisibilitySelector(
                      externalVisibility: _controller.visibility,
                      onChanged: _controller.setVisibility,
                    ),
                    const SizedBox(height: 40),

                    // Upload Button — disabled while uploading
// Upload Button — disabled while uploading
                    Obx(() {
                      final isUploading = _uploadStatusController.isActive &&
                          _uploadStatusController.state.value !=
                              UploadState.success &&
                          _uploadStatusController.state.value !=
                              UploadState.error;

                      return Center(
                        child: CbPrimaryBtn(
                          label: isUploading ? 'Enviando...' : 'Upload',
                          fontSize: 18,
                          paddingH: 45,
                          paddingV: 12,
                          borderRadius: 30,
                          onPressed: isUploading
                              ? () {} // no-op while uploading
                              // ⬇️ REVERTED TO THIS:
                              : () => _controller.createTraining(),
                        ),
                      );
                    }),

                    // Bottom padding so content isn't hidden under the overlay
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // ── YouTube-style floating upload overlay ─────────────────────
            const UploadOverlayWidget(),
          ],
        ),
      ),
    );
  }
}
