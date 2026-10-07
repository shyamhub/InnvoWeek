import 'package:flutter/material.dart';

enum DeviceType { light, blind, speaker, smartPlug }

class SmartDevice {
  const SmartDevice({
    required this.id,
    required this.name,
    required this.roomId,
    required this.type,
    required this.isOn,
    required this.capabilities,
    this.brightness = 0,
    this.color = const Color(0xFFFFD39A),
    this.colorTemperature = 2700,
    this.position = 0,
  });

  final String id;
  final String name;
  final String roomId;
  final DeviceType type;
  final bool isOn;
  final Set<String> capabilities;
  final double brightness;
  final Color color;
  final int colorTemperature;
  final double position;

  SmartDevice copyWith({
    bool? isOn,
    double? brightness,
    Color? color,
    int? colorTemperature,
    double? position,
  }) {
    return SmartDevice(
      id: id,
      name: name,
      roomId: roomId,
      type: type,
      isOn: isOn ?? this.isOn,
      capabilities: capabilities,
      brightness: brightness ?? this.brightness,
      color: color ?? this.color,
      colorTemperature: colorTemperature ?? this.colorTemperature,
      position: position ?? this.position,
    );
  }
}
