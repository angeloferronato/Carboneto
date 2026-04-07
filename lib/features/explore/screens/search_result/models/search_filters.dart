import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────
// Category Mapper
// ─────────────────────────────────────────────────────────
// Move this class to its own file (e.g. utils/category_mapper.dart)
// and import it wherever needed.

class CategoryMapper {
  static const String fallback = 'Outros';

  static final Map<String, String> tagToMainCategory = {
    "Arremesso": "Arremesso",
    "Arremesso de 3 Pontos": "Arremesso",
    "Arremesso em Movimento": "Arremesso",
    "Arremesso sob Pressão": "Arremesso",
    "Fade-Away": "Arremesso",
    "Lance-livre": "Arremesso",
    "Mid-Range": "Arremesso",
    "Step-Back": "Arremesso",

    "Atleticismo": "Atleticismo",
    "Explosão": "Atleticismo",
    "Coordenação Motora": "Atleticismo",
    "Impulsão": "Atleticismo",
    "Mudança de Direção": "Atleticismo",
    "Velocidade": "Atleticismo",

    "Controle de Bola": "Controle de Bola",
    "Behind The Back": "Controle de Bola",
    "Mudança de Ritmo": "Controle de Bola",
    "Crossover": "Controle de Bola",
    "Drible de Proteção": "Controle de Bola",
    "Entre as Pernas": "Controle de Bola",
    "In and Out": "Controle de Bola",
    "Spin Move": "Controle de Bola",
    "Drible": "Controle de Bola",
    "Ballhandling": "Controle de Bola",

    "Defesa": "Defesa",
    "Box Out": "Defesa",
    "Contestação de Arremesso": "Defesa",
    "Defesa de Garrafão": "Defesa",
    "Defesa Individual": "Defesa",
    "Marcação Perímetro": "Defesa",
    "Roubo de Bola": "Defesa",

    "Finalização": "Finalização",
    "Bandeja Simples": "Finalização",
    "Enterrada": "Finalização",
    "Euro Step": "Finalização",
    "Finger Roll": "Finalização",
    "Floater": "Finalização",
    "Layup em Velocidade": "Finalização",
    "Reverse Layup": "Finalização",

    "QI de Basquete": "QI de Basquete",
    "Controle de Jogo": "QI de Basquete",
    "Jogo de Transição": "QI de Basquete",
    "Tomada de Decisão": "QI de Basquete",
  };

  /// All unique main categories in display order.
  static const List<String> mainCategories = [
    'Arremesso',
    'Atleticismo',
    'Controle de Bola',
    'Defesa',
    'Finalização',
    'QI de Basquete',
  ];

  /// Sub-tags for a given main category (excluding the main category itself).
  static List<String> subTagsFor(String main) {
    return tagToMainCategory.entries
        .where((e) => e.value == main && e.key != main)
        .map((e) => e.key)
        .toList();
  }

  static String mapTagToMain(String tag) =>
      tagToMainCategory[tag] ?? fallback;

  static List<String> mapTagsToMainCategories(List<String> tags) {
    return tags.map(mapTagToMain).toSet().toList();
  }
}

// ─────────────────────────────────────────────────────────
// Search Filters Bottom Sheet
// ─────────────────────────────────────────────────────────

class SearchFiltersSheet extends StatefulWidget {
  const SearchFiltersSheet({
    super.key,
    required this.selectedTags,
  });

  /// Tags that are already active when the sheet opens.
  final List<String> selectedTags;

  @override
  State<SearchFiltersSheet> createState() => _SearchFiltersSheetState();
}

class _SearchFiltersSheetState extends State<SearchFiltersSheet> {
  late final Set<String> _selected;

  // Which main categories are expanded in the sheet
  final Set<String> _expanded = {};

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedTags.toSet();

    // Auto-expand categories that have active filters
    for (final tag in _selected) {
      final main = CategoryMapper.mapTagToMain(tag);
      if (CategoryMapper.mainCategories.contains(main)) {
        _expanded.add(main);
      }
    }

