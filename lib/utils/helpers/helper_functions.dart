import 'package:carboneto/utils/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:carboneto/utils/constants/enums.dart';

class CbHelperFunctions {
  static Map<String, dynamic> parseLevelStyle(
      BuildContext context, DifficultyLevels level) {
    final bool isDarkMode = CbHelperFunctions.isDarkMode(context);
    Color difficultyBorder = Colors.transparent;
    Color difficultyColor = Colors.transparent;
    Color difficultyColorTxt = Colors.transparent;
    String difficultyTitle = '';
    int levelValue = 1;

    switch (level) {
      case DifficultyLevels.rookie:
        difficultyTitle = 'ROOKIE';
        difficultyColor = Colors.lightBlueAccent;
        difficultyColorTxt = CbColors.white;
        break;
      case DifficultyLevels.allstar:
        difficultyTitle = 'ALL-STAR';
        difficultyColor = const Color.fromARGB(255, 255, 98, 0);
        difficultyColorTxt = CbColors.white;
        levelValue = 3;
        break;
      case DifficultyLevels.pro:
        difficultyTitle = 'PRO';
        difficultyColor = const Color.fromARGB(255, 0, 75, 238);
        difficultyColorTxt = CbColors.white;
        levelValue = 2;
        break;
      case DifficultyLevels.elite:
        difficultyTitle = 'ELITE';
        difficultyBorder = isDarkMode ? Colors.amber : Colors.amber.shade900;
        difficultyColor = const Color.fromARGB(255, 25, 33, 38);
        difficultyColorTxt = Colors.amber;
        levelValue = 3;
        break;
    }

    return {
      'difficultyTitle': difficultyTitle,
      'difficultyColor': difficultyColor,
      'difficultyColorTxt': difficultyColorTxt,
      'difficultyBorder': difficultyBorder,
      'levelValue': levelValue,
    };
  }

  static String formatDuration(int totalSeconds) {
    if (totalSeconds < 60) {
      return '$totalSeconds s';
    }

    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    // Only minutes (less than 1 hour)
    if (hours == 0) {
      if (seconds == 0) {
        return '$minutes min';
      }
      return '$minutes:${seconds.toString().padLeft(2, '0')} min';
    }

    // Hours
    if (minutes == 0) {
      return '$hours h';
    }

    return '${hours}h ${minutes}min';
  }

  static Color? getColor(String value) {
    /// Define your product specific colors here and it will match the attribute colors and show specific 🟠🟡🟢🔵🟣🟤

    if (value == 'Green') {
      return Colors.green;
    } else if (value == 'Green') {
      return Colors.green;
    } else if (value == 'Red') {
      return Colors.red;
    } else if (value == 'Blue') {
      return Colors.blue;
    } else if (value == 'Pink') {
      return Colors.pink;
    } else if (value == 'Grey') {
      return Colors.grey;
    } else if (value == 'Purple') {
      return Colors.purple;
    } else if (value == 'Black') {
      return Colors.black;
    } else if (value == 'White') {
      return Colors.white;
    } else if (value == 'Yellow') {
      return Colors.yellow;
    } else if (value == 'Orange') {
      return Colors.deepOrange;
    } else if (value == 'Brown') {
      return Colors.brown;
    } else if (value == 'Teal') {
      return Colors.teal;
    } else if (value == 'Indigo') {
      return Colors.indigo;
    } else {
      return null;
    }
  }

  static void showSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static String formatSeconds(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    return minutes;
  }

  static String formatViews(int? viewCount) {
    if (viewCount == null) return '0';
    if (viewCount >= 1000000) {
      return '${(viewCount / 1000000).toStringAsFixed(1)}M';
    } else if (viewCount >= 1000) {
      return '${(viewCount / 1000).toStringAsFixed(1)}K';
    }
    return viewCount.toString();
  }

  static void showAlert(String title, String message) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize() {
    return MediaQuery.of(Get.context!).size;
  }

  static double screenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  static double screenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }

  static String getFormattedDate(DateTime date,
      {String format = 'dd MMM yyyy'}) {
    return DateFormat(format).format(date);
  }

  static String formatTimestamp(Timestamp timestamp) {
    final now = DateTime.now();
    final date = timestamp.toDate();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) {
      return 'há alguns segundos';
    } else if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return '$m minuto${m > 1 ? 's' : ''} atrás';
    } else if (diff.inHours < 24) {
      final h = diff.inHours;
      return '$h hora${h > 1 ? 's' : ''} atrás';
    } else if (diff.inDays < 7) {
      final d = diff.inDays;
      return '$d dia${d > 1 ? 's' : ''} atrás';
    } else if (diff.inDays < 30) {
      final w = (diff.inDays / 7).floor();
      return '$w semana${w > 1 ? 's' : ''} atrás';
    } else if (diff.inDays < 365) {
      final mo = (diff.inDays / 30).floor();
      return '$mo ${mo > 1 ? 'meses' : 'mês'} atrás';
    } else {
      final y = (diff.inDays / 365).floor();
      return '$y ano${y > 1 ? 's' : ''} atrás';
    }
  }

  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrappedList = <Widget>[];
    for (var i = 0; i < widgets.length; i += rowSize) {
      final rowChildren = widgets.sublist(
          i, i + rowSize > widgets.length ? widgets.length : i + rowSize);
      wrappedList.add(Row(children: rowChildren));
    }
    return wrappedList;
  }
}
