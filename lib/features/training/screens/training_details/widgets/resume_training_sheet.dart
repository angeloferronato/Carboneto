import 'package:carboneto/common/widgets/buttons/cb_primary_btn.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/highlight_btn.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class ResumeTrainingSheet extends StatelessWidget {
  const ResumeTrainingSheet({
    super.key,
    required this.isDark,
    required this.progress,
    required this.onContinue,
    required this.onStartOver,
  });

  final bool isDark;

  /// Progress percentage (0–100) from Firestore, used to render the bar.
  final int progress;

  final VoidCallback onContinue;
  final VoidCallback onStartOver;

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textPrimary = isDark ? Colors.white : Colors.black87;
    final textSecondary = isDark ? Colors.white60 : Colors.black54;
    final divider = isDark ? Colors.white12 : Colors.black12;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        12,
        24,
        32 + MediaQuery.of(context).viewPadding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 28),

          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CbColors.primary.withValues(alpha: 0.15),
            ),
            child: const Icon(
              Icons.replay_rounded,
              color: CbColors.primary,
              size: 34,
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            'Treino em andamento',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            'Você tem um treino salvo. Deseja continuar\nde onde parou ou começar do zero?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),

          // Progress indicator
          _ProgressRow(
            progress: progress,
            isDark: isDark,
            textSecondary: textSecondary,
          ),

          const SizedBox(height: 28),
          Divider(color: divider, height: 1),
          const SizedBox(height: 20),

          // Buttons
          SizedBox(
            width: double.infinity,
            height: 52,
            child: CbPrimaryBtn(
              label: 'Continuar treino', 
              onPressed: onContinue
            )
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: HighlightBtn(
              textValue: 'Começar do zero', 
              onPressedEdit: onStartOver,
              labelWeight: FontWeight.w400,
            )
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.progress,
    required this.isDark,
    required this.textSecondary,
  });

  final int progress;
  final bool isDark;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0, 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progresso salvo',
              style: TextStyle(
                fontSize: 13,
                color: textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$clampedProgress%',
              style: const TextStyle(
                fontSize: 13,
                color: CbColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Container(
                height: 7,
                width: double.infinity,
                color: (isDark ? Colors.white : Colors.black)
                    .withValues(alpha: 0.1),
              ),
              FractionallySizedBox(
                widthFactor: clampedProgress / 100,
                child: Container(
                  height: 7,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [CbColors.accent, CbColors.primary],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
