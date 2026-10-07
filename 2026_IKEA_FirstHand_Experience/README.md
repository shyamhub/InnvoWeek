# Home smart: Virtual Home

An offline Flutter proof of concept for exploring an IKEA-inspired smart home
without an account, hub, physical devices, or network access. Lights, blinds,
scenes, and their state are simulated locally on the device.

## Run the app

```sh
flutter pub get
flutter run
```

Choose an iOS simulator or Android emulator/device in Flutter to run the
respective native app.

## Explore

1. Tap **Explore IKEA Home smart**.
2. Choose the living room, bedroom, or kitchen.
3. Toggle lights and adjust their brightness.
4. Tap a light to explore its colour and colour-temperature controls.
5. Choose a scene to animate its lighting and blinds.

## Architecture

```text
lib/
  models/    Rooms, devices, and scenes
  data/      Local rooms, devices, and scene definitions
  services/  DeviceService, its local demo implementation, and scene activation
  state/     Observable SmartHomeState and its lightweight widget scope
  screens/   Welcome, room-picker, and room-control screens
  widgets/   Animated room illustration, light controls, device and scene cards
  theme/     Shared visual theme
```

`DeviceService` separates device operations from widgets. `DemoDeviceService`
is the standalone local implementation; room screens only interact with the
observable `SmartHomeState`. Adding another `DeviceService` implementation
does not require coupling the UI to its transport or hardware.

## Test and analyze

```sh
flutter analyze
flutter test
```

There are no third-party runtime dependencies, backend services, real-device
integrations, or network requests.
