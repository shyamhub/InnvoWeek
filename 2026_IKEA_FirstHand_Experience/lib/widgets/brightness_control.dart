import 'package:flutter/material.dart';
import 'package:virtual_home_demo/theme/app_theme.dart';

class BrightnessControl extends StatelessWidget {
  const BrightnessControl({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.brightness_low_outlined,
          color: AppTheme.mutedInk,
          size: 19,
        ),
        Expanded(
          child: Slider(
            value: value.clamp(0.0, 1.0),
            onChanged: onChanged,
            semanticFormatterCallback: (value) =>
                '${(value * 100).round()} percent brightness',
          ),
        ),
        const Icon(
          Icons.brightness_high_rounded,
          color: AppTheme.ink,
          size: 19,
        ),
      ],
    );
  }
}
