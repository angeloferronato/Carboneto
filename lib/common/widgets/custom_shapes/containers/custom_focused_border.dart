import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class CustomFocusedShape extends StatefulWidget {
  const CustomFocusedShape ({super.key, required this.builder});
  
  final Widget Function(FocusNode) builder;

  @override
  _CustomFocusedShapeState createState() => _CustomFocusedShapeState();
}

class _CustomFocusedShapeState extends State<CustomFocusedShape> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = CbHelperFunctions.isDarkMode(context);
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? CbColors.dark : CbColors.white,
        borderRadius: BorderRadius.circular(CbSizes.inputFieldRadius),
        boxShadow: _isFocused ? [
          BoxShadow(
            color: CbColors.primary,
            spreadRadius: .5,
            blurRadius: 5,
            offset: Offset(0, 0),
          ),
        ]
        : [],
      ),
      child: widget.builder(_focusNode),
    );
  }
}