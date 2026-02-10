import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePickerController extends GetxController {
  static DatePickerController get instance => Get.find();

  Future<void> showDatePickerAction(TextEditingController controller) async {
    final isDarkMode = CbHelperFunctions.isDarkMode(Get.context!);
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(20),
            child: Container(
              decoration: BoxDecoration(
                 boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              height: 400,
              width: 350,
              child: SfDateRangePicker(
                selectionTextStyle: const TextStyle(
                  color: CbColors.white
                ),
                view: DateRangePickerView.decade,
                selectionMode: DateRangePickerSelectionMode.single,
                maxDate: DateTime.now(),
                minDate: DateTime(1900),
                backgroundColor: isDarkMode ? CbColors.dark : CbColors.white,
                headerStyle: DateRangePickerHeaderStyle(
                  backgroundColor: isDarkMode ? CbColors.dark : CbColors.white,
                  textAlign: TextAlign.center,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                selectionColor: CbColors.primary,
                todayHighlightColor: CbColors.primary,
                rangeSelectionColor: CbColors.primary.withValues(alpha: 0.2),
                monthCellStyle: DateRangePickerMonthCellStyle(
                  todayTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CbColors.primary,
                  ),
                  weekendTextStyle: const TextStyle(
                    color: CbColors.primary,
                  ),
                ),
                onSelectionChanged: (args) {
                  if (args.value is DateTime) {
                    Get.back(result: args.value as DateTime);
                  }
                },
              ),
            ),
          ),
        );
      }
    ).then((selectedDate) => controller.text = DateFormat('dd/MM/yyyy').format(selectedDate));
  }
}