import 'package:carboneto/common/widgets/custom_shapes/containers/rounded_countainer.dart';
import 'package:carboneto/features/training/controllers/training_execution_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class TrainingExecutionActionButtons extends StatelessWidget {
  const TrainingExecutionActionButtons({
    super.key, required this.controller,
  });

  final TrainingExecutionController controller;
  @override
  Widget build(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    return Row(
      children: [
        CbRoundedContainer(
          backgroundColor: CbColors.primary,
          width: 45,
          height: 45,
          borderRadius: 45,
          child: IconButton(
            onPressed: () => controller.toggleSheet(), 
            icon: Icon(Icons.table_rows_rounded, color: CbColors.lightGrey,),
          ),
        ),
        SizedBox(width: CbSizes.spaceBtwItems / 2,),
    
        CbRoundedContainer(
          backgroundColor: CbColors.primary,
          width: 45,
          height: 45,
          borderRadius: 45,
          child: IconButton(
            onPressed: () => controller.nextExercise(), 
            icon: Icon(Icons.skip_next_rounded, size: 30,  color: CbColors.white,),
          ),
        ),
        SizedBox(width: CbSizes.spaceBtwItems / 2,),
    
        CbRoundedContainer(
          backgroundColor: CbColors.primary,
          width: 45,
          height: 45,
          borderRadius: 45,
          child: IconButton(
            splashColor: const Color.fromARGB(255, 21, 68, 171),
            onPressed: () => controller.showCancelMessage(isDarkMode), 
            icon: Icon(Icons.close_sharp, size: 30, color: CbColors.white,),
          ),
        ),
      ],
    );
  }
}
