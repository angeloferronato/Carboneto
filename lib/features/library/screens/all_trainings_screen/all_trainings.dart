import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/features/library/screens/all_trainings_screen/widgets/training_card.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/highlight_btn.dart';
import 'package:flutter/material.dart';
import 'package:carboneto/utils/constants/colors.dart';

class AllTrainingsScreen extends StatelessWidget {
  const AllTrainingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CbColors.dark,
      appBar: CbAppBar(
        title: Text(
          'Seus Treinos',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
        showBackArrow: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // GRID
            SizedBox(height: 20,),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(), // 👈 impede scroll interno
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 5,
                childAspectRatio: 0.62,
              ),
              itemCount: 12,
              itemBuilder: (_, index) => const TrainingCard(),
            ),

            // BOTÃO QUE ROLA JUNTO
            HighlightBtn(textValue: '+ Novo Treino', onPressedEdit: () => {}, labelColor: CbColors.primary,),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}



