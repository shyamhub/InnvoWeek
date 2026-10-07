import 'package:flutter/material.dart';
import 'package:virtual_home_demo/data/demo_home_data.dart';
import 'package:virtual_home_demo/models/device.dart';
import 'package:virtual_home_demo/models/room.dart';
import 'package:virtual_home_demo/models/scene.dart';
import 'package:virtual_home_demo/services/demo_device_service.dart';
import 'package:virtual_home_demo/services/device_service.dart';
import 'package:virtual_home_demo/services/scene_service.dart';

class SmartHomeState extends ChangeNotifier {
  SmartHomeState({DeviceService? deviceService})
    : _deviceService = deviceService ?? DemoDeviceService() {
    _sceneService = SceneService(_deviceService);
    _deviceService.devices.forEach((id, device) {
      _devices[id] = device;
    });
  }

  final DeviceService _deviceService;
  late final SceneService _sceneService;
  final Map<String, SmartDevice> _devices = {};
  String _currentRoomId = initialRoomId;
  SmartScene? _activeScene;
  bool _isSceneTransitioning = false;

  List<Room> get rooms => demoRooms;
  List<SmartScene> get scenes => demoScenes;
  String get currentRoomId => _currentRoomId;
  Room get currentRoom => rooms.firstWhere((room) => room.id == _currentRoomId);
  SmartScene? get activeScene => _activeScene;
  bool get isSceneTransitioning => _isSceneTransitioning;

  List<SmartDevice> devicesForRoom(String roomId) {
    return _devices.values.where((device) => device.roomId == roomId).toList();
  }

  SmartDevice device(String id) {
    final device = _devices[id];
    if (device == null) {
      throw ArgumentError.value(id, 'id', 'Unknown device');
    }
    return device;
  }

  double get roomBrightness {
    return brightnessForRoom(_currentRoomId);
  }

  double brightnessForRoom(String roomId) {
    final lights = devicesForRoom(
      roomId,
    ).where((device) => device.type == DeviceType.light).toList();
    if (lights.isEmpty) {
      return 0;
    }
    return lights.fold<double>(
          0,
          (total, light) => total + (light.isOn ? light.brightness : 0),
        ) /
        lights.length;
  }

  Color get roomColor {
    return colorForRoom(_currentRoomId);
  }

  Color colorForRoom(String roomId) {
    final lights = devicesForRoom(roomId)
        .where((device) => device.type == DeviceType.light && device.isOn)
        .toList();
    if (lights.isEmpty) {
      return const Color(0xFFFFD398);
    }
    return lights
        .skip(1)
        .fold<Color>(
          lights.first.color,
          (color, light) =>
              Color.lerp(color, light.color, 1 / (lights.indexOf(light) + 1))!,
        );
  }

  double get blindPosition {
    return blindPositionForRoom(_currentRoomId);
  }

  double blindPositionForRoom(String roomId) {
    return devicesForRoom(roomId)
            .where((device) => device.type == DeviceType.blind)
            .firstOrNull
            ?.position ??
        1;
  }

  void selectRoom(String roomId) {
    if (!rooms.any((room) => room.id == roomId)) {
      throw ArgumentError.value(roomId, 'roomId', 'Unknown room');
    }
    _currentRoomId = roomId;
    notifyListeners();
  }

  void _save(SmartDevice device) {
    _devices[device.id] = device;
    _activeScene = null;
    notifyListeners();
  }

  void setPower(String id, bool isOn) =>
      _save(_deviceService.setPower(id, isOn));

  void setBrightness(String id, double brightness) {
    _save(_deviceService.setBrightness(id, brightness));
  }

  void setColor(String id, Color color) =>
      _save(_deviceService.setColor(id, color));

  void setColorTemperature(String id, int kelvin) {
    _save(_deviceService.setColorTemperature(id, kelvin));
  }

  void setBlindPosition(String id, double position) {
    _save(_deviceService.setBlindPosition(id, position));
  }

  Future<void> activateScene(SmartScene scene) async {
    if (_isSceneTransitioning) {
      return;
    }
    _isSceneTransitioning = true;
    _activeScene = scene;
    notifyListeners();

    try {
      await _sceneService.activateScene(
        scene,
        onApplied: () {
          _devices.addAll(_deviceService.devices);
          notifyListeners();
        },
      );
    } finally {
      _isSceneTransitioning = false;
      notifyListeners();
    }
  }
}

class SmartHomeScope extends InheritedNotifier<SmartHomeState> {
  const SmartHomeScope({
    super.key,
    required SmartHomeState notifier,
    required super.child,
  }) : super(notifier: notifier);

  static SmartHomeState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SmartHomeScope>();
    assert(scope != null, 'SmartHomeScope was not found above this widget.');
    return scope!.notifier!;
  }
}
