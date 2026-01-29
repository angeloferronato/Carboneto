import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CbPopupDropdown<T> extends StatelessWidget {
  final Rx<T> selected;
  final List<T> options;
  final String Function(T) labelBuilder;
  final void Function(T value)? onChanged;

  const CbPopupDropdown({
    super.key,
    required this.selected,
    required this.options,
    required this.labelBuilder,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return PopupMenuButton<T>(
        color: CbColors.dark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onSelected: (value) {
          selected.value = value;
          onChanged?.call(value);
        },
        itemBuilder: (_) {
          return options.map((option) {
            return PopupMenuItem<T>(
              value: option,
              child: Text(
                labelBuilder(option),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: CbColors.inputBG,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                labelBuilder(selected.value),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white,
              ),
            ],
          ),
        ),
      );
    });
  }
}

