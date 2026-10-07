import 'package:flutter/material.dart';
import 'package:virtual_home_demo/data/demo_home_data.dart';
import 'package:virtual_home_demo/models/device.dart';
import 'package:virtual_home_demo/services/device_service.dart';

class DemoDeviceService implements DeviceService {
  DemoDeviceService()
    : _devices = {for (final device in demoDevices) device.id: device};

  final Map<String, SmartDevice> _devices;

  @override
  Map<String, SmartDevice> get devices => Map.unmodifiable(_devices);

  SmartDevice _update(
    String deviceId,
    SmartDevice Function(SmartDevice device) update,
  ) {
    final device = _devices[deviceId];
    if (device == null) {
      throw ArgumentError.value(deviceId, 'deviceId', 'Unknown device');
    }
    final updated = update(device);
    _devices[deviceId] = updated;
    return updated;
  }

  @override
  SmartDevice setPower(String deviceId, bool isOn) {
    return _update(deviceId, (device) {
      return device.copyWith(
        isOn: isOn,
        brightness:
            device.type == DeviceType.light && isOn && device.brightness == 0
            ? 0.8
            : device.brightness,
      );
    });
  }

  @override
  SmartDevice setBrightness(String deviceId, double brightness) {
    final value = brightness.clamp(0.0, 1.0).toDouble();
    return _update(deviceId, (device) {
      return device.copyWith(brightness: value, isOn: value > 0);
    });
  }

  @override
  SmartDevice setColor(String deviceId, Color color) {
    return _update(deviceId, (device) => device.copyWith(color: color));
  }

  @override
  SmartDevice setColorTemperature(String deviceId, int kelvin) {
    final value = kelvin.clamp(2200, 6500).toInt();
    final warmth = (value - 2200) / (6500 - 2200);
    final color = Color.lerp(
      const Color(0xFFFFB85C),
      const Color(0xFFDCEAFF),
      warmth,
    )!;
    return _update(
      deviceId,
      (device) => device.copyWith(colorTemperature: value, color: color),
    );
  }

  @override
  SmartDevice setBlindPosition(String deviceId, double position) {
    final value = position.clamp(0.0, 1.0).toDouble();
    return _update(
      deviceId,
      (device) => device.copyWith(position: value, isOn: value > 0),
    );
  }
}
