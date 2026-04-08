import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class ExerciseFilterButton extends StatelessWidget {
  const ExerciseFilterButton({
    super.key,
    required this.currentFilters,
    required this.onFilterApplied,
  });

  final Map<String, dynamic> currentFilters;
  final void Function(Map<String, dynamic>) onFilterApplied;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = CbHelperFunctions.isDarkMode(context);
    final bool hasFilters = currentFilters.values.any((v) {
      if (v == null) return false;
      if (v is bool) return v;
      if (v is int) return false; // duration Min/Max always present
      return true;
    });

    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: () {
        showModalBottomSheet(
          backgroundColor: isDarkMode ? CbColors.dark : CbColors.light,
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          isScrollControlled: true,
          builder: (context) => _ExerciseFilterModalContent(
            initialFilters: currentFilters,
            onFilterApplied: onFilterApplied,
          ),
        );
      },
      child: Container(
        height: 40,
        width: 47,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: hasFilters
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

class _ExerciseFilterModalContent extends StatefulWidget {
  const _ExerciseFilterModalContent({
    required this.initialFilters,
    required this.onFilterApplied,
  });

  final Map<String, dynamic> initialFilters;
  final void Function(Map<String, dynamic>) onFilterApplied;

  @override
  State<_ExerciseFilterModalContent> createState() =>
      _ExerciseFilterModalContentState();
}

class _ExerciseFilterModalContentState
    extends State<_ExerciseFilterModalContent> {
  int? selectedPeopleCount;
  RangeValues durationRange = const RangeValues(0, 180);
  bool showVerifiedOnly = false;

  static const _peopleOptions = [
    {'label': '1 pessoa', 'value': 1, 'icon': Icons.person_outline},
    {'label': '2-4 pessoas', 'value': 4, 'icon': Icons.groups_2_outlined},
    {'label': '5+ pessoas', 'value': 5, 'icon': Icons.groups_outlined},
  ];

  @override
  void initState() {
    super.initState();
    final f = widget.initialFilters;
    selectedPeopleCount = f['peopleCount'] as int?;
    showVerifiedOnly = (f['verifiedOnly'] as bool?) ?? false;
    final min = f['durationMin'] as int?;
    final max = f['durationMax'] as int?;
    if (min != null && max != null) {
      durationRange = RangeValues(min.toDouble(), max.toDouble());
    }
  }

  void _apply() {
    widget.onFilterApplied({
      'durationMin': durationRange.start.round(),
      'durationMax': durationRange.end.round(),
      'peopleCount': selectedPeopleCount,
      'verifiedOnly': showVerifiedOnly,
    });
    Navigator.pop(context);
  }

  void _clear() {
    setState(() {
      selectedPeopleCount = null;
      showVerifiedOnly = false;
      durationRange = const RangeValues(0, 180);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = CbHelperFunctions.isDarkMode(context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(right: 20, left: 20, bottom: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      color: isDarkMode ? Colors.white : CbColors.darkerGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _sectionTitle(context, 'Duração (minutos)', isDarkMode),
              const SizedBox(height: 8),
              Text(
                '${durationRange.start.round()} min – ${durationRange.end.round()} min',
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : CbColors.darkerGrey,
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
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
                  onChanged: (values) => setState(() => durationRange = values),
                ),
              ),
              const SizedBox(height: 24),
              _sectionTitle(context, 'Nº de Pessoas Necessárias', isDarkMode),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _peopleOptions.map((option) {
                  final isSelected = selectedPeopleCount == option['value'];
                  return _chip(
                    context,
                    isDarkMode: isDarkMode,
                    label: option['label'] as String,
                    icon: option['icon'] as IconData,
                    isSelected: isSelected,
                    onTap: () => setState(() {
                      selectedPeopleCount =
                          isSelected ? null : option['value'] as int;
                    }),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
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
                      Icon(Icons.verified_outlined,
                          size: 20, color: CbColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Criadores verificados',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : CbColors.dark,
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
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clear,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: isDarkMode
                              ? CbColors.white.withValues(alpha: 0.2)
                              : CbColors.darkGrey,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
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
                      onPressed: _apply,
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

  Widget _sectionTitle(BuildContext context, String title, bool isDarkMode) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDarkMode ? CbColors.white : CbColors.dark,
      ),
    );
  }

  Widget _chip(
    BuildContext context, {
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

