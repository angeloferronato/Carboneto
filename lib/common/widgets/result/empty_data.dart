import 'package:carboneto/home_menu.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyData extends StatelessWidget {
  const EmptyData(
      {super.key,
      this.icon = Icons.history,
      this.screen = 2,
      this.mainLabel = 'Você ainda não começou nenhum treino',
      this.secondaryLabel = 'Inicie um novo treino para comecar a sua jornada de evolução.'});

  final String mainLabel, secondaryLabel;
  final IconData icon;
  final int screen;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        IconButton(
          icon: Icon(
            icon,
            size: 70,
            color: CbColors.buttonSecondary,
          ),
          onPressed: () {
            Get.offAll(HomeMenu());
            final controller = Get.put(HomeMenuController());
            controller.selectedIndex.value = screen;
          },
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
          child: Column(
            children: [
              Text(
                mainLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: CbColors.buttonSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  secondaryLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: CbColors.buttonSecondary,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
