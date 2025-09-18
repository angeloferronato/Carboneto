import 'package:flutter/material.dart';

class HighlightBtn extends StatelessWidget {
  const HighlightBtn(
      {super.key, required this.textValue, required this.onPressedEdit});
  final String textValue;
  final VoidCallback? onPressedEdit;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressedEdit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          textValue,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        ));
  }
}