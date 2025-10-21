import 'package:carboneto/features/create/screens/create_training/widgets/cb_primary_btn.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class SquareUploadWidget extends StatelessWidget {
  const SquareUploadWidget({
    super.key,
    required this.onSelectFiles,
    this.label = "",
    this.description = "",
  });

  final String label, description;

  final VoidCallback onSelectFiles;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 250,
        decoration: BoxDecoration(
            border: Border.all(
              color: CbColors.darkGrey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Upload icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: CbColors.inputBG,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.upload_rounded,
                size: 30,
                color: CbColors.primary,
              ),
            ),
            const SizedBox(height: 15),

            // Main text
            Text(
              // "Upload video",
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: CbColors.lightGrey,
              ),
            ),
            const SizedBox(height: 8),

            // Subtext
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child:  Text(
                // "Selecionar arquivo de video. Tamanho máx 50mb.",
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: CbColors.lightGrey,
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Select files button
            CbPrimaryBtn(label: 'Selecionar', fontSize: 13, onPressed: () => {})
          ],
        ),
      ),
    );
  }
}
