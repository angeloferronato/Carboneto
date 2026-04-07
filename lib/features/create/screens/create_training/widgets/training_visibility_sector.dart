import 'package:carboneto/features/create/controllers/create_training_controller.dart';
import 'package:carboneto/features/personalization/controllers/edit_training/edit_training.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrainingVisibilitySelector extends StatelessWidget {
  const TrainingVisibilitySelector({super.key, this.tag});

  final String? tag;

  (Rx<TrainingVisibility>, void Function(TrainingVisibility)) _resolve() {
    if (tag != null) {
      final c = Get.find<EditTrainingController>(tag: tag);
      return (c.visibility, c.setVisibility);
    }
    final c = Get.find<CreateTrainingController>();
    return (c.visibility, c.setVisibility);
  }

  @override
  Widget build(BuildContext context) {
    final (visibility, setVisibility) = _resolve();

    return Obx(
      () => Column(
        children: [
          _VisibilityTile(
            icon: Icons.public,
            title: 'Público',
            subtitle: 'Qualquer pessoa pode ver este treino',
            value: TrainingVisibility.public,
            selected: visibility.value == TrainingVisibility.public,
            onTap: () => setVisibility(TrainingVisibility.public),
          ),
          const SizedBox(height: 10),
          _VisibilityTile(
            icon: Icons.group,
            title: 'Seguidores',
            subtitle: 'Apenas pessoas que te seguem',
            value: TrainingVisibility.followers,
            selected: visibility.value == TrainingVisibility.followers,
            onTap: () => setVisibility(TrainingVisibility.followers),
          ),
          const SizedBox(height: 10),
          _VisibilityTile(
            icon: Icons.lock_rounded,
            title: 'Somente eu',
            subtitle: 'Apenas você pode ver',
            value: TrainingVisibility.private,
            selected: visibility.value == TrainingVisibility.private,
            onTap: () => setVisibility(TrainingVisibility.private),
          ),
        ],
      ),
    );
  }
}

class _VisibilityTile extends StatelessWidget {
  const _VisibilityTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title, subtitle;
  final TrainingVisibility value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0x31467CB8), Color(0x61152E42)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? CbColors.primary : CbColors.borderBlue,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? CbColors.primary : Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle, color: CbColors.primary),
          ],
        ),
      ),
    );
  }
}