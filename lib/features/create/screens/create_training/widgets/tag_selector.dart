import 'package:carboneto/features/create/screens/create_training/widgets/tag_search_screen.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class TagSelector extends StatefulWidget {
  final void Function(String tag, bool added) onTagChanged;
  final List<String> initialTags;

  const TagSelector({
    super.key,
    required this.onTagChanged,
    this.initialTags = const [],
  });

  @override
  State<TagSelector> createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {
  late List<String> _tags;
  String? _selectedTag;

  @override
  void initState() {
    super.initState();
    _tags = List.from(widget.initialTags);
  }

  void _openTagSearch() {
    Get.to(
      TagSearchScreen(
        selectedTags: _tags,
        onTagChanged: (tag, added) {
          setState(() {
            if (added) {
              if (!_tags.contains(tag)) _tags.add(tag);
            } else {
              _tags.remove(tag);
            }
          });
          widget.onTagChanged(
              tag, added); // Atualiza CreateTraining automaticamente
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _tags.map((tag) {
                return InputChip(
                  label: Text(
                    tag,
                    style: TextStyle(
                      color: (isDarkTheme ? CbColors.white : CbColors.black),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: CbColors.primary,
                    ),
                  ),
                  onDeleted: () {
                    setState(() => _tags.remove(tag));
                    widget.onTagChanged(tag, false);
                  },
                  deleteIconColor: CbColors.accent,
                );
              }).toList(),
            ),
          ),
          IconButton(
            onPressed: _openTagSearch,
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.blueAccent,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

