import 'package:carboneto/features/settings/screens/help_settings/widgets/faq_item.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class FaqSection extends StatelessWidget {
  const FaqSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Perguntas frequentes',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .apply(color: CbColors.white),
            ),
            SizedBox(width: 10,),
            Icon(Icons.help_outline_outlined)
          ],
        ),
        const SizedBox(height: 12),
        FaqItem(
          question: 'Posso repetir um treino já realizado?',
          answer:
              'Sim. Todos os treinos ficam salvos no histórico e podem ser iniciados novamente a qualquer momento.',
        ),
        FaqItem(
          question: 'Posso criar meus próprios treinos?',
          answer:
              'Sim. Você pode criar treinos personalizados de acordo com seus objetivos e salvá-los para usar sempre que quiser.',
        ),
        FaqItem(
          question: 'Posso usar o app em mais de um dispositivo?',
          answer:
              'Sim. Ao fazer login na sua conta, seus treinos e progresso são sincronizados entre dispositivos.',
        ),
        FaqItem(
          question: 'Preciso de internet para usar?',
          answer:
              'Algumas funcionalidades exigem conexão com a internet, como vídeos e sincronização.',
        ),
      ],
    );
  }
}
