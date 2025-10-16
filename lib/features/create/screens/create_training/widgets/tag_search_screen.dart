import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';


class TagSearchScreen extends StatefulWidget {
  final List<String> selectedTags;
  final void Function(String tag, bool added) onTagChanged;

  const TagSearchScreen({
    super.key,
    this.selectedTags = const [],
    required this.onTagChanged,
  });

  @override
  State<TagSearchScreen> createState() => _TagSearchScreenState();
}

class _TagSearchScreenState extends State<TagSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _allTags = [
    "Intermediário",
    "Avançado",
    "Arremesso",
    "Agilidade",
    "Defesa",
    "Passe",
    "Condicionamento",
    "Drible",
  ];

  late List<String> _selectedTags;

  @override
  void initState() {
    super.initState();
    _selectedTags = List.from(widget.selectedTags);
  }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text.toLowerCase();
    final results =
        _allTags.where((tag) => tag.toLowerCase().contains(query)).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: CbAppBar(
        title: const Text(
          'Adicionar Tags',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            fontFamily: 'Plus Jakarta Sans'
          ),
        ),
        centerTitle: true,
        showBackArrow: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FocusedTextField(
              controller: _controller,
              hintText: "Pesquisar ou criar nova tag...",
              onChanged: (_) => setState(() {}),
              onSubmitted: (value) {
                if (value.isNotEmpty && !_allTags.contains(value)) {
                  setState(() => _allTags.add(value));
                  _selectedTags.add(value);
                  widget.onTagChanged(value, true);
                }
              },
              contentPadding: const EdgeInsets.all(14),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: results.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (_, i) {
                  final tag = results[i];
                  final isSelected = _selectedTags.contains(tag);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedTags.remove(tag);
                        } else {
                          _selectedTags.add(tag);
                        }
                      });
                      widget.onTagChanged(
                          tag, !isSelected); // Atualização instantânea
                    },
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          width: isSelected ? 5 : 0,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? CbColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: ListTile(
                            tileColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            title: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? CbColors.primary
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
