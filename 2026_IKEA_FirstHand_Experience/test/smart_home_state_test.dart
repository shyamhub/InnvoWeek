import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_home_demo/data/demo_home_data.dart';
import 'package:virtual_home_demo/models/device.dart';
import 'package:virtual_home_demo/state/smart_home_state.dart';

void main() {
  group('SmartHomeState', () {
    late SmartHomeState state;

    setUp(() {
      state = SmartHomeState();
    });

    tearDown(() {
      state.dispose();
    });

    test(
      'starts with three locally simulated rooms and living room lights',
      () {
        expect(state.rooms.map((room) => room.name), [
          'Living room',
          'Bedroom',
          'Kitchen',
        ]);
        expect(
          state
              .devicesForRoom(initialRoomId)
              .where((device) => device.type == DeviceType.light),
          hasLength(3),
        );
        expect(state.currentRoomId, initialRoomId);
      },
    );

    test('updates brightness, colour, and colour temperature locally', () {
      state.setBrightness('ceiling-light', 0.35);
      state.setColor('ceiling-light', const Color(0xFF9C85FF));
      state.setColorTemperature('floor-light', 4300);

      expect(state.device('ceiling-light').brightness, 0.35);
      expect(state.device('ceiling-light').isOn, isTrue);
      expect(state.device('ceiling-light').color, const Color(0xFF9C85FF));
      expect(state.device('floor-light').colorTemperature, 4300);
      expect(state.roomBrightness, closeTo((0.35 + 0.58 + 0.45) / 3, 0.001));
    });

    test(
      'good night switches off every light and closes every blind',
      () async {
        await state.activateScene(
          state.scenes.singleWhere((scene) => scene.id == 'good-night'),
        );

        for (final device in state.devicesForRoom('living-room')) {
          if (device.type == DeviceType.light) {
            expect(device.isOn, isFalse, reason: device.name);
          }
          if (device.type == DeviceType.blind) {
            expect(device.position, 0, reason: device.name);
          }
        }
        expect(state.device('bedroom-ceiling').isOn, isFalse);
        expect(state.device('bedroom-blind').position, 0);
        expect(state.device('kitchen-ceiling').isOn, isFalse);
        expect(state.device('kitchen-plug').isOn, isFalse);
        expect(state.activeScene?.id, 'good-night');
        expect(state.isSceneTransitioning, isFalse);
      },
    );

    test(
      'movie night dims lights, closes blinds, and leaves other devices alone',
      () async {
        final scene = state.scenes.singleWhere(
          (scene) => scene.id == 'movie-night',
        );
        var observedTransition = false;
        state.addListener(() {
          if (state.isSceneTransitioning &&
              state.device('ceiling-light').brightness == 0.2) {
            observedTransition = true;
          }
        });
        final activation = state.activateScene(scene);

        await Future<void>.delayed(const Duration(milliseconds: 300));

        expect(state.device('ceiling-light').brightness, 0.2);
        expect(state.device('ceiling-light').isOn, isTrue);
        expect(state.device('ceiling-light').color, state.scenes[1].color);
        expect(state.device('living-blind').position, 0);
        expect(state.device('bedroom-blind').position, 0);
        expect(state.device('speaker').isOn, isFalse);
        expect(observedTransition, isTrue);
        expect(state.isSceneTransitioning, isTrue);

        await activation;
        expect(state.isSceneTransitioning, isFalse);
      },
    );

    test(
      'good morning and party set brighter lights and open every blind',
      () async {
        for (final sceneId in ['good-morning', 'party']) {
          final scene = state.scenes.singleWhere(
            (scene) => scene.id == sceneId,
          );
          await state.activateScene(scene);

          for (final device in demoDevices) {
            final current = state.device(device.id);
            if (device.type == DeviceType.light) {
              expect(current.isOn, isTrue, reason: '$sceneId: ${current.name}');
              expect(
                current.brightness,
                scene.brightness,
                reason: '$sceneId: ${current.name}',
              );
              expect(
                current.color,
                scene.color,
                reason: '$sceneId: ${current.name}',
              );
            } else if (device.type == DeviceType.blind) {
              expect(current.position, 1, reason: '$sceneId: ${current.name}');
            }
          }
        }
      },
    );

    test('setting brightness to zero switches the light off', () {
      state.setBrightness('ceiling-light', 0);

      expect(state.device('ceiling-light').isOn, isFalse);
      expect(state.roomBrightness, closeTo((0.58 + 0.45) / 3, 0.001));
    });
  });
}
