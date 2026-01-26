import 'package:flutter/material.dart';

class HighlightBtn extends StatelessWidget {
  const HighlightBtn({
    super.key,
    required this.textValue,
    required this.onPressedEdit,
    this.labelColor = Colors.white,
    this.labelWeight = FontWeight.w800,
  });
  final String textValue;
  final Color labelColor;
  final VoidCallback? onPressedEdit;
  final FontWeight labelWeight;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressedEdit,
        style: ElevatedButton.styleFrom(
          side: BorderSide(color: labelColor),
          foregroundColor: labelColor,
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          textValue,
          style: TextStyle(
              fontSize: 15, fontWeight: labelWeight, color: labelColor),
        ));
  }
}
