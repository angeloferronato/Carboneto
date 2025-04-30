import 'package:carboneto/utils/theme/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      darkTheme: CbAppTheme.darkTheme,
      theme: CbAppTheme.lightTheme
    );
  }

}