    // If nothing is pre-selected, expand all by default
    if (_expanded.isEmpty) {
      _expanded.addAll(CategoryMapper.mainCategories);
    }
  }

  void _toggle(String tag) {
    setState(() {
      if (_selected.contains(tag)) {
        _selected.remove(tag);
      } else {
        _selected.add(tag);
      }
    });
  }

  void _toggleMain(String mainCategory) {
    setState(() {
      if (_expanded.contains(mainCategory)) {
        _expanded.remove(mainCategory);
      } else {
        _expanded.add(mainCategory);
      }
    });
  }

  void _clearAll() => setState(() => _selected.clear());

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      maxChildSize: 0.93,
      minChildSize: 0.45,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              _buildHandle(),
              _buildHeader(context),
              const Divider(color: Colors.white12, height: 1),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.only(
                    left: CbSizes.defaultSpace,
                    right: CbSizes.defaultSpace,
                    top: 8,
                    bottom: 120,
                  ),
                  children: CategoryMapper.mainCategories
                      .map(_buildCategorySection)
                      .toList(),
                ),
              ),
              _buildApplyBar(context),
            ],
          ),
        );
      },
    );
  }

  // ── Drag handle ─────────────────────────────────────────

  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.shade700,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        CbSizes.defaultSpace,
        8,
        CbSizes.defaultSpace,
        12,
      ),
      child: Row(
        children: [
          Text(
            'Filtros',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          if (_selected.isNotEmpty) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: CbColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_selected.length}',
                style: TextStyle(
                  color: CbColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          const Spacer(),
          if (_selected.isNotEmpty)
            TextButton(
              onPressed: _clearAll,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Limpar tudo',
                style: TextStyle(
                  color: CbColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Category section ─────────────────────────────────────

  Widget _buildCategorySection(String mainCategory) {
    final subTags = CategoryMapper.subTagsFor(mainCategory);
    final isExpanded = _expanded.contains(mainCategory);

    // Count how many tags in this category are selected
    final activeCount = _selected
        .where((t) =>
            CategoryMapper.mapTagToMain(t) == mainCategory ||
            t == mainCategory)
        .length;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Main category row (tap to expand/collapse) ──
          GestureDetector(
            onTap: () => _toggleMain(mainCategory),
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        mainCategory,
                        style: TextStyle(
                          color: activeCount > 0
                              ? CbColors.primary
                              : Colors.white70,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          letterSpacing: 0.3,
                        ),
                      ),
                      if (activeCount > 0) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 1),
                          decoration: BoxDecoration(
                            color: CbColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$activeCount',
                            style: TextStyle(
                              color: CbColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.white38,
                  size: 20,
                ),
              ],
            ),
          ),

          // ── Sub-tags (collapsible) ──────────────────────
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // Main category chip (selects all from this group)
                  _buildChip(mainCategory, isMain: true),
                  for (final sub in subTags) _buildChip(sub),
                ],
              ),
            ),
            secondChild: const SizedBox(width: double.infinity),
          ),

          const SizedBox(height: 8),
          const Divider(color: Colors.white10, height: 1),
        ],
      ),
    );
  }

  // ── Chip ─────────────────────────────────────────────────

  Widget _buildChip(String tag, {bool isMain = false}) {
    final isSelected = _selected.contains(tag);

    return GestureDetector(
      onTap: () => _toggle(tag),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? CbColors.primary
              : isMain
                  ? Colors.white.withOpacity(0.05)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? CbColors.primary
                : isMain
                    ? Colors.white24
                    : Colors.grey.shade800,
            width: isMain ? 1.5 : 1,
          ),
        ),
        child: Text(
          tag,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : isMain
                    ? Colors.white70
                    : Colors.grey.shade500,
            fontSize: isMain ? 13 : 12,
            fontWeight: isSelected || isMain
                ? FontWeight.w600
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // ── Apply bar ────────────────────────────────────────────

  Widget _buildApplyBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        CbSizes.defaultSpace,
        16,
        CbSizes.defaultSpace,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: const Border(top: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          // Cancel
          Expanded(
            flex: 2,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                side: BorderSide(color: Colors.grey.shade700),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(context, null),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Apply
          Expanded(
            flex: 3,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: CbColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 15),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(context, _selected.toList()),
              child: Text(
                _selected.isEmpty
                    ? 'Ver resultados'
                    : 'Aplicar (${_selected.length})',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}