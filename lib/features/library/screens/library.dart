import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';


class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CbColors.dark,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.construction,
                color: CbColors.darkGrey,
                size: 80,
              ),
              const SizedBox(height: 20),
              Text(
                'Em Desenvolvimento',
                style: TextStyle(
                  color: CbColors.darkGrey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Plus Jakarta Sans'
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Essa funcionalidade estará disponível em breve!',
                style: TextStyle(
                  color: CbColors.darkGrey,
                  fontSize: 14,
                  fontFamily: 'Plus Jakarta Sans'
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}