import 'package:carboneto/features/create/screens/create_training/widgets/form_label.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class CbSliderDefault extends StatelessWidget {
  const CbSliderDefault({
    super.key, 
    required this.sliderValue,
    required this.min, 
    required this.max, 
    required this.divisions, 
    required this.onChanged, 
    required this.sliderHeader, 
    required this.sliderLabel,
    this.padding = const EdgeInsets.symmetric(vertical: CbSizes.lg),
  });

  final String sliderHeader, sliderLabel;
  final void Function(double?) onChanged;
  final double sliderValue, min, max;
  final int divisions;
  final EdgeInsetsGeometry padding;


  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = CbHelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormLabel(label: sliderHeader),
        
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            valueIndicatorColor: CbColors.primary,
            valueIndicatorTextStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
            activeTrackColor: CbColors.primary,
            inactiveTrackColor: isDarkMode ? CbColors.white.withValues(alpha: 0.2) : CbColors.grey,
            thumbColor: CbColors.primary,
            overlayColor: CbColors.primary.withValues(alpha: 0.2),
            inactiveTickMarkColor: CbColors.darkGrey
          ),
          child: Slider(
            value: sliderValue, 
            onChanged: onChanged,
            min: min,
            max: max,
            label: sliderLabel,
            divisions: divisions,
            padding: padding,
            year2023: false,
          ),
        ),
      ],
    );
  }
}