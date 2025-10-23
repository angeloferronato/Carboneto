import 'package:carboneto/features/personalization/screens/profile/widgets/highlight_text.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ContentGrid extends StatelessWidget {
  const ContentGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          HighlightText(
            textValue: 'Treinos Criados',
            textSize: 15,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(67, 147, 147, 147),
            ),
            height: 1,
          ),

          // FAZER NO FUTURO A LOGICA DE MOSTRAR OS TREINOS SE EXISTIREM:
          // WIDGET PRONTO:
          // CbGridLayout(
          //     itemCount: data.length,
          //     mainAxisExtent: 200,
          //     columnCount: 3,
          //     crossSpacing: 5,
          //     itemBuilder: (_, index) {
          //       final treino = data[index];
          //       return _TreinoCard(treino: treino);
          //     }),

          Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Icon(
                Icons.add,
                size: 70,
                color: CbColors
                    .buttonSecondary, // opcional, para combinar com seu tema
              ),
              const SizedBox(height: 10),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                child: Column(
                  children: [
                    Text(
                      'Você ainda não possui treinos criados.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: CbColors.buttonSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Crie um novo treino para começar a organizar suas sessões de basquete.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: CbColors.buttonSecondary,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
