import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class NumberDropdown extends StatefulWidget {
  final List<int> items;
  final int initialValue;
  final ValueChanged<int>? onChanged;

  const NumberDropdown({
    super.key,
    this.items = const [1, 2, 3, 4, 5],
    this.initialValue = 1,
    this.onChanged,
  });

  @override
  State<NumberDropdown> createState() => _NumberDropdownState();
}

class _NumberDropdownState extends State<NumberDropdown>
    with SingleTickerProviderStateMixin {
  late int selectedValue;
  late LayerLink _layerLink;
  OverlayEntry? _overlayEntry;
  late AnimationController _controller;
  late Animation<double> _arrowRotation;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
    _layerLink = LayerLink();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _arrowRotation = Tween<double>(begin: 0, end: -0.5).animate( // seta pra cima
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _showDropdown();
      _controller.forward();
    } else {
      _removeDropdown();
      _controller.reverse();
    }
  }

  void _showDropdown() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Fecha ao clicar fora
            Positioned.fill(
              child: GestureDetector(
                onTap: () => _toggleDropdown(),
                behavior: HitTestBehavior.translucent,
              ),
            ),

            // Dropdown posicionado acima
            Positioned(
              width: size.width,
              left: offset.dx,
              top: offset.dy - (widget.items.length * 48) - 10, // acima do botão
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, -size.height - 8),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: CbColors.dark,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: widget.items.map((item) {
                        final isSelected = item == selectedValue;
                        return InkWell(
                          onTap: () => _selectValue(item),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                            child: Row(
                              children: [
                                Text(
                                  item.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: isSelected
                                        ? CbColors.primary
                                        : CbColors.white,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectValue(int value) {
    setState(() => selectedValue = value);
    widget.onChanged?.call(value);
    _removeDropdown();
    _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    _removeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          decoration: BoxDecoration(
            color: CbColors.primary,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              if (_overlayEntry != null)
                const BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                selectedValue.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 3),
              RotationTransition(
                turns: _arrowRotation,
                child: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
