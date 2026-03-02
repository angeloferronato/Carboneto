import 'package:carboneto/features/authentication/controllers/position_selector/position_selector_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PositionSelector extends StatefulWidget {
  const PositionSelector({super.key, this.width});

  final double? width;

  @override
  State<PositionSelector> createState() => _PositionSelectorState();
}

class _PositionSelectorState extends State<PositionSelector> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    final controller = Get.put(PositionSelectorController());
    return Container(
      width: widget.width,
      padding: const EdgeInsets.symmetric(horizontal: CbSizes.sm),
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
          color: CbColors.borderBlue,
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          padding: const EdgeInsets.only(left: CbSizes.md),
          dropdownColor: isDarkMode ? CbColors.dark : CbColors.white,
          value: controller.dropDownList.contains(controller.dropDownValue)
              ? controller.dropDownValue
              : controller.dropDownList.first,
          hint: Text(
            'Selecione uma opção',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          items: controller.dropDownList.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              controller.dropDownValue = newValue ?? '';
            });
          },
          icon: const Icon(Icons.arrow_drop_down),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
