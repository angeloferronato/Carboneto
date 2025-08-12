import 'package:carboneto/common/styles/spacing_styles.dart';
import 'package:carboneto/common/widgets/buttons/action_text_button.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/common/widgets/texts/section_heading.dart';
import 'package:carboneto/data/repositories/authentication/authentication_repository.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: CbSpacingStyle.paddingWithAppBarHeight,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Image(image: AssetImage('')),
                  Row(
                    children: [
                      Text('@chicobuarque'),
                      Text('•'),
                      Image(image: AssetImage(''))
                    ],
                  ),
                  Text('Chico Buarque'),
                  Text('O maior bagre que ja jogou no IFSC'),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text('122'),
                          Text('seguidores')
                        ],
                      ),
                      Column(
                        children: [
                          Text('67'),
                          Text('seguindo')
                        ],
                      ),
                      Column(
                        children: [
                          Text('PG'),
                          Text('armador')
                        ],
                      )
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => {}, 
                    child: Text('Editar Perfil')
                  ),
                  
                ],
              )
            ]
          )
        ),
      ),
    );
  }
}





