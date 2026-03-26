import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';

class EmptyExercisesPlaceholder extends StatelessWidget {
  const EmptyExercisesPlaceholder({super.key, required this.isDarkMode});

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image(
          image: AssetImage(CbImages.basket),
          width: 70,
          color: isDarkMode ? CbColors.grey : CbColors.darkerGrey,
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Text(
            'Adicione um exercicio para começar seu treinamento',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Plus Jakarta Sans',
              color: isDarkMode ? CbColors.darkGrey : CbColors.darkerGrey,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}