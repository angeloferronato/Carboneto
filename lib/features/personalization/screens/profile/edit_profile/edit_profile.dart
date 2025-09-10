import 'dart:ffi';

import 'package:carboneto/common/styles/spacing_styles.dart';
import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:carboneto/common/widgets/layouts/grid_layout.dart';
import 'package:carboneto/features/personalization/screens/settings/settings.dart';
import 'package:carboneto/features/training/screens/home/widgets/home_training_dart.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_flags/country_flags.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Country? _selectedCountry;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bannerHeight = screenWidth * 0.6; // altura proporcional
    final avatarRadius = screenWidth * 0.21;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Editar Perfil",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(vertical: 0, horizontal: CbSizes.defaultSpace),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CbColors.primary,
                  ),
                  child: CircleAvatar(
                    radius: avatarRadius,
                    backgroundImage: AssetImage(CbImages.userExample),
                  ),
                ),
              ),
              Column(
                spacing: 20,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Nome',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      FocusedTextField(
                        hintText: 'Nome',
                        paddingH: 20,
                        // controller: controller.email,
                        // validator: (value) => CbValidator.validateEmptyText(CbTexts.emailOrUserName, value),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Descrição',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      FocusedTextField(
                        hintText: 'Descrição',
                        paddingH: 20,
                        // controller: controller.email,
                        // validator: (value) => CbValidator.validateEmptyText(CbTexts.emailOrUserName, value),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Posição Favorita',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      FocusedTextField(
                        hintText: 'Armador',
                        paddingH: 20,
                        // controller: controller.email,
                        // validator: (value) => CbValidator.validateEmptyText(CbTexts.emailOrUserName, value),
                      ),
                    ],
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Localização/País',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                          style: ButtonStyle(
                            alignment: Alignment.centerLeft,
                            backgroundColor: WidgetStatePropertyAll(CbColors.inputBG),
                            foregroundColor: WidgetStatePropertyAll(CbColors.darkGrey),
                            padding: WidgetStatePropertyAll(
                                EdgeInsets.symmetric(horizontal: 20, vertical: 17)),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide.none, // remove borda física
                              ),
                            ),
                            overlayColor: WidgetStatePropertyAll(Colors.transparent),
                            shadowColor: WidgetStatePropertyAll(Colors.transparent),
                            elevation: WidgetStatePropertyAll(0),
                            // remove outline azul do Material 3
                            side: WidgetStateBorderSide.resolveWith((states) => BorderSide.none),
                          ),
                            
                            onPressed: () {
                              showCountryPicker(
                                  context: context,
                                  onSelect: (Country country) {
                                    setState(() {
                                      _selectedCountry = country;
                                    });
                                  });
                            },
                            child: Text(_selectedCountry == null? 'País':"${_selectedCountry!.name}  ${_selectedCountry!.flagEmoji}"),
                          ),
                        ),
                      ]),
                  SizedBox(),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 17),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                    child: Text(
                      'Salvar Alterações',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
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
