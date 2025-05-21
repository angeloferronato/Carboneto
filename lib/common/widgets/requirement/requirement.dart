import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class Requirement extends StatelessWidget {
  const Requirement({
    super.key,
    this.isChecked = false,
    required this.reqLabel,
  });

  final bool isChecked;
  final String reqLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          width: 24,
          child: Icon(
            isChecked ? Icons.check : Icons.circle,
            size: isChecked ? 24 : 10,
            color: isChecked ? CbColors.success : CbColors.textSecondary,
          ),
        ),
        SizedBox(width: 15),
        Text(
          reqLabel,
          style: TextStyle(
            color: isChecked ? CbColors.success : CbColors.textSecondary,
            fontSize: 14,
          ),
        )
      ],
    );
  }
}
