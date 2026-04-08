import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/buttons/cb_primary_btn.dart';
import 'package:carboneto/features/create/controllers/difficulty_level_selector_controller.dart';
import 'package:carboneto/features/create/controllers/exercises_controller.dart';
import 'package:carboneto/features/create/controllers/number_dropdown_controller.dart';
import 'package:carboneto/features/create/controllers/tag_controller.dart';
import 'package:carboneto/features/create/controllers/upload_image_controller.dart';
import 'package:carboneto/features/create/screens/create_training/add_training/add_training_screen.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/create_form.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/difficulty_level_selector.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/form_label.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/number_dropdown.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/selected_exercises.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/square_upload.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/tag_selector.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/training_visibility_sector.dart';
import 'package:carboneto/features/personalization/controllers/edit_training/edit_training.dart';
import 'package:carboneto/features/personalization/screens/profile/edit_training/widgets/delete_training_sheet.dart';
import 'package:carboneto/features/personalization/screens/profile/edit_training/widgets/empty_exercises_placeholder.dart';
import 'package:carboneto/features/personalization/screens/profile/edit_training/widgets/save_success_sheet.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/highlight_btn.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditTrainingScreen extends StatefulWidget {
  const EditTrainingScreen({super.key, required this.training});

  final TrainingModel training;
  static const String tag = 'edit_training';

  @override
  State<EditTrainingScreen> createState() => _EditTrainingScreenState();
}

class _EditTrainingScreenState extends State<EditTrainingScreen> {
  late final EditTrainingController _controller;
  late final UploadImageController _uploadImageController;
  late final ExercisesController _exercisesController;

  @override
  void initState() {
    super.initState();
    _deleteTaggedControllers();

    _uploadImageController =
        Get.put(UploadImageController(), tag: EditTrainingScreen.tag);

    // ADDED: register all controllers that child widgets look up by tag
    Get.put(TagController(), tag: EditTrainingScreen.tag);
    Get.put(NumberDropdownController(), tag: EditTrainingScreen.tag);
    Get.put(DifficultyLevelSelectorController(), tag: EditTrainingScreen.tag);

    _exercisesController =
        Get.put(ExercisesController(), tag: EditTrainingScreen.tag);

    _controller = Get.put(
      EditTrainingController(training: widget.training),
      tag: EditTrainingScreen.tag,
    );
  }

  @override
  void dispose() {
    _deleteTaggedControllers();
    super.dispose();
  }

  void _deleteTaggedControllers() {
    const tag = EditTrainingScreen.tag;
    Get.delete<EditTrainingController>(tag: tag, force: true);
    Get.delete<ExercisesController>(tag: tag, force: true);
    Get.delete<UploadImageController>(tag: tag, force: true);
    Get.delete<NumberDropdownController>(tag: tag, force: true);
    Get.delete<DifficultyLevelSelectorController>(tag: tag, force: true);
  }

  void _showSaveSuccessSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (_) => SaveSuccessSheet(context: context),
    );
  }

  void _showDeleteSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (_) => DeleteTrainingSheet(
        context: context,
        controller: _controller,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: CbAppBar(
        title: const Text(
          'Editar Treino',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        centerTitle: true,
        showBackArrow: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(CbSizes.defaultSpace),
          child: Form(
            key: _controller.editTrainingFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SquareUploadWidget(
                  uploadImageController: _uploadImageController,
                  onSelectFiles: () => _uploadImageController.pickSingleFile(),
                  label: 'Upload thumbnail',
                  description:
                      'Selecione um arquivo de imagem para a capa do treino.',
                  existingImageUrl: widget.training.thumbnail,
                ),
                const SizedBox(height: 20),
                CreateForm(
                  controller: _controller.title,
                  label: 'Titulo',
                  hintText: 'Como arremessar igual ao Stephen Curry',
                  validateEmpty: 'Título do treino',
                  maxLength: 80,
                ),
                const SizedBox(height: 15),
                CreateForm(
                  controller: _controller.description,
                  label: 'Descrição',
                  hintText: 'Descrição do treino...',
                  validateEmpty: 'Descrição do treino',
                  maxLines: 5,
                  maxLength: 200,
                ),
                const SizedBox(height: CbSizes.defaultSpace),
                const FormLabel(label: 'Adicionar Tags'),
                const SizedBox(height: 10),
                TagSelector(controllerTag: EditTrainingScreen.tag),
                const SizedBox(height: 25),
                const FormLabel(label: 'Exercícios'),
                const SizedBox(height: 10),
                Obx(() {
                  if (_controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (_exercisesController.selectedIndexes.isEmpty) {
                    return EmptyExercisesPlaceholder(isDarkMode: isDarkMode);
                  }
                  return SelectedExercises(tag: EditTrainingScreen.tag);
                }),
                const SizedBox(height: 25),
                Center(
                  child: CbPrimaryBtn(
                    label: 'Adicionar Exercício',
                    onPressed: () => Get.to(
                      () => AddTrainingScreen(tag: EditTrainingScreen.tag),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const FormLabel(label: 'N° de pessoas necessárias'),
                    NumberDropdown(controllerTag: EditTrainingScreen.tag),
                  ],
                ),
                const SizedBox(height: CbSizes.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FormLabel(label: 'Nível de Dificuldade'),
                    const SizedBox(height: CbSizes.md),
                    DifficultyLevelSelector(
                      width: double.infinity,
                      tag: EditTrainingScreen.tag,
                      initialValue: TrainingModel.parseLevelToString(
                          widget.training.level),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                const FormLabel(label: 'Visibilidade'),
                const SizedBox(height: 10),
                TrainingVisibilitySelector(tag: EditTrainingScreen.tag),
                const SizedBox(height: 48),
                _SaveButton(
                    controller: _controller, onSuccess: _showSaveSuccessSheet),
                const SizedBox(height: 32),
                Center(
                  child: HighlightBtn(
                    textValue: 'Excluir Treino',
                    onPressedEdit: _showDeleteSheet,
                    labelColor: CbColors.error,
                    labelWeight: FontWeight.w400,
                    padding: EdgeInsetsGeometry.all(12),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.controller, required this.onSuccess});

  final EditTrainingController controller;
  final VoidCallback onSuccess;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(() => CbPrimaryBtn(
            label: controller.isLoading.value ? 'Salvando...' : 'Salvar',
            fontSize: 18,
            paddingH: 45,
            paddingV: 12,
            borderRadius: 30,
            onPressed: controller.isLoading.value
                ? () {}
                : () async {
                    final success = await controller.updateTraining();
                    if (success) onSuccess();
                  },
          )),
    );
  }
}
