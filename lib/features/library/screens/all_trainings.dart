import 'package:carboneto/features/library/screens/library.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class AllTrainingsScreen extends StatelessWidget {
  const AllTrainingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CbColors.dark,
      appBar: AppBar(
        backgroundColor: CbColors.dark,
        elevation: 0,
        title: const Text(
          "Seus Treinos",
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w800,
            fontFamily: 'Plus Jakarta Sans'
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,       // 👈 3 colunas fixas
            mainAxisSpacing: 16,     // espaçamento vertical
            crossAxisSpacing: 16,    // espaçamento horizontal
            childAspectRatio: 0.6,   // controla altura do card
          ),
          itemCount: 18,              // simula "todos os treinos"
          itemBuilder: (context, index) {
            return const CreatedTraining();
          },
        ),
      ),
    );
  }
}
