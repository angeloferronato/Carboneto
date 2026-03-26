import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SaveSuccessSheet extends StatelessWidget {
  const SaveSuccessSheet({super.key, required this.context});

  final BuildContext context;

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
          _buildHandle(),
          const SizedBox(height: 28),
          _buildIcon(),
          const SizedBox(height: 16),
          _buildTitle(isDark),
          const SizedBox(height: 8),
          _buildSubtitle(isDark),
          const SizedBox(height: 28),
          _buildConfirmButton(context),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: CbColors.primary.withValues(alpha: 0.12),
      ),
      child: Icon(Icons.check_rounded, color: CbColors.primary, size: 36),
    );
  }

  Widget _buildTitle(bool isDark) {
    return Text(
      'Treino salvo!',
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
      'As alterações foram salvas com sucesso.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14,
        fontFamily: 'Plus Jakarta Sans',
        color: isDark ? Colors.white54 : Colors.black45,
        height: 1.5,
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          Get.back();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: CbColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: const Text(
          'Concluir',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}