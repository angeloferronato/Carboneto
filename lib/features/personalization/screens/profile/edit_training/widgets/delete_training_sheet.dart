import 'package:carboneto/features/personalization/controllers/edit_training/edit_training.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteTrainingSheet extends StatelessWidget {
  const DeleteTrainingSheet({
    super.key,
    required this.context,
    required this.controller,
  });

  final BuildContext context;
  final EditTrainingController controller;

  @override
  Widget build(BuildContext context) {
    final isDark = CbHelperFunctions.isDarkMode(context);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1C) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        28,
        20,
        28,
        32 + MediaQuery.of(context).viewPadding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(),
          const SizedBox(height: 16),
          _buildTitle(isDark),
          const SizedBox(height: 8),
          _buildSubtitle(isDark),
          const SizedBox(height: 28),
          _buildActions(context, isDark),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.redAccent.withValues(alpha: 0.12),
      ),
      child: const Icon(
        Icons.delete_outline_rounded,
        color: Colors.redAccent,
        size: 34,
      ),
    );
  }

  Widget _buildTitle(bool isDark) {
    return Text(
      'Excluir treino?',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        fontFamily: 'Plus Jakarta Sans',
        color: isDark ? Colors.white : const Color(0xFF0D0D0D),
      ),
    );
  }

  Widget _buildSubtitle(bool isDark) {
    return Text(
      'Esta ação não pode ser desfeita. O treino será removido permanentemente.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14,
        fontFamily: 'Plus Jakarta Sans',
        color: isDark ? Colors.white54 : Colors.black45,
        height: 1.5,
      ),
    );
  }

  Widget _buildActions(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(child: _CancelButton(isDark: isDark)),
        const SizedBox(width: 12),
        Expanded(
          child: _DeleteButton(
            onConfirm: () async {
              final success = await controller.deleteTraining();
              if (success) {
                Get.close(2);
                CbLoaders.successSnackBar(
                  title: 'Treino excluído',
                  message: 'O treino foi removido com sucesso.',
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => Navigator.pop(context),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ).copyWith(
        side: WidgetStateProperty.resolveWith(
          (_) => BorderSide(color: isDark ? Colors.white24 : Colors.black26),
        ),
      ),
      child: Text(
        'Cancelar',
        style: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.onConfirm});

  final Future<void> Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async => await onConfirm(),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(CbColors.buttonChipTraining),
        padding:
            WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 14)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
        side: WidgetStateProperty.all(BorderSide.none),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        elevation: WidgetStateProperty.all(0),
      ),
      child: const Text(
        'Excluir',
        style: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
