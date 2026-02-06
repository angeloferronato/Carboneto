import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
    this.onFilterApplied,
  });

  final Function(Map<String, dynamic>)? onFilterApplied;

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: CbColors.dark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => FilterModalContent(
        onFilterApplied: onFilterApplied,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: () => _showFilterModal(context),
      child: Container(
        height: 40,
        width: 47,
        decoration: BoxDecoration(
          color: CbColors.dark,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: CbColors.white.withValues(alpha: 0.1),
            width: 1.2,
          ),
        ),
        child: const Icon(
          Icons.tune_rounded,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }
}

class FilterModalContent extends StatefulWidget {
  const FilterModalContent({
    super.key,
    this.onFilterApplied,
  });

  final Function(Map<String, dynamic>)? onFilterApplied;

  @override
  State<FilterModalContent> createState() => _FilterModalContentState();
}

class _FilterModalContentState extends State<FilterModalContent> {
  String? selectedDifficulty;
  String? selectedDuration;
  int? selectedPeopleCount;
  String? selectedOrder;
  RangeValues durationRange = const RangeValues(0, 180);
  bool showVerifiedOnly = false;

  final List<Map<String, dynamic>> difficultyOptions = [
    {'label': 'Rookie', 'value': 'rookie', 'icon': Icons.school_outlined},
    {'label': 'Pro', 'value': 'pro', 'icon': Iconsax.cup},
    {'label': 'All Star', 'value': 'allstar', 'icon': Iconsax.medal_star},
    {'label': 'Elite', 'value': 'elite', 'icon': Iconsax.crown},
  ];

  final List<Map<String, dynamic>> durationOptions = [
    {'label': 'Curta (< 30 min)', 'value': 'short', 'icon': Iconsax.timer_1},
    {'label': 'Média (30-60 min)', 'value': 'medium', 'icon': Iconsax.timer},
    {'label': 'Longa (> 60 min)', 'value': 'long', 'icon': Iconsax.clock},
  ];

  final List<Map<String, dynamic>> peopleOptions = [
    {'label': '1 pessoa', 'value': 1, 'icon': Iconsax.user},
    {'label': '2-4 pessoas', 'value': 4, 'icon': Iconsax.profile_2user},
    {'label': '5+ pessoas', 'value': 5, 'icon': Icons.groups_outlined},
  ];

  final List<Map<String, dynamic>> orderOptions = [
    {'label': 'Mais Recentes', 'value': 'recent', 'icon': Iconsax.clock},
    {
      'label': 'Mais Populares',
      'value': 'popular',
      'icon': Icons.local_fire_department
    },
    {'label': 'Melhor Avaliados', 'value': 'rating', 'icon': Iconsax.like_1},
    {
      'label': 'Alfabética (A-Z)',
      'value': 'alphabetical',
      'icon': Iconsax.text
    },
  ];

  void _applyFilters() {
    final filters = {
      'difficulty': selectedDifficulty,
      'durationMin': durationRange.start.round(),
      'durationMax': durationRange.end.round(),
      'peopleCount': selectedPeopleCount,
      'order': selectedOrder,
      'verifiedOnly': showVerifiedOnly,
    };
    widget.onFilterApplied?.call(filters);
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      selectedDifficulty = null;
      selectedDuration = null;
      selectedPeopleCount = null;
      selectedOrder = null;
      showVerifiedOnly = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.only(right: 20, left: 20, bottom: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filtros',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Difficulty Section
              _buildSectionTitle('Nível de Dificuldade'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: difficultyOptions.map((option) {
                  final isSelected = selectedDifficulty == option['value'];
                  return _buildFilterChip(
                    label: option['label'],
                    icon: option['icon'],
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        selectedDifficulty =
                            isSelected ? null : option['value'];
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Duration Section
              // Duration Slider
              _buildSectionTitle('Duração (minutos)'),
              const SizedBox(height: 8),

              Text(
                '${durationRange.start.round()} min – ${durationRange.end.round()} min',
                style: const TextStyle(color: Colors.white70),
              ),

              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  valueIndicatorColor: CbColors.primary, // bubble bg
                  valueIndicatorTextStyle: const TextStyle(
                      color: Colors.white, // NUMBER color
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Plus Jakarta Sans'),
                  activeTrackColor: CbColors.primary,
                  inactiveTrackColor: CbColors.white.withValues(alpha: 0.2),
                  thumbColor: CbColors.primary,
                  overlayColor: CbColors.primary.withValues(alpha: 0.2),
                ),
                child: RangeSlider(
                  values: durationRange,
                  min: 0,
                  max: 180,
                  divisions: 18,
                  labels: RangeLabels(
                    '${durationRange.start.round()} min',
                    '${durationRange.end.round()} min',
                  ),
                  onChanged: (values) {
                    setState(() {
                      durationRange = values;
                    });
                  },
                ),
              ),

              const SizedBox(height: 24),

              // People Count Section
              _buildSectionTitle('Nº de Pessoas Necessárias'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: peopleOptions.map((option) {
                  final isSelected = selectedPeopleCount == option['value'];
                  return _buildFilterChip(
                    label: option['label'],
                    icon: option['icon'],
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        selectedPeopleCount =
                            isSelected ? null : option['value'];
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Order Section
              _buildSectionTitle('Ordenar Por'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: orderOptions.map((option) {
                  final isSelected = selectedOrder == option['value'];
                  return _buildFilterChip(
                    label: option['label'],
                    icon: option['icon'],
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        selectedOrder = isSelected ? null : option['value'];
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Verified Only Toggle
              Container(
                decoration: BoxDecoration(
                  color: CbColors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SwitchListTile(
                  title: const Row(
                    children: [
                      Icon(Iconsax.verify5, size: 20, color: CbColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'Apenas Verificados',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  value: showVerifiedOnly,
                  onChanged: (value) {
                    setState(() {
                      showVerifiedOnly = value;
                    });
                  },
                  activeThumbColor: CbColors.primary,
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clearFilters,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: CbColors.white.withValues(alpha: 0.2),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Limpar',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CbColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Aplicar Filtros',
                        style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        )));
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? CbColors.primary
              : CbColors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? CbColors.primary
                : CbColors.white.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.white70,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

