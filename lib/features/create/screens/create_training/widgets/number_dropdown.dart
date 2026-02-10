import 'package:carboneto/features/create/controllers/number_dropdown_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NumberDropdown extends StatelessWidget {
  const NumberDropdown({super.key, required this.controllerTag});

  final String controllerTag;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NumberDropdownController(), tag: controllerTag);

    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: CbColors.primary,
          borderRadius: BorderRadius.circular(17),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<dynamic>(
            value: controller.selectedValue.value,
            isDense: true,
            isExpanded: false,
            dropdownColor: isDarkMode ? CbColors.dark : CbColors.white,
            borderRadius: BorderRadius.circular(20),
            icon: const SizedBox.shrink(), // remove ícone padrão
            style: TextStyle(
              color: isDarkMode ? Colors.white : CbColors.dark,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Plus Jakarta Sans',
            ),

            selectedItemBuilder: (BuildContext context) {
              return controller.values.map((value) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.selectedValue.value.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 25,
                    ),
                  ],
                );
              }).toList();
            },

            onChanged: (dynamic newValue) {
              controller.setValue(newValue);
            },

            items: controller.values.map((value) {
              return DropdownMenuItem<dynamic>(
                value: value,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Text(
                      value.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: isDarkMode ? Colors.white : CbColors.dark,),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    });
  }
}

