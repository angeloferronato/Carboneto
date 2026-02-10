import 'package:flutter/material.dart';

class HighlightBtn extends StatelessWidget {
  const HighlightBtn({
    super.key,
    required this.textValue,
    required this.onPressedEdit,
    this.labelColor = Colors.white,
    this.labelWeight = FontWeight.w800, 
    this.icon,
  });
  final Widget? icon;
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            textValue,
            style: TextStyle(fontSize: 15, fontWeight: labelWeight, color: labelColor),
          ),
          if (icon != null) Row(
            children: [
              SizedBox(width: 4,),
              icon ?? SizedBox(),
            ],
          ),
        ],
      )
    );
  }
}
