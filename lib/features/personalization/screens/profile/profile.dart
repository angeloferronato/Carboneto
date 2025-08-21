import 'package:carboneto/common/styles/spacing_styles.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return Scaffold(
      body: Padding(
        padding: CbSpacingStyle.paddingWithAppBarHeight,
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(
            children: [
              Image(image: AssetImage(CbImages.userExample)),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10,
                children: [
                  Text('@chicobuarque', style: 
                    TextStyle(
                      fontWeight: FontWeight.w500
                    )
                  ,),
                  Text('•', style: 
                    TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16
                    )
                  ,),
                  Image(
                    image: AssetImage(CbImages.ar3ptss),
                    width: 30,
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text('Chico Buarque', style: 
                TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold
                )
              ,),
              SizedBox(
                height: 5,
              ),
              Text('O maior bagre que ja jogou no IFSC', style: 
                TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w300
                )
              ,),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 30,
                children: [
                  Column(
                    children: [
                      HighlightText(
                        textValue: '122',
                        textSize: 30,
                      ),
                      PrimaryText(
                        textValue: 'seguidores',
                      )
                    ],
                  ),
                  Column(
                    children: [
                      HighlightText(
                        textValue:  '67',
                        textSize: 30,
                      ),
                      PrimaryText( textValue: 'seguindo')
                    ],
                  ),
                  Column(
                    children: [
                      HighlightText(textValue: 'PG', textSize: 30,), PrimaryText(textValue: 'armador')
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () => {}, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25), 
                  ),
                ),
                child: Text('Editar Perfil', style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800
                ),)
              ),
            ],
          )
        ])),
      ),
    );
  }
}

class HighlightText extends StatelessWidget {
  const HighlightText(
      {super.key, required this.textValue, required this.textSize});

  final String textValue;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      textValue,
      style: TextStyle(
        color: CbColors.primary,
        fontSize: textSize,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class PrimaryText extends StatelessWidget {
  const PrimaryText(
      {super.key, required this.textValue});

  final String textValue;

  @override
  Widget build(BuildContext context) {
    return Text(
      textValue,
      style: TextStyle(
        color: CbColors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

