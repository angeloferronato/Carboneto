import 'package:carboneto/common/widgets/buttons/cb_primary_btn.dart';
import 'package:carboneto/features/training/controllers/training_execution_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';

class RepsInputModal extends StatefulWidget {
  const RepsInputModal({required this.controller, required this.isDarkTheme});
  final TrainingExecutionController controller;
  final bool isDarkTheme;

  @override
  State<RepsInputModal> createState() => _RepsInputModalState();
}

class _RepsInputModalState extends State<RepsInputModal> {
  late String _input;

  @override
  void initState() {
    super.initState();
    final current = widget.controller.completedReps.value;
    _input = current > 0 ? current.toString() : '';
  }

  void _append(String digit) {
    if (_input.length >= 6) return;
    setState(() => _input += digit);
  }

  void _backspace() {
    if (_input.isEmpty) return;
    setState(() => _input = _input.substring(0, _input.length - 1));
  }

  void _confirm() {
    final value = int.tryParse(_input);
    if (value != null) widget.controller.completedReps.value = value;
    Navigator.pop(context);
  }

  Widget _key(String label, {Color? color, VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap ?? () => _append(label),
        child: Container(
          margin: const EdgeInsets.all(5),
          height: 60,
          decoration: BoxDecoration(
            color: color ?? (widget.isDarkTheme
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06)),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: color != null ? Colors.white : null),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total          = widget.controller.activeExercise.value.repetitions;
    final bgColor        = widget.isDarkTheme ? const Color.fromARGB(255, 30, 30, 30) : Colors.white;
    final backspaceColor = widget.isDarkTheme
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.black.withValues(alpha: 0.1);

    return Container(
      decoration: BoxDecoration(color: bgColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(10)),
          ),
          const SizedBox(height: 20),
          Text('Quantas repetições você fez?', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('Meta: $total reps', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: CbColors.darkGrey)),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: widget.isDarkTheme ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                _input.isEmpty ? '0' : _input,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: _input.isEmpty ? CbColors.darkGrey : CbColors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(children: [_key('1'), _key('2'), _key('3')]),
          Row(children: [_key('4'), _key('5'), _key('6')]),
          Row(children: [_key('7'), _key('8'), _key('9')]),
          Row(children: [_key('', onTap: () {}), _key('0'), _key('⌫', onTap: _backspace, color: backspaceColor)]),
          const SizedBox(height: 12),
          CbPrimaryBtn(label: CbTexts.cbContinue, onPressed: _confirm, paddingV: 15, paddingH: 45,)
        ],
      ),
    );
  }
}
