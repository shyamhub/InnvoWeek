import 'package:flutter/material.dart';
import 'package:virtual_home_demo/models/device.dart';
import 'package:virtual_home_demo/state/smart_home_state.dart';
import 'package:virtual_home_demo/theme/app_theme.dart';
import 'package:virtual_home_demo/widgets/brightness_control.dart';
import 'package:virtual_home_demo/widgets/device_card.dart';
import 'package:virtual_home_demo/widgets/light_control.dart';
import 'package:virtual_home_demo/widgets/room_view.dart';
import 'package:virtual_home_demo/widgets/scene_card.dart';

class RoomScreen extends StatelessWidget {
  const RoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = SmartHomeScope.of(context);
    final room = state.currentRoom;
    final devices = state.devicesForRoom(room.id);
    final lights = devices
        .where((device) => device.type == DeviceType.light)
        .toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back to your home',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text(
          'YOUR VIRTUAL HOME',
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Home overview',
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.home_outlined),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(22, 5, 22, 30),
          children: [
            Text(
              room.name,
              style: const TextStyle(
                color: AppTheme.ink,
                fontSize: 34,
                height: 1.1,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              room.description,
              style: const TextStyle(color: AppTheme.mutedInk, fontSize: 14),
            ),
            const SizedBox(height: 17),
            SizedBox(
              height: (MediaQuery.sizeOf(context).width * 0.7)
                  .clamp(245.0, 360.0)
                  .toDouble(),
              child: RoomView(
                room: room,
                devices: devices,
                brightness: state.roomBrightness,
                ambientColor: state.roomColor,
                blindPosition: state.blindPosition,
              ),
            ),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              child: Row(
                key: ValueKey(
                  state.activeScene?.id ?? state.roomBrightness > 0,
                ),
                children: [
                  Icon(
                    state.isSceneTransitioning
                        ? Icons.auto_awesome
                        : Icons.wb_twilight_rounded,
                    size: 15,
                    color: AppTheme.blue,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    state.isSceneTransitioning
                        ? 'Making the room feel ${state.activeScene?.name.toLowerCase()}…'
                        : state.activeScene != null
                        ? 'A little moment called ${state.activeScene!.name}'
                        : state.roomBrightness > 0
                        ? 'Just the right kind of glow.'
                        : 'A calm room, waiting for you.',
                    style: const TextStyle(
                      color: AppTheme.mutedInk,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${(state.roomBrightness * 100).round()}% LIGHT',
                    style: const TextStyle(
                      color: AppTheme.mutedInk,
                      fontSize: 9,
                      letterSpacing: 0.6,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'A different feeling',
                    style: TextStyle(
                      color: AppTheme.ink,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (state.isSceneTransitioning)
                  const SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 105,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: state.scenes.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final scene = state.scenes[index];
                  return SceneCard(
                    scene: scene,
                    selected: state.activeScene?.id == scene.id,
                    onTap: state.isSceneTransitioning
                        ? null
                        : () => state.activateScene(scene),
                  );
                },
              ),
            ),
            const SizedBox(height: 26),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'The little details',
                    style: TextStyle(
                      color: AppTheme.ink,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  '${devices.length} devices',
                  style: const TextStyle(
                    color: AppTheme.mutedInk,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 11),
            for (final light in lights) ...[
              _LightCard(
                device: light,
                onBrightnessChanged: (value) =>
                    state.setBrightness(light.id, value),
                onOpen: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  backgroundColor: AppTheme.paper,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  builder: (context) => LightControlSheet(deviceId: light.id),
                ),
              ),
              const SizedBox(height: 10),
            ],
            for (final device in devices.where(
              (device) => device.type != DeviceType.light,
            )) ...[
              DeviceCard(
                device: device,
                onToggle: (value) {
                  if (device.type == DeviceType.blind) {
                    state.setBlindPosition(device.id, value ? 1 : 0);
                  } else {
                    state.setPower(device.id, value);
                  }
                },
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Your smart home journey starts whenever you are.',
                    ),
                  ),
                );
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(53),
                backgroundColor: AppTheme.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.home_work_outlined, size: 19),
              label: const Text('Set up your real home'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LightCard extends StatelessWidget {
  const _LightCard({
    required this.device,
    required this.onBrightnessChanged,
    required this.onOpen,
  });

  final SmartDevice device;
  final ValueChanged<double> onBrightnessChanged;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: ValueKey('light-card-${device.id}'),
      color: AppTheme.paper,
      borderRadius: BorderRadius.circular(19),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(13, 10, 8, 4),
        child: Column(
          children: [
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 41,
                  height: 41,
                  decoration: BoxDecoration(
                    color: device.isOn
                        ? device.color.withValues(alpha: 0.3)
                        : AppTheme.canvas,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    Icons.lightbulb_outline_rounded,
                    color: device.isOn ? AppTheme.ink : AppTheme.mutedInk,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: InkWell(
                    onTap: onOpen,
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            device.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.ink,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            device.isOn
                                ? '${(device.brightness * 100).round()}% · Tap for colour'
                                : 'Off · Tap to explore',
                            style: const TextStyle(
                              color: AppTheme.mutedInk,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Switch.adaptive(
                  key: ValueKey('light-switch-${device.id}'),
                  value: device.isOn,
                  onChanged: (value) {
                    final state = SmartHomeScope.of(context);
                    state.setPower(device.id, value);
                  },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
            BrightnessControl(
              value: device.brightness,
              onChanged: onBrightnessChanged,
            ),
          ],
        ),
      ),
    );
  }
}
