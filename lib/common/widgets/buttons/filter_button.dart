import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
    this.onFilterApplied,
    this.currentFilters,
  });

  final Function(Map<String, dynamic>)? onFilterApplied;

  final Map<String, dynamic>? currentFilters;

  void _showFilterModal(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    showModalBottomSheet(
      backgroundColor: isDarkMode? CbColors.dark : CbColors.light,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => FilterModalContent(
        initialFilters: currentFilters ?? {},
        onFilterApplied: onFilterApplied,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = CbHelperFunctions.isDarkMode(context);
    final bool hasFilters = currentFilters != null &&
        currentFilters!.values.any((v) {
          if (v == null) return false;
          if (v is bool) return v;
          if (v is int) return false; // durationMin/Max always present
          return true;
        });

    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: () => _showFilterModal(context),
      child: Container(
        height: 40,
        width: 47,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: hasFilters
                ? [
                    CbColors.primary.withValues(alpha:0.35),
                    CbColors.primary.withValues(alpha: 0.15),
                  ]
                : const [
                    Color(0x31467CB8),
                    Color(0x61152E42),
                  ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: hasFilters ? CbColors.primary : CbColors.borderBlue,
            width: 1,
          ),
        ),
        child: Icon(
          Icons.tune_rounded,
          color: hasFilters
              ? CbColors.primary
              : isDarkMode
                  ? CbColors.white
                  : CbColors.dark,
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
    this.initialFilters = const {},
  });

  final Function(Map<String, dynamic>)? onFilterApplied;
  final Map<String, dynamic> initialFilters;

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
      'icon': Icons.local_fire_department,
    },
    {'label': 'Melhor Avaliados', 'value': 'rating', 'icon': Iconsax.like_1},
    {
      'label': 'Alfabética (A-Z)',
      'value': 'alphabetical',
      'icon': Iconsax.text,
    },
  ];

  @override
  void initState() {
    super.initState();
    final f = widget.initialFilters;
    selectedDifficulty  = f['difficulty'] as String?;
    selectedPeopleCount = f['peopleCount'] as int?;
    selectedOrder       = f['order'] as String?;
    showVerifiedOnly    = (f['verifiedOnly'] as bool?) ?? false;

    final min = f['durationMin'] as int?;
    final max = f['durationMax'] as int?;
    if (min != null && max != null) {
      durationRange = RangeValues(min.toDouble(), max.toDouble());
    }
  }

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
      selectedDifficulty  = null;
      selectedDuration    = null;
      selectedPeopleCount = null;
      selectedOrder       = null;
      showVerifiedOnly    = false;
      durationRange       = const RangeValues(0, 180);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = CbHelperFunctions.isDarkMode(context);
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
                  Text(
                    'Filtros',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color:
                          isDarkMode ? Colors.white : CbColors.darkerGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Difficulty
              _buildSectionTitle('Nível de Dificuldade'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: difficultyOptions.map((option) {
                  final isSelected = selectedDifficulty == option['value'];
                  return _buildFilterChip(
                    isDarkMode: isDarkMode,
                    label: option['label'],
                    icon: option['icon'],
                    isSelected: isSelected,
                    onTap: () => setState(() {
                      selectedDifficulty =
                          isSelected ? null : option['value'] as String;
                    }),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Duration slider
              _buildSectionTitle('Duração (minutos)'),
              const SizedBox(height: 8),
              Text(
                '${durationRange.start.round()} min – ${durationRange.end.round()} min',
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : CbColors.darkerGrey,
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  valueIndicatorColor: CbColors.primary,
                  valueIndicatorTextStyle: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white),
                  activeTrackColor: CbColors.primary,
                  inactiveTrackColor: isDarkMode
                      ? CbColors.white.withValues(alpha: 0.2)
                      : CbColors.darkGrey,
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
                  onChanged: (values) =>
                      setState(() => durationRange = values),
                ),
              ),
              const SizedBox(height: 24),

              // People count
              _buildSectionTitle('Nº de Pessoas Necessárias'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: peopleOptions.map((option) {
                  final isSelected = selectedPeopleCount == option['value'];
                  return _buildFilterChip(
                    isDarkMode: isDarkMode,
                    label: option['label'],
                    icon: option['icon'],
                    isSelected: isSelected,
                    onTap: () => setState(() {
                      selectedPeopleCount =
                          isSelected ? null : option['value'] as int;
                    }),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Order
              _buildSectionTitle('Ordenar Por'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: orderOptions.map((option) {
                  final isSelected = selectedOrder == option['value'];
                  return _buildFilterChip(
                    isDarkMode: isDarkMode,
                    label: option['label'],
                    icon: option['icon'],
                    isSelected: isSelected,
                    onTap: () => setState(() {
                      selectedOrder =
                          isSelected ? null : option['value'] as String;
                    }),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Verified only
              Container(
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? CbColors.white.withValues(alpha: 0.05)
                      : CbColors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SwitchListTile(
                  title: Row(
                    children: [
                      Icon(Iconsax.verify5,
                          size: 20, color: CbColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Apenas Verificados',
                        style: TextStyle(
                          color:
                              isDarkMode ? Colors.white : CbColors.dark,
                        ),
                      ),
                    ],
                  ),
                  value: showVerifiedOnly,
                  onChanged: (value) =>
                      setState(() => showVerifiedOnly = value),
                  activeThumbColor: CbColors.primary,
                ),
              ),
              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clearFilters,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: isDarkMode
                              ? CbColors.white.withValues(alpha: 0.2)
                              : CbColors.darkGrey,
                        ),
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Limpar',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: 15),
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
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
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
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final isDarkMode = CbHelperFunctions.isDarkMode(Get.context!);
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDarkMode ? CbColors.white : CbColors.dark,
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected
                ? [
                    CbColors.primary.withValues(alpha: 0.35),
                    CbColors.primary.withValues(alpha: 0.15),
                  ]
                : const [
                    Color(0x31467CB8),
                    Color(0x61152E42),
                  ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? CbColors.primary : CbColors.borderBlue,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? CbColors.primary : Colors.white70,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? CbColors.primary : Colors.white70,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}