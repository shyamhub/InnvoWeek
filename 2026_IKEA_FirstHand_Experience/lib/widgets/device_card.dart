import 'package:flutter/material.dart';
import 'package:virtual_home_demo/models/device.dart';
import 'package:virtual_home_demo/theme/app_theme.dart';

class DeviceCard extends StatelessWidget {
  const DeviceCard({
    super.key,
    required this.device,
    required this.onToggle,
    this.onTap,
  });

  final SmartDevice device;
  final ValueChanged<bool> onToggle;
  final VoidCallback? onTap;

  IconData get _icon => switch (device.type) {
    DeviceType.light => Icons.lightbulb_outline_rounded,
    DeviceType.blind => Icons.blinds_outlined,
    DeviceType.speaker => Icons.speaker_outlined,
    DeviceType.smartPlug => Icons.power_outlined,
  };

  String get _status => switch (device.type) {
    DeviceType.light =>
      device.isOn ? '${(device.brightness * 100).round()}% brightness' : 'Off',
    DeviceType.blind => device.position > 0.5 ? 'Open' : 'Closed',
    DeviceType.speaker => device.isOn ? 'On' : 'Standby',
    DeviceType.smartPlug => device.isOn ? 'On' : 'Off',
  };

  @override
  Widget build(BuildContext context) {
    final isLightOn = device.type == DeviceType.light && device.isOn;
    return Material(
      color: AppTheme.paper,
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(19),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isLightOn
                      ? device.color.withValues(alpha: 0.3)
                      : AppTheme.canvas,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: isLightOn
                      ? [
                          BoxShadow(
                            color: device.color.withValues(alpha: 0.2),
                            blurRadius: 14,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  _icon,
                  size: 20,
                  color: isLightOn ? AppTheme.ink : AppTheme.mutedInk,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _status,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.mutedInk,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: device.isOn,
                onChanged: onToggle,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
