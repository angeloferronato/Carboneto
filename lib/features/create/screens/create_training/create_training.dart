import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/features/create/screens/create_training/controllers/create_training_controller.dart';
import 'package:carboneto/features/create/screens/create_training/add_training/add_training_screen.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/cb_primary_btn.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/create_form.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/form_label.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/number_dropdown.dart';
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
    final controller = Get.put(CreateTrainingController());

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
              CbRoundedImage(
                imageUrl: CbImages.thumbnailTrainingExample,
                height: 250,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              CreateForm(
                label: 'Titulo',
                hintText: 'How to train like Steph Curry',
                validateEmpty: 'How to train like Steph Curry',
              ),
              const SizedBox(height: 20),
              CreateForm(
                label: 'Descrição',
                hintText:
                    'Want to shoot, move, and handle the ball like one of the greatest shooters in NBA history? In this video, we break down Steph Curry’s signature training routine',
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
                  Image(
                    image: AssetImage(CbImages.basket),
                    width: 70,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 0),
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
                  const SizedBox(height: 25),
                  CbPrimaryBtn(
                    label: 'Adicionar Exercício',
                    onPressed: () => Get.to(() => const AddTrainingScreen()),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const FormLabel(label: 'N° de pessoas necessárias'),
                      // Exemplo futuro:
                      const NumberDropdown()
                    ],
                  ),
                  const SizedBox(height: 30),
                  CbPrimaryBtn(
                    label: 'Upload',
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
