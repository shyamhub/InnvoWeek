import 'package:virtual_home_demo/models/device.dart';
import 'package:virtual_home_demo/models/scene.dart';
import 'package:virtual_home_demo/services/device_service.dart';

class SceneService {
  const SceneService(this._deviceService);

  final DeviceService _deviceService;

  Future<void> activateScene(
    SmartScene scene, {
    required void Function() onApplied,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 140));

    for (final device in _deviceService.devices.values) {
      switch (device.type) {
        case DeviceType.light:
          _deviceService.setColor(device.id, scene.color);
          _deviceService.setBrightness(
            device.id,
            scene.lightsOn ? scene.brightness : 0,
          );
        case DeviceType.blind:
          _deviceService.setBlindPosition(device.id, scene.blindsOpen ? 1 : 0);
        case DeviceType.speaker:
        case DeviceType.smartPlug:
          break;
      }
    }

    onApplied();
    await Future<void>.delayed(const Duration(milliseconds: 1050));
  }
}
