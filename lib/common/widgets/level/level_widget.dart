import 'package:carboneto/common/widgets/custom_shapes/containers/rounded_countainer.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class LevelWidget extends StatelessWidget {
  const LevelWidget({
    super.key,
    required this.level,
    this.size = 7,
  });
  final DifficultyLevels level;
  final double size;

  @override
  Widget build(BuildContext context) {
    final levelStyle = CbHelperFunctions.parseLevelStyle(context, level);
    int value = levelStyle['levelValue'] as int;
    bool isElite = false;
    if (level.name == 'elite') {
      isElite = true;
    }
    const int maxLevel = 3; // Changed from 3 to 4 to support ELITE level

    return Row(
      spacing: 7,
      children: [
        Text(
          levelStyle['difficultyTitle'],
          style: TextStyle(
              letterSpacing: 1.5,
              fontSize: size,
              color: isElite
                  ? Colors.amber
                  : levelStyle['difficultyColor']),
        ),
        Row(
          spacing: 2,
          children: [
            ...(List.generate(
                  value,
                  (i) => CbRoundedContainer(
                    width: size,
                    height: size,
                    border: Border.all(color: (levelStyle['difficultyBorder'])),
                    backgroundColor: levelStyle['difficultyColor'],
                  ),
                ) +
                List.generate(
                  maxLevel - value,
                  (i) => CbRoundedContainer(
                    width: size,
                    height: size,
                    border: Border.all(
                        color: levelStyle['difficultyBorder'].withAlpha(150)),
                    backgroundColor:
                        levelStyle['difficultyColor'].withAlpha(150),
                  ),
                )),
          ],
        ),
      ],
    );
  }
}
