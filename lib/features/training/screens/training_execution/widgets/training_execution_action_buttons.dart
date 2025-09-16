import 'package:carboneto/common/widgets/custom_shapes/containers/rounded_countainer.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class TrainingExecutionActionButtons extends StatelessWidget {
  const TrainingExecutionActionButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CbRoundedContainer(
          backgroundColor: CbColors.primary,
          width: 45,
          height: 45,
          borderRadius: 45,
          child: IconButton(
            onPressed: () {}, 
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
            onPressed: () {}, 
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
            onPressed: () {}, 
            icon: Icon(Icons.close_sharp, size: 30, color: CbColors.white,),
          ),
        ),
      ],
    );
  }
}
