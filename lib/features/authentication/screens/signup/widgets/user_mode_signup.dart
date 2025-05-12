import 'package:carboneto/features/authentication/controllers/signup_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserModeSignUp extends StatefulWidget {
  const UserModeSignUp({
    super.key, required this.selectedModeText, required this.image, this.spaceBtwImage,
  });

  final String selectedModeText;
  final String image;
  final double? spaceBtwImage;

  @override
  State<UserModeSignUp> createState() => _UserModeSignUpState();
}

class _UserModeSignUpState extends State<UserModeSignUp> {
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = CbHelperFunctions.isDarkMode(context);
    final SignupController controller = SignupController.instance;
    

    return GestureDetector(
      onTap: () => {
        setState(() {
          controller.changeSelectedAccountType(widget.selectedModeText);
        })
      },  
      child: Obx(() {
        final bool isSelected = controller.selectedAccountType.value == widget.selectedModeText;
        return Container(
          width: 160,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(CbSizes.md),
            border: Border.all(
              color: CbColors.grey,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: CbColors.primary,
                spreadRadius: .5,
                blurRadius: 5,
                offset: Offset(0, 0),
              ),
            ] : [],
            color: isDarkMode ? CbColors.dark : CbColors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(CbSizes.sm),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(widget.image),
                  width: 80,
                ),
        
                SizedBox(height: widget.spaceBtwImage,),
        
                Text(
                  widget.selectedModeText.capitalize!,
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: isSelected ? CbColors.primary : isDarkMode ? CbColors.white : CbColors.black,
                  ),
                ),
              ],
            ),
          ),
        );
        }
      ),
    );
  }
}