import 'package:carboneto/common/styles/spacing_styles.dart';
import 'package:carboneto/common/widgets/layouts/grid_layout.dart';
import 'package:carboneto/features/personalization/screens/settings/settings.dart';
import 'package:carboneto/features/training/screens/home/widgets/home_training_dart.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: CbSpacingStyle.paddingWithAppBarHeight * 0,
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(
            children: [
            ],
          )
        ])),
      ),
    );
  }
}