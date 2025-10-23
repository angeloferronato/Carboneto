import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/features/create/screens/create_training/controllers/create_training_controller.dart';
import 'package:carboneto/features/create/screens/create_training/add_training/add_training_screen.dart';
import 'package:carboneto/features/create/screens/create_training/controllers/exercises_controller.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/cb_primary_btn.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/create_form.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/exercises_selected.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/form_label.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/number_dropdown.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/square_upload.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/tag_selector.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CbColors.dark,
      appBar: CbAppBar(
        showBackArrow: true,
        actions: [],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.construction,
                color: CbColors.darkGrey,
                size: 80,
              ),
              const SizedBox(height: 20),
              Text(
                'Em Desenvolvimento',
                style: TextStyle(
                  color: CbColors.darkGrey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Plus Jakarta Sans'
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Essa funcionalidade estará disponível em breve!',
                style: TextStyle(
                  color: CbColors.darkGrey,
                  fontSize: 14,
                  fontFamily: 'Plus Jakarta Sans'
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}