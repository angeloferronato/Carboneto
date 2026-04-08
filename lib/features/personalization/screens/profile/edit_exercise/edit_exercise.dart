import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/buttons/cb_primary_btn.dart';
import 'package:carboneto/features/create/controllers/number_dropdown_controller.dart';
import 'package:carboneto/features/create/controllers/tag_controller.dart';
import 'package:carboneto/features/create/controllers/upload_image_controller.dart';
import 'package:carboneto/features/create/screens/create_training/create_exercise/widgets/cb_repetition_picker.dart';
import 'package:carboneto/features/create/screens/create_training/create_exercise/widgets/cb_slider_create.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/create_form.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/form_label.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/number_dropdown.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/square_upload.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/tag_selector.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/training_visibility_sector.dart';
import 'package:carboneto/features/personalization/controllers/edit_exercise/edit_exercise.dart' show EditExerciseController;
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


// COMENTÁRIOS PRA RPZ ENTENDER

class EditExerciseScreen extends StatefulWidget {
  const EditExerciseScreen({super.key, required this.exercise});

  final ExerciseModel exercise;

  // Tag dinâmica gerada com base no ID do exercício. 
  // Isso impede conflitos no GetX se por acaso houver navegação rápida ou múltiplas edições.
  String get _tag => 'edit_exercise_${exercise.id}';

  @override
  State<EditExerciseScreen> createState() => _EditExerciseScreenState();
}

class _EditExerciseScreenState extends State<EditExerciseScreen> {
  late final EditExerciseController _controller;
  late final UploadImageController _uploadImageController;

  String get _tag => widget._tag;

  @override
  void initState() {
    super.initState();
    // Limpa instâncias presas na memória por segurança antes de inicializar novas
    _deleteTaggedControllers();

    // Inicializa todos os controladores injetando a tag dinâmica
    _uploadImageController = Get.put(UploadImageController(), tag: _tag);
    Get.put(TagController(), tag: _tag);
    Get.put(NumberDropdownController(), tag: _tag);
    
    // Passa a tag dinâmica explicitamente para dentro do controller
    _controller = Get.put(
      EditExerciseController(exercise: widget.exercise, tag: _tag),
      tag: _tag,
    );
  }

  @override
  void dispose() {
    // Garante a destruição dos controllers atrelados a esta tag ao sair da tela
    _deleteTaggedControllers();
    super.dispose();
  }

  // Função auxiliar para matar os controllers baseados na tag
  void _deleteTaggedControllers() {
    Get.delete<EditExerciseController>(tag: _tag, force: true);
    Get.delete<UploadImageController>(tag: _tag, force: true);
    Get.delete<TagController>(tag: _tag, force: true);
    Get.delete<NumberDropdownController>(tag: _tag, force: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CbAppBar(
        title: const Text(
          'Editar Exercício',
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
            key: _controller.editExerciseFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SquareUploadWidget(
                  uploadImageController: _uploadImageController,
                  fileType: FileType.video,
                  onSelectFiles: () => _uploadImageController.pickSingleVideo(50),
                  label: 'Upload video',
                  description: 'Selecionar arquivo de video. Tamanho máx 50MB.',
                  existingVideoUrl: widget.exercise.video,
                ),
                const SizedBox(height: 20),
                CreateForm(
                  controller: _controller.title,
                  label: 'Titulo',
                  hintText: 'Bandeja Reversa com a Mesma Mão',
                  validateEmpty: 'Título',
                  maxLength: 80,
                ),
                const SizedBox(height: CbSizes.md),
                CreateForm(
                  controller: _controller.description,
                  label: 'Descrição',
                  hintText: 'Descrição do exercício...',
                  validateEmpty: 'Descrição',
                  maxLines: 5,
                  maxLength: 400,
                ),
                const SizedBox(height: CbSizes.md),
                
                // Extraído em sub-widgets para focar o rebuild do Obx apenas no elemento necessário
                _DurationSlider(controller: _controller),
                _RepetitionPicker(controller: _controller),
                
                const SizedBox(height: 25),
                const FormLabel(label: 'Adicionar Tags'),
                const SizedBox(height: 10),
                TagSelector(controllerTag: _tag),
                const SizedBox(height: 25),
                const FormLabel(label: 'Visibilidade'),
                const SizedBox(height: 12),
                TrainingVisibilitySelector(
                  externalVisibility: _controller.visibility,
                  onChanged: _controller.setVisibility,
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const FormLabel(label: 'N° de pessoas necessárias'),
                    NumberDropdown(controllerTag: _tag),
                  ],
                ),
                const SizedBox(height: 40),
                Center(
                  child: CbPrimaryBtn(
                    label: 'Salvar',
                    fontSize: 18,
                    paddingH: 45,
                    paddingV: 12,
                    borderRadius: 30,
                    onPressed: () async {
                      // Chama o processo de atualização e aguarda retorno
                      final updated = await _controller.updateExercise();
                      if (updated != null) {
                        Get.back(result: updated);
                      }
                    },
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

// Sub-widgets focados em performance (O Obx só redesenha eles mesmos)
class _DurationSlider extends StatelessWidget {
  const _DurationSlider({required this.controller});
  final EditExerciseController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final val = controller.durationValue.value.round();
      return CbSliderDefault(
        sliderValue: controller.durationValue.value,
        min: 0,
        max: 30,
        divisions: 30,
        sliderHeader: val == 0 ? 'Duração - Livre' : 'Duração - $val min',
        sliderLabel: val == 0 ? ' Livre ' : ' $val min ',
        onChanged: controller.onDurationChanged,
      );
    });
  }
}

class _RepetitionPicker extends StatelessWidget {
  const _RepetitionPicker({required this.controller});
  final EditExerciseController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => CbRepetitionPicker(
          value: controller.repetitionsValue.value.round(),
          onChanged: controller.onRepetitionsChanged,
        ));
  }
}