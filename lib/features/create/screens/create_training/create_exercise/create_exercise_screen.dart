import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/features/create/screens/create_training/controllers/create_training_controller.dart';
import 'package:carboneto/features/create/screens/create_training/controllers/exercises_controller.dart';
import 'package:carboneto/features/create/screens/create_training/create_exercise/widgets/video_upload.dart';
import 'package:carboneto/features/create/screens/create_training/add_training/widgets/categories_bar.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/cb_primary_btn.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/create_form.dart';
import 'package:carboneto/features/create/screens/create_training/add_training/widgets/exercises_list.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/form_label.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/number_dropdown.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/tag_selector.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CreateExerciseScreen extends StatelessWidget {
  const CreateExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = CbHelperFunctions.isDarkMode(context);
    final exercisesController = Get.put(ExercisesController());

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VideoUploadWidget(
                onSelectFiles: () {},
              ),
              const SizedBox(height: 20),
              CreateForm(
                label: 'Titulo',
                hintText: 'Form Shooting',
                validateEmpty: 'Form Shooting',
              ),
              const SizedBox(height: 20),
              CreateForm(
                label: 'Descrição',
                hintText:
                    'Start with the ball in the triple threat position close to the basket. Stand straight on and square to the basket, feet a shade over shoulder width apart, back straight, head upright, eyes looking at the rim.',
                validateEmpty: 'Descrição do treino',
                maxLines: 7,
              ),
              const SizedBox(height: 20),
              const FormLabel(label: 'Adicionar Tags'),
              const SizedBox(height: 10),
              TagSelector(),
              const SizedBox(height: 25),
              Column(
                children: [
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const FormLabel(label: 'N° de pessoas necessárias'),
                      // Exemplo futuro:
                      const NumberDropdown()
                    ],
                  ),
                  const SizedBox(height: 40),
                  CbPrimaryBtn(
                    label: 'Criar',
                    fontSize: 20,
                    paddingH: 65,
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

