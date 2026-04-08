import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

enum ProfileTab { treinos, painel }

class ProfileTabBar extends StatelessWidget {
  const ProfileTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
    required this.isCoach,
    required this.isTeam,
  });

  final ProfileTab selectedTab;
  final ValueChanged<ProfileTab> onTabChanged;
  final bool isCoach, isTeam;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TabItem(
          label: 'Treinos Criados',
          isSelected: selectedTab == ProfileTab.treinos,
          onTap: () => onTabChanged(ProfileTab.treinos),
        ),
        _TabItem(
          label: isCoach ? 'Painel do Treinador' : isTeam ? 'Painel do Time' : 'Painel do Atleta',
          isSelected: selectedTab == ProfileTab.painel,
          onTap: () => onTabChanged(ProfileTab.painel),
        ),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w400,
                  color: isSelected
                      ? CbColors.primary
                      : CbColors.buttonSecondary,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              decoration: BoxDecoration(
                color: isSelected ? CbColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ],
        ),
      ),
    );
  }
}