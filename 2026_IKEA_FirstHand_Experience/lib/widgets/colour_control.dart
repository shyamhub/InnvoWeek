import 'package:flutter/material.dart';
import 'package:virtual_home_demo/theme/app_theme.dart';

const lightColors = <(String, Color)>[
  ('Warm', Color(0xFFFFC875)),
  ('Soft', Color(0xFFFFE7C1)),
  ('Cool', Color(0xFFE0ECFF)),
  ('Blue', Color(0xFF79A7FF)),
  ('Lilac', Color(0xFFA78BFA)),
  ('Rose', Color(0xFFFF8FBA)),
];

class ColourControl extends StatelessWidget {
  const ColourControl({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final Color value;
  final ValueChanged<Color> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 15,
      runSpacing: 12,
      children: [
        for (final (name, color) in lightColors)
          Semantics(
            button: true,
            selected: value.toARGB32() == color.toARGB32(),
            label: '$name light colour',
            child: Tooltip(
              message: name,
              child: InkWell(
                onTap: () => onChanged(color),
                customBorder: const CircleBorder(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 38,
                  height: 38,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: value.toARGB32() == color.toARGB32()
                          ? AppTheme.ink
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.07),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
