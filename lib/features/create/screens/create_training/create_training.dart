import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/create_form.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/form_label.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/number_dropdown.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/tag_selector.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CreateTraining extends StatefulWidget {
  const CreateTraining({super.key});

  @override
  State<CreateTraining> createState() => _CreateTrainingState();
}

class _CreateTrainingState extends State<CreateTraining> {
  final List<String> _selectedTags = ["Intermediário", "Agilidade"];

  @override
  Widget build(BuildContext context) {

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
                  validateEmpty: 'How to train like Steph Curry'),
              const SizedBox(height: 20),
              CreateForm(
                label: 'Descrição',
                hintText:
                    'Want to shoot, move, and handle the ball like one of the greatest shooters in NBA history? In this video, we break down Steph Curry’s signature training routine',
                validateEmpty: 'Descrição do treino',
                maxLines: 7,
              ),
              const SizedBox(height: 20),
              FormLabel(label: 'Adicionar Tags',),
              const SizedBox(height: 10),
              TagSelector(
                initialTags: _selectedTags,
                onTagChanged: (tag, added) {
                  setState(() {
                    if (added) {
                      if (!_selectedTags.contains(tag)) _selectedTags.add(tag);
                    } else {
                      _selectedTags.remove(tag);
                    }
                  });
                },
              ),

              const SizedBox(height: 25),
              Column(
                children: [
                  Image(image: AssetImage(CbImages.basket), width: 70,),
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
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 20),
                    child: Text(
                      'Adicionar Exercício',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FormLabel(label: 'N° de pessoas necessárias'),
                      NumberDropdown(
                        items: [1, 2, 3, 4, 5, 6, ],
                      )
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     FormLabel(label: 'Treino Público'),
                  //     Image(image: AssetImage(CbImages.addIcon))
                  //   ],
                  // )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

