import 'package:flutter/material.dart';
import 'package:virtual_home_demo/models/device.dart';

abstract class DeviceService {
  Map<String, SmartDevice> get devices;

  SmartDevice setPower(String deviceId, bool isOn);

  SmartDevice setBrightness(String deviceId, double brightness);

  SmartDevice setColor(String deviceId, Color color);

  SmartDevice setColorTemperature(String deviceId, int kelvin);

  SmartDevice setBlindPosition(String deviceId, double position);
}
