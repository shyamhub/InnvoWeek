import 'package:flutter/material.dart';
import 'package:virtual_home_demo/state/smart_home_state.dart';
import 'package:virtual_home_demo/theme/app_theme.dart';
import 'package:virtual_home_demo/widgets/brightness_control.dart';
import 'package:virtual_home_demo/widgets/colour_control.dart';

class LightControlSheet extends StatelessWidget {
  const LightControlSheet({super.key, required this.deviceId});

  final String deviceId;

  @override
  Widget build(BuildContext context) {
    final state = SmartHomeScope.of(context);
    final device = state.device(deviceId);
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 10,
            bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 39,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDAD9D2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: device.isOn
                          ? device.color.withValues(alpha: 0.28)
                          : const Color(0xFFF0EFE9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const SizedBox(
                      width: 52,
                      height: 52,
                      child: Icon(
                        Icons.lightbulb_outline_rounded,
                        color: AppTheme.ink,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          device.name,
                          style: const TextStyle(
                            color: AppTheme.ink,
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Text(
                          'Virtual smart light',
                          style: TextStyle(
                            color: AppTheme.mutedInk,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: device.isOn,
                    onChanged: (value) => state.setPower(deviceId, value),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              const _ControlLabel(title: 'Brightness'),
              Row(
                children: [
                  Expanded(
                    child: BrightnessControl(
                      value: device.brightness,
                      onChanged: (value) =>
                          state.setBrightness(deviceId, value),
                    ),
                  ),
                  Text(
                    '${(device.brightness * 100).round()}%',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.mutedInk,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const _ControlLabel(title: 'Light colour'),
              const SizedBox(height: 14),
              ColourControl(
                value: device.color,
                onChanged: (color) => state.setColor(deviceId, color),
              ),
              const SizedBox(height: 23),
              _ControlLabel(
                title: 'Colour temperature · ${device.colorTemperature} K',
              ),
              Slider(
                value: device.colorTemperature.toDouble(),
                min: 2200,
                max: 6500,
                divisions: 43,
                label: '${device.colorTemperature} K',
                onChanged: (kelvin) =>
                    state.setColorTemperature(deviceId, kelvin.round()),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Warm',
                    style: TextStyle(color: AppTheme.mutedInk, fontSize: 12),
                  ),
                  Text(
                    'Cool',
                    style: TextStyle(color: AppTheme.mutedInk, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ControlLabel extends StatelessWidget {
  const _ControlLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppTheme.ink,
      ),
    );
  }
}
