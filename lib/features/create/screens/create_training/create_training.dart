import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:carboneto/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';

class CreateTraining extends StatefulWidget {
  const CreateTraining({super.key});

  @override
  State<CreateTraining> createState() => _CreateTrainingState();
}

class _CreateTrainingState extends State<CreateTraining> {
  List<String> _selectedTags = ["Intermediário", "Agilidade"];

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = CbHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: CbAppBar(
        title: const Text(
          'Criar Treino',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        centerTitle: true,
        showBackArrow: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(CbSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CbRoundedImage(
                imageUrl: CbImages.thumbnailTrainingExample,
                height: 250,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),

              CreateForm(
                label: 'Titulo', 
                hintText: 'How to train like Steph Curry', 
                validateEmpty: 'How to train like Steph Curry'
              ),
              const SizedBox(height: 20),
              CreateForm(
                label: 'Descrição', 
                hintText: 'Want to shoot, move, and handle the ball like one of the greatest shooters in NBA history? In this video, we break down Steph Curry’s signature training routine', 
                validateEmpty: 'Descrição do treino',
                maxLines: 7,
              ),
              const SizedBox(height: 20),
              // ----- TAG SELECTOR -----
              Text(
                'Adicionar Tags',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Plus Jakarta Sans',
                  color: isDarkTheme ? CbColors.white : CbColors.black,
                ),
              ),
              const SizedBox(height: 10),
              TagSelector(
                initialTags: _selectedTags,
                onTagChanged: (tag, added) {
                  setState(() {
                    if (added) {
                      if (!_selectedTags.contains(tag)) _selectedTags.add(tag);
                    } else {
                      _selectedTags.remove(tag);
                    }
                  });
                },
              ),

              const SizedBox(height: 40),
              Column(
                children: [
                  Image(image: AssetImage(CbImages.basket)),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 0),
                    child: Text(
                      'Adicione um exercicio para começar seu treinamento',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: CbColors.darkGrey,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 20),
                    child: Text('Adicionar Exercício', style: 
                      TextStyle(
                        fontSize: 14,
                      )
                    ,),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CreateForm extends StatelessWidget {
  const CreateForm ({super.key, required this.label, required this.hintText, required this.validateEmpty, this.maxLines = 1});
  final String label;
  final String hintText;
  final String validateEmpty;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Plus Jakarta Sans',
            color: CbColors.white,
          ),
        ),
        const SizedBox(height: 8),
        FocusedTextField(
          hintText:
              hintText,
          validator: (value) =>
              CbValidator.validateEmptyText(validateEmpty, value),
          contentPadding: const EdgeInsets.all(15),
          maxLines: maxLines,
        ),
      ],
    );
  }
}

// ---------- TAG SELECTOR ----------
// ---------- TAG SELECTOR ----------
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TagSearchScreen(
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

// ---------- TAG SEARCH SCREEN ----------
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
            fontWeight: FontWeight.w800,
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
