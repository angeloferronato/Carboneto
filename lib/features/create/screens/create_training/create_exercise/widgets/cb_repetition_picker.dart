import 'package:carboneto/features/create/screens/create_training/create_exercise/widgets/circle_button.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/form_label.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class CbRepetitionPicker extends StatelessWidget {
  const CbRepetitionPicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  void _increment() => onChanged(value + 1); 

  void _decrement() {
    if (value > 1) onChanged(value - 1);
  }

  void _openTypingDialog(BuildContext context) {
    final textController = TextEditingController(text: '$value');
    final isDarkMode = CbHelperFunctions.isDarkMode(context);

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: isDarkMode ? CbColors.dark : CbColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Repetições',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? CbColors.white : CbColors.black,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: textController,
                keyboardType: TextInputType.number,
                autofocus: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? CbColors.white : CbColors.black,
                ),
                decoration: InputDecoration(
                  hintText: '0',
                  hintStyle: const TextStyle(color: CbColors.darkGrey),
                  filled: true,
                  fillColor: isDarkMode ? CbColors.inputBG : CbColors.softGrey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: CbColors.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(
                          color: isDarkMode
                              ? CbColors.darkGrey
                              : CbColors.borderPrimary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: isDarkMode ? CbColors.white : CbColors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final parsed = int.tryParse(textController.text);
                        if (parsed != null && parsed >= 1) {
                          onChanged(parsed);
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CbColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          color: CbColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormLabel(label: 'Repetições'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleButton(
                icon: Icons.remove,
                onTap: _decrement,
                enabled: value > 1,
              ),
              GestureDetector(
                onTap: () => _openTypingDialog(context),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$value',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6, left: 4),
                          child: Icon(
                            Icons.edit,
                            size: 14,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'toque para digitar',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              CircleButton(
                icon: Icons.add,
                onTap: _increment,
                enabled: true, // no max
              ),
            ],
          ),
        ),
      ],
    );
  }
}

