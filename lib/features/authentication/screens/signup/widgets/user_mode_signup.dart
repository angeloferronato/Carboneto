import 'package:carboneto/features/authentication/controllers/signup/signup_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserModeSignUp extends StatefulWidget {
  const UserModeSignUp({
    super.key,
    required this.selectedModeText,
    required this.image,
    this.spaceBtwImage,
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
    final SignupController controller = SignupController.instance;

    return GestureDetector(
      onTap: () => {
        setState(() {
          controller.changeSelectedAccountType(widget.selectedModeText);
        })
      },
      child: Obx(() {
        final bool isSelected =
            controller.selectedAccountType.value == widget.selectedModeText;
        return Container(
          width: 160,
          height: 150,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0x31467CB8),
                Color(0x61152E42),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected? CbColors.primary : CbColors.borderBlue,
              width: 1,
            ),
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
                SizedBox(
                  height: widget.spaceBtwImage,
                ),
                Text(widget.selectedModeText.capitalize!,
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        );
      }),
    );
  }
}